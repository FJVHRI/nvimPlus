-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Insert a line up/down in normal mode
keymap.set("n", "O", "O<Esc>", opts)
keymap.set("n", "o", "o<Esc>", opts)

-- Insert one line below in insert mode without break current line)
keymap.set(
  "i",
  "<C-j>",
  "<Esc>A<CR>",
  vim.tbl_extend("force", opts, { desc = "Insert new line below from anywhere in line" })
)

-- Add the default action for <leader>+k to open the URL in win host's default browser(for wsl2)
keymap.set("n", "<leader>k", function()
  -- Get the word under the cursor (which could be a URL or keyword)
  local word = vim.fn.expand("<cfile>")
  -- 如果光标下不是 URL，可以尝试获取整个行并查找 URL
  local line = vim.fn.getline(".")
  local url = line:match("https?://[%w-_%.%?%.:/%+=&@%%]+") or word
  if url then
    -- Invoke cmd is faster than wslview command to open win host's browser
    vim.fn.system("/mnt/c/Windows/System32/cmd.exe /c start " .. url)
  else
    vim.lsp.buf.hover() -- 如果没有找到 URL，回退到 LSP 悬浮窗口
  end
end, vim.tbl_extend("force", opts, { desc = "Open the URL in win host" }))

--New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<S-tab>", ":tabprev<CR>", opts)

-- Move window
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><", opts)
keymap.set("n", "<C-w><right>", "<C-w>>", opts)
keymap.set("n", "<C-w><up>", "<C-w>+", opts)
keymap.set("n", "<C-w><down>", "<C-w>-", opts)

-- Open/Close Terminal
keymap.set("n", "<c-\\>", function()
  Snacks.terminal()
end, vim.tbl_extend("force", opts, { desc = "Terminal (cwd Dir)" }))
keymap.set("t", "<C-\\>", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Hide Terminal" }))

-- Jump next/prev word in InsertMode
keymap.set("i", "<C-f>", "<Esc>l<cmd>lua require('spider').motion('w')<CR>i", opts)
keymap.set("i", "<C-b>", "<Esc><cmd>lua require('spider').motion('b')<CR>i", opts)

keymap.set("n", ".i", function()
  require("dap").step_into()
end, vim.tbl_extend("force", opts, { desc = "Step Into" }))

keymap.set("n", ".o", function()
  require("dap").step_out()
end, vim.tbl_extend("force", opts, { desc = "Step Out" }))

keymap.set("n", ".l", function()
  require("dap").step_over()
end, vim.tbl_extend("force", opts, { desc = "Step Over" }))

-- 普通模式：按 q 保存并退出（用户明确不需要宏录制，q 让位给保存退出）
vim.keymap.set("n", "q", ":wq<CR>", { silent = true, desc = "Save & Quit" })
-- 快速保存也可用 <leader>W / 原生 ZZ；如需恢复宏录制，把上面那行注释掉即可
-- 普通模式下 ; 进入命令模式（代替 Shift+:）
vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })

-- ============ 从 ~/.config/newnvim（旧配置）移植的习惯映射 ============

-- 退出 / 保存
keymap.set("n", "<leader>q", ":q<CR>", opts)               -- 退出
keymap.set("n", "<leader>Q", ":qa!<CR>", opts)             -- 强制退出所有
keymap.set("n", "<leader>w", ":w<CR>", opts)               -- 保存
keymap.set("n", "<leader>W", ":wq<CR>", opts)              -- 保存并退出
keymap.set("n", "<leader>s", ":source $MYVIMRC<CR>", opts) -- 重载配置

-- 窗口导航（与 LazyVim 默认一致，显式声明保证习惯稳定）
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- 调整窗口大小
keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- 缓冲区
keymap.set("n", "<leader>B", ":bprevious<CR>", opts)

-- 行移动（Visual 模式下移动选区）
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 取消高亮
keymap.set("n", "<leader>h", ":nohl<CR>", opts)

-- 系统剪贴板
keymap.set("v", "<leader>y", '"+y', opts)
keymap.set("n", "<leader>p", '"+p', opts)
keymap.set("n", "<leader>P", '"+P', opts)

-- 搜索/翻页保持居中
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- <leader>k 修好 Linux 路径（原来写死 /mnt/c/.../cmd.exe，是 WSL 残留，本机无效）
keymap.set("n", "<leader>k", function()
  local line = vim.fn.getline(".")
  local url = line:match("https?://[%w-_%.%?%.:/%+=&@%%]+") or vim.fn.expand("<cfile>")
  if not url or url == "" then
    vim.lsp.buf.hover()
    return
  end
  if vim.fn.executable("wslview") == 1 then
    vim.fn.system({ "wslview", url })
  elseif vim.fn.executable("xdg-open") == 1 then
    vim.fn.system({ "xdg-open", url })
  else
    vim.lsp.buf.hover()
  end
end, vim.tbl_extend("force", opts, { desc = "Open URL in browser" }))

-- <leader>uu：Dashboard 与上一个文件互相切换
local last_buf = nil
keymap.set("n", "<leader>uu", function()
  if vim.bo.filetype == "snacks_dashboard" then
    if last_buf and vim.api.nvim_buf_is_valid(last_buf) then
      vim.api.nvim_set_current_buf(last_buf)
    else
      vim.cmd("enew")
    end
  else
    last_buf = vim.api.nvim_get_current_buf()
    require("snacks").dashboard()
  end
end, { desc = "Toggle Snacks Dashboard" })

-- 空格+e 打开文件树（自动兼容新旧版本）
-- ⚠️ 注意：keymap.set 绝不能注释掉——下面的函数体一旦裸露在文件顶层，
-- 会在 VeryLazy 加载本文件时无条件执行 Snacks.explorer()，导致每次启动都弹出文件树。
keymap.set("n", "<space>e", function()
  -- 对齐 oldnvim 的守卫写法：Snacks 未加载时给出提示而不是报错
  if Snacks and Snacks.picker then
    Snacks.picker.explorer()
  else
    vim.notify("Snacks not loaded", vim.log.levels.ERROR)
  end
end, vim.tbl_extend("force", opts, { desc = "Open File Explorer" }))

