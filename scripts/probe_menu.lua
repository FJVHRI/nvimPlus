-- 真实配置下的补全探针 v2（headless，完整启动后 dofile）
-- 运行：nvim --headless "+lua dofile('scripts/probe_menu.lua')" +qa
local function log(s) print("[probe] " .. s) end
local FK = function(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "m", true) end

-- ===== 准备 =====
vim.cmd("enew")
vim.bo.filetype = "cpp"
vim.cmd("silent! Lazy load blink.cmp")
vim.wait(800)
local ok_cmp, cmp = pcall(require, "blink.cmp")
if not ok_cmp then log("FATAL: " .. tostring(cmp)); return end
local list = require("blink.cmp.completion.list")
log("blink 已加载")

-- ===== 实验 A：插入模式键入 fv =====
FK("ifv") -- i 进插入模式 + fv
vim.wait(700)
log(("A: 行内容='%s' is_visible=%s 菜单项=%d"):format(
  vim.api.nvim_get_current_line(), tostring(cmp.is_visible()), #(list.items or {})))
for i, item in ipairs(list.items or {}) do
  if i <= 10 then
    log(("  [%d] %s (source=%s, tier=%s, cost=%s)"):format(i, item.label,
      item.source_name or "?", tostring(item.coc_tier), tostring(item.coc_cost)))
  end
end

-- ===== 实验 B：菜单可见时 Tab =====
local before_sel = list.selected_item_idx
FK("<Tab>")
vim.wait(300)
log(("B: Tab 后 selected %s -> %s"):format(tostring(before_sel), tostring(list.selected_item_idx)))

-- ===== 实验 C：snippet 激活 + 占位符内打字 + Tab（用户核心诉求） =====
FK("<Esc>")
vim.wait(100)
vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
FK("i") -- 进插入模式
vim.wait(100)
vim.api.nvim_feedkeys("fv", "m", true)
vim.wait(400)
local ls_ok, ls = pcall(require, "luasnip")
if not ls_ok then
  log("C: LuaSnip 加载失败: " .. tostring(ls))
else
  local ok_exp, exp_err = pcall(function() ls.expand() end)
  vim.wait(200)
  log(("C: expand=%s err=%s jumpable(1)=%s"):format(tostring(ok_exp), tostring(exp_err), tostring(ls.jumpable(1))))
  local ok_type, type_err = pcall(function()
    vim.api.nvim_feedkeys("abc", "m", true)
    vim.wait(500)
  end)
  log(("C: 占位符打字 ok=%s err=%s is_visible=%s jumpable=%s 行='%s'"):format(
    tostring(ok_type), tostring(type_err), tostring(cmp.is_visible()),
    tostring(ls.jumpable(1)), vim.api.nvim_get_current_line()))
  local c1 = vim.api.nvim_win_get_cursor(0)
  FK("<Tab>")
  vim.wait(300)
  local c2 = vim.api.nvim_win_get_cursor(0)
  log(("C: Tab 后 cursor (%d,%d)->(%d,%d) 列变=跳占位符/不变=循环菜单"):format(
    c1[1], c1[2], c2[1], c2[2]))
  log("C: 行内容='" .. vim.api.nvim_get_current_line() .. "'")
end
log("DONE")
