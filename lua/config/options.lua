-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- lua/config/options.lua 顶部必须加
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.relativenumber = false -- 关闭相对行号
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.scrolloff = 4
vim.opt.splitkeep = "screen"
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.path:append({ "**" })
vim.opt.wrap = false
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.shell = "zsh"
-- vim.g.mkdp_port = "8000"
--
-- -- 搜索设置
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 其他
vim.opt.wrap = false -- 不自动换行
vim.opt.swapfile = false -- 不创建交换文件
vim.opt.backup = false -- 不创建备份文件
vim.opt.undofile = true -- 启用持久撤销

-- Lua 等价映射（Neovim 标准 API）
--local opts = { silent = true }
--vim.keymap.set("n", "mm", "<Plug>(coc-translator-p)", opts)
--vim.keymap.set("v", "mm", "<Plug>(coc-translator-pv)", opts)
