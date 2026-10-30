-- coc-sort.nvim 功能测试（headless）
-- 运行：nvim -u NONE -i NONE --headless -l ~/.config/nvim/scripts/coc_sort_test.lua
-- 覆盖：coc 语义 transform（tier/cost/bonus + 丢弃无匹配）、C 子进程往返、
--       comparator 逐字段复刻 coc compare、词频落盘、词典补全源。
local pass, fail = 0, 0
local function check(name, cond, detail)
  if cond then pass = pass + 1; print(("ok   %s"):format(name))
  else fail = fail + 1; print(("FAIL %s  %s"):format(name, tostring(detail))) end
end

vim.opt.runtimepath:prepend("/home/a/.config/nvim/coc-sort.nvim")
local csort = require("coc-sort")
local frequency = require("coc-sort.frequency")
local WordSource = require("coc-sort.word")

local FREQ = "/home/a/.config/nvim/scripts/.coc-sort-test-freq.json"
local DICT = "/home/a/.config/nvim/scripts/.coc-sort-test-dict.txt"
os.remove(FREQ); os.remove(FREQ .. ".tmp")

-- ---------- 场景 A：默认路径 + 真实 sortd + 词频 ----------
csort.setup({ frequency_path = FREQ }) -- 不传 sortd_path：默认插件自带 native/sortd
check("默认 sortd 路径指向插件二进制",
  csort.stats().sortd_path == "/home/a/.config/nvim/coc-sort.nvim/native/sortd",
  csort.stats().sortd_path)
check("自带 sortd 可执行", vim.fn.executable(csort.stats().sortd_path) == 1)
check("plugin_root 正确", csort.stats().plugin_root == "/home/a/.config/nvim/coc-sort.nvim",
  csort.stats().plugin_root)

local f = io.open(FREQ, "w"); f:write('{"delta": 50}'); f:close()

