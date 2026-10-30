return {
  {
    "folke/noice.nvim",
    enabled = true, -- 完全禁用
    opts = {
      -- ★ cmdline / 搜索框 居中
      -- noice 默认 cmdline.view = "cmdline_popup"（居中弹窗），但 LazyVim 默认开了
      -- presets.bottom_search = true，会把 /、? 搜索框强制改回底部长条（cmdline 视图）。
      -- 关掉它，搜索框就回到居中的 cmdline_popup。
      presets = {
        bottom_search = false,
      },
      -- `:` 命令框与 `/`、`?` 搜索框统一走居中的 cmdline_popup 视图
      cmdline = {
        view = "cmdline_popup",
      },
      views = {
        -- nui 里 position 写百分比 = (容器 - 窗口) * 比例，50% 即为真正居中
        cmdline_popup = {
          relative = "editor",
          position = { row = "50%", col = "50%" },
          size = { min_width = 60, width = "auto", max_width = 120, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
        },
      },
    },
  },
}
