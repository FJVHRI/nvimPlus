local lines = vim.fn.readfile("/home/a/.config/nvim/.boxout.txt")
for i, l in ipairs(lines) do
  print(("[real] 第%d行 显示宽度=%d %s"):format(i, vim.fn.strdisplaywidth(l), vim.fn.strdisplaywidth(l) == 57 and "OK" or "<<< 不等宽"))
end