local ctx = { get_keyword = function() return "d" end, line = "d", cursor = { 1, 2 } }
local items = {
  { label = "dropbar", score_offset = 5 },
  { label = "delta", score_offset = 5 },
  { label = "dashboard", score_offset = 5 },
  { label = "foobar", score_offset = 5 }, -- 不含 d 的噪声词
}
local out = csort.transform(ctx, items)
check("transform 丢弃无匹配项 (coc 语义)", #out == 3, #out)
local by_label = {}
for _, it in ipairs(out) do by_label[it.label] = it end
check("delta 指标: tier=0", by_label.delta.coc_tier == 0, by_label.delta.coc_tier)
check("delta 词频加成=12 (cap)", by_label.delta.coc_bonus == 12, by_label.delta.coc_bonus)
check("dropbar cost=6 (len 7 - 输入 1)", by_label.dropbar.coc_cost == 6, by_label.dropbar.coc_cost)
check("C 端排名已挂", by_label.delta.coc_rank ~= nil, by_label.delta.coc_rank)

-- 用真实 comparator 排序，验证 coc compare 语义：
-- tier 同 0 → cost−bonus：delta(5−12=−7) < dropbar(5) < dashboard(7)
table.sort(out, csort.comparator)
check("排序: delta 第一 (词频上浮)", out[1].label == "delta", out[1].label)
check("排序: dropbar 第二 (前缀更短)", out[2].label == "dropbar", out[2].label)
check("排序: dashboard 第三", out[3].label == "dashboard", out[3].label)
check("stats: sortd daemon alive", csort.stats().sortd_running == true, csort.stats().sortd_restarts)

-- 词频计数 + 落盘
csort.count_accept({ label = "NewWord" })
vim.wait(700)
local saved = io.open(FREQ, "r")
check("frequency file saved", saved ~= nil)
if saved then
  local data = saved:read("*a"); saved:close()
  local ok, decoded = pcall(vim.json.decode, data)
  check("saved json valid", ok and type(decoded) == "table")
  check("newword counted (lowercase key)", ok and decoded.newword == 1, decoded and decoded.newword)
  check("delta preserved", ok and decoded.delta == 50, decoded and decoded.delta)
end
check("bonus cap", frequency.bonus("delta") == 12, frequency.bonus("delta"))

-- comparator 逐字段语义
check("tier 升序", csort.comparator({ coc_tier = 0, coc_cost = 9 }, { coc_tier = 1, coc_cost = 0 }) == true)
check("cost−bonus 升序", csort.comparator({ coc_tier = 0, coc_cost = 5, coc_bonus = 12 }, { coc_tier = 0, coc_cost = 0 }) == true)
check("priority 降序", csort.comparator({ coc_tier = 0, coc_cost = 0, coc_priority = 200 }, { coc_tier = 0, coc_cost = 0, coc_priority = 150 }) == true)
check("缺失指标让位 blink", csort.comparator({ coc_tier = 0 }, {}) == nil)

-- ---------- 场景 B：sortd 不可用 → Lua 指标（无 coc_rank，排序不变） ----------
csort._reset_daemon()
csort.setup({ frequency_path = FREQ, sortd_path = "/nonexistent/sortd" })
csort._set_frequency({ delta = 50 })
local items2 = {
  { label = "dropbar", score_offset = 5 },
  { label = "delta", score_offset = 5 },
  { label = "dashboard", score_offset = 5 },
  { label = "foobar", score_offset = 5 },
}
local out2 = csort.transform(ctx, items2)
check("lua 指标: 丢弃无匹配", #out2 == 3, #out2)
table.sort(out2, csort.comparator)
check("lua 排序: delta 第一", out2[1].label == "delta", out2[1].label)
check("lua 排序: dropbar 第二", out2[2].label == "dropbar", out2[2].label)
check("lua 排序: sortd 未运行", csort.stats().sortd_running == false)

-- ---------- 场景 C：空输入（显示全部，词频优先） ----------
csort._set_frequency({ delta = 50 })
local items3 = { { label = "alpha", score_offset = 5 }, { label = "delta", score_offset = 5 } }
local ctx0 = { get_keyword = function() return "" end, line = "", cursor = { 1, 1 } }
local out3 = csort.transform(ctx0, items3)
check("空输入: 不丢弃", #out3 == 2, #out3)
table.sort(out3, csort.comparator)
check("空输入: 词频词第一", out3[1].label == "delta", out3[1].label)

-- ---------- 场景 D：coc-word 词典源 ----------
csort._reset_daemon()
csort.setup({ frequency_path = FREQ })

local d = io.open(DICT, "w")
d:write("delta\ndashboard\ndropbar\ndashboarding\nzzz\n")
d:close()

local src = WordSource.new({
  dictionary_files = { DICT },
  case_insensitive = true,
  max_items = 3,
}, { name = "Dict" })

local function collect(input)
  local result = nil
  src:get_completions({ get_keyword = function() return input end }, function(resp) result = resp end)
  return result
end

local resp = collect("D") -- 大写验证大小写不敏感
check("word: returns response", resp ~= nil and type(resp) == "table")
-- 每次键入必须重新查询（否则旧池子 + 容错过滤会破坏 coc 排序，见 word.lua 注释）
check("word: is_incomplete 全 true",
  resp.is_incomplete_forward == true and resp.is_incomplete_backward == true)
check("word: capped at max_items", #resp.items == 3, #resp.items)
local labels = {}
for _, it in ipairs(resp.items) do labels[it.label] = true end
check("word: all prefix d", (function()
  for label in pairs(labels) do
    if label:lower():sub(1, 1) ~= "d" then return false end
  end
  return true
end)())
check("word: no zzz", labels.zzz == nil)
check("word: kind is number", type(resp.items[1].kind) == "number")

-- 源内排序：词频优先，其次长度
csort._set_frequency({ dashboard = 999 })
local resp2 = collect("d")
check("word: freq word first", resp2.items[1].label == "dashboard", resp2.items[1].label)
csort._set_frequency({})
local resp3 = collect("d")
check("word: shortest first without freq", resp3.items[1].label == "delta", resp3.items[1].label)

-- 真实 10k.txt 冒烟：'arg' 只返回 arg 前缀（coc 过滤语义）
local src10k = WordSource.new({
  dictionary_files = { "/home/a/.config/nvim/coc-sort.nvim/data/10k.txt" },
  case_insensitive = true,
  max_items = 200,
}, { name = "Dict" })
local resp10k = nil
src10k:get_completions({ get_keyword = function() return "arg" end }, function(r) resp10k = r end)
check("10k: 'arg' 前缀项返回", resp10k ~= nil and #resp10k.items > 0, resp10k and #resp10k.items)
local all_arg_prefix = true
local has_arg = false
for _, it in ipairs(resp10k.items or {}) do
  if it.label:lower():sub(1, 3) ~= "arg" then all_arg_prefix = false; break end
  if it.label:lower() == "arg" then has_arg = true end
end
check("10k: 全部 arg 前缀 (coc 过滤语义)", all_arg_prefix, all_arg_prefix)
check("10k: 'arg' 本尊在列", has_arg, has_arg)

os.remove(FREQ); os.remove(DICT)
print(fail == 0 and ("ALL PASS (%d)"):format(pass) or ("FAILURES: %d / %d"):format(fail, pass + fail))
