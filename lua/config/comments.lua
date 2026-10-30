-- ~/.config/nvim/lua/config/comments.lua
local langs = { "c", "cpp", "cuda", "python", "rust", "java", "javascript", "go", "html" }

for _, lang in ipairs(langs) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.comments:remove("://")
      vim.opt_local.comments:append("f://")
    end,
  })
end
