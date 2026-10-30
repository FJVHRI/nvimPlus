-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
--   pattern = { "*" },
--   command = "silent! wall",
--   nested = true,
-- })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- 注：文件树"默认关闭"的逻辑不能写在这里——本文件在 VeryLazy 事件才加载，
-- 那时 UIEnter/VimEnter 早已过去，autocmd 永远不会被触发。
-- 实际实现放在 lua/plugins/ui.lua 的 snacks 插件 spec 的 init（启动早期）。
