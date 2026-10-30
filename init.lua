-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = "n"
vim.g.maplocalleader = "n"
-- 基础设置（在加载插件前）
-- ==========================================
--require("config.options")
require("config.lazy")
require("config.comments")
require("config.keymaps")
--require("config.autocmds")
require("config.lsp")

--------------------------------------------------
--  自动模板插入（Lua + Neovim API）
--------------------------------------------------

local function cursor_at_line_col(line, col)
  -- 0-based line, 0-based col
  vim.api.nvim_win_set_cursor(0, { line, col })
end

--------------------------------------------------
-- C++ 模板
--------------------------------------------------
local function insert_cpp_template()
  local lines = {
    "#include <iostream>",
    "",
    "int main(int argc, char *argv[]) {",
    "    ",
    '    std::cout << "" ;',
    "    return 0;",
    "}",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  cursor_at_line_col(4, 4) -- 第4行，第5列
end

--------------------------------------------------
-- C 模板
--------------------------------------------------
local function insert_c_template()
  local lines = {
    "#include <stdio.h>",
    "",
    "int main(int argc, char *argv[]) {",
    "    ",
    '    printf("\\n");',
    "    return 0;",
    "}",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  cursor_at_line_col(4, 4)
end

--------------------------------------------------
-- HTML 模板
--------------------------------------------------
local function insert_html_template()
  local lines = {
    "<!DOCTYPE html>",
    '<html lang="en">',
    "<head>",
    '    <meta charset="UTF-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1.0"/>',
    "    <title>Document</title>",
    "</head>",
    "<body>",
    "    <h1>Hello, world!</h1>",
    "</body>",
    "</html>",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  cursor_at_line_col(7, 4) -- <body> 内
end

--------------------------------------------------
-- Rust 模板
--------------------------------------------------
local function insert_rust_template()
  local lines = {
    "fn main() {",
    '    println!("Hello, world!");',
    "}",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  cursor_at_line_col(1, 4) -- fn 体内
end

--------------------------------------------------
-- 自动命令组（Lua 风格）
--------------------------------------------------
local group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  group = group,
  callback = insert_cpp_template,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.c",
  group = group,
  callback = insert_c_template,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.html",
  group = group,
  callback = insert_html_template,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.rs",
  group = group,
  callback = insert_rust_template,
})

-- 自动随文件切换工作目录（安全版）
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(dir) == 1 then
      vim.fn.chdir(dir)
    end
  end,
  desc = "Auto CD to file directory (safe)",
})

-- 手动按键也可切（安全版）
vim.keymap.set("n", "<leader>cd", function()
  local dir = vim.fn.expand("%:p:h")
  if vim.fn.isdirectory(dir) == 1 then
    vim.fn.chdir(dir)
    vim.notify("PWD → " .. dir, vim.log.levels.INFO)
  else
    vim.notify("目录不存在: " .. dir, vim.log.levels.WARN)
  end
end, { desc = "Set pwd to current file dir (safe)" })
