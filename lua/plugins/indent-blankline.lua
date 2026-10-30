-- ~/.config/nvim/lua/plugins/indent-blankline.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufEnter", -- 进文件时加载
    config = function()
      -- 7 色彩虹色定义（与 catppuccin-mocha 一致）
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      -- 注册高亮组（与 catppuccin-mocha 一致）
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      -- 插件配置
      require("ibl").setup({
        indent = { highlight = highlight },
        exclude = {
          filetypes = {
            "lspinfo",
            "lazy",
            "checkhealth",
            "help",
            "man",
            "gitcommit",
            "dashboard",
            "TelescopePrompt",
            "TelescopeResults",
            "alpha",
            "neo-tree",
          },
          buftypes = { "nofile", "terminal", "quickfix", "prompt" },
        },
      })
    end,
  },
}
