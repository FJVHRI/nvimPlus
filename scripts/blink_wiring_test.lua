-- 验证 blink-cmp.lua 的 coc-sort.nvim 挂接点（headless）
-- 运行：nvim -u NONE -i NONE --headless -l ~/.config/nvim/scripts/blink_wiring_test.lua
vim.opt.runtimepath:prepend("/home/a/.config/nvim")
local spec = dofile("/home/a/.config/nvim/lua/plugins/blink-cmp.lua")
assert(type(spec) == "table" and spec[1] == "saghen/blink.cmp", "spec 表异常")
local opts = spec.opts
local csort = require("coc-sort")

local failed = false
local function check(name, cond, detail)
  print((cond and "ok   " or "FAIL ") .. name .. (cond and "" or ("  " .. tostring(detail))))
  if not cond then failed = true end
end

-- 桥接挂接点
check("fuzzy.sorts[1] 是 csort.comparator", opts.fuzzy.sorts[1] == csort.comparator)
check("fuzzy.sorts 含内置排序", #opts.fuzzy.sorts >= 5 and opts.fuzzy.sorts[2] == "exact")
check("sources.transform_items 是 csort.transform", opts.sources.transform_items == csort.transform)
check("<CR> 是函数包装", type(opts.keymap["<CR>"][1]) == "function" and opts.keymap["<CR>"][2] == "fallback")

-- 词典源替换
check("dictionary provider 用 coc-sort.word",
  opts.sources.providers.dictionary.module == "coc-sort.word",
  opts.sources.providers.dictionary.module)
check("词典文件随 coc-sort.nvim 插件打包（data/10k.txt）",
  opts.sources.providers.dictionary.opts.dictionary_files[1] == "/home/a/.config/nvim/coc-sort.nvim/data/10k.txt",
  opts.sources.providers.dictionary.opts.dictionary_files[1])
local dep_names = {}
for _, dep in ipairs(spec.dependencies) do
  dep_names[#dep_names + 1] = type(dep) == "table" and dep[1] or dep
end
local has_external_dict = false
for _, name in ipairs(dep_names) do
  if name:find("blink%-cmp%-dictionary") then has_external_dict = true end
end
check("不再依赖 blink-cmp-dictionary", has_external_dict == false, table.concat(dep_names, ","))

-- 布局与源不变
check("columns 三栏", #opts.completion.menu.draw.columns == 3)
check("sources.default 五源", #opts.sources.default == 5)

-- transform 语义冒烟：coc 指标 + 丢弃无匹配 + comparator 复刻 coc compare
local items = { { label = "delta", score_offset = 5 }, { label = "zzz", score_offset = 5 } }
local out = opts.sources.transform_items({ get_keyword = function() return "d" end }, items)
check("transform 冒烟: 无匹配项被丢弃", #out == 1 and out[1].label == "delta", #out)
check("transform 冒烟: coc 指标已挂", out[1].coc_tier ~= nil and out[1].coc_cost ~= nil)
check("comparator 冒烟: tier 升序",
  opts.fuzzy.sorts[1]({ coc_tier = 0, coc_cost = 9 }, { coc_tier = 1, coc_cost = 0 }) == true)
check("comparator 冒烟: cost−bonus 升序",
  opts.fuzzy.sorts[1]({ coc_tier = 0, coc_cost = 5, coc_bonus = 12 }, { coc_tier = 0, coc_cost = 0 }) == true)

-- 插件路径与默认二进制
local st = csort.stats()
check("sortd 默认指向插件二进制", st.sortd_path == "/home/a/.config/nvim/coc-sort.nvim/native/sortd", st.sortd_path)
check("sortd 二进制可执行", vim.fn.executable(st.sortd_path) == 1)
-- package.path 显式注入（lazy.nvim spec 加载时序问题的修复）必须生效
check("package.path 已注入插件 lua 目录",
  package.path:find("/home/a/.config/nvim/coc-sort.nvim/lua", 1, true) ~= nil, package.path)

print(failed and "WIRING FAILURES" or "WIRING ALL PASS")
