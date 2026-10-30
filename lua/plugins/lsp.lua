-- plugins/lsp.lua
-- 仅保留 Mason 和诊断配置（与 0.12 原生 LSP 兼容）

local plugins = {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
        "pyright",
        "clangd",
        "gopls",
        "rust-analyzer",
        "jdtls",
      },
      ui = {
        border = "rounded",
        backdrop = 100,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  -- 移除 nvim-lspconfig，使用 0.12 原生 API 在 config/lsp.lua 中配置
}

-- 诊断图标配置
local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local virtual_text_config_enabled = {
  spacing = 4,
  prefix = function(diagnostic)
    local icons = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
    }
    return icons[diagnostic.severity] or "●"
  end,
}

local virtual_text_config_disabled = {
  spacing = 0,
  prefix = "",
  format = function()
    return ""
  end,
}

local signs_config = {
  text = {
    [vim.diagnostic.severity.ERROR] = signs.Error,
    [vim.diagnostic.severity.WARN] = signs.Warn,
    [vim.diagnostic.severity.INFO] = signs.Info,
    [vim.diagnostic.severity.HINT] = signs.Hint,
  },
}

-- 默认诊断配置
vim.diagnostic.config({
  underline = true, -- 建议开启，更容易发现错误
  signs = signs_config,
  update_in_insert = false,
  virtual_text = virtual_text_config_enabled,
  virtual_lines = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- Snacks 快捷开关
local ok, snacks = pcall(require, "snacks")
if ok then
  snacks.toggle.diagnostics():map("<leader>td")

  snacks
    .toggle({
      name = "Virtual Lines",
      get = function()
        return vim.diagnostic.config().virtual_lines ~= false
      end,
      set = function(state)
        vim.diagnostic.config({ virtual_lines = state and { current_line = true } or false })
      end,
    })
    :map("<leader>tV")

  snacks
    .toggle({
      name = "Virtual Text",
      get = function()
        return vim.diagnostic.config().virtual_text ~= virtual_text_config_disabled
      end,
      set = function(state)
        vim.diagnostic.config({ virtual_text = state and virtual_text_config_enabled or virtual_text_config_disabled })
      end,
    })
    :map("<leader>tv")
end

return plugins
