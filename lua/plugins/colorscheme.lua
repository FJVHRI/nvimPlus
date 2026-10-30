-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
    -- CyberDream 主题（唯一主题，最高优先级）
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false, -- 启动时立即加载
        priority = 1000, -- 最高优先级
        config = function()
            -- 1. 基础配置：启用真彩色 + 全局透明兜底（核心）
            vim.opt.termguicolors = true                     -- 确保霓虹色正常显示
            vim.opt.background = "dark"                      -- 固定深色模式
            -- 全局高亮组透明：覆盖所有区域的背景色
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- 主编辑区透明
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- 浮窗透明
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" }) -- 符号列透明
            vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" }) -- 光标行透明
            vim.api.nvim_set_hl(0, "LineNr", { bg = "none" }) -- 行号区透明
            vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" }) -- 折叠列透明

            -- 2. CyberDream 核心配置（开启全透明 + 保留鲜艳度）
            require("cyberdream").setup({
                variant = "default",
                transparent = true, -- 主题自身透明（关键开关）
                saturation = 1, -- 饱和度拉满，保留霓虹鲜艳度
                italic_comments = true,
                hide_fillchars = true,
                borderless_pickers = false,
                terminal_colors = true, -- 终端颜色适配透明
                cache = false,
                -- 霓虹鲜艳主题配置
                theme = {
                    base = "default",
                    accent = "neon", -- 霓虹色强调（最鲜艳）
                },
                -- 自定义霓虹色（透明下更突出）
                colors = {
                    dark = {
                        magenta = "#ff00ff", -- 亮洋红
                        green = "#00ff00", -- 亮绿
                        cyan = "#00ffff", -- 亮青
                    },
                },
                -- 浮窗透明（专门适配Telescope/Notify等弹窗）
                float = {
                    transparent = true,
                },
                -- 插件集成（确保所有弹窗/选框都透明）
                extensions = {
                    telescope = true,
                    notify = true,
                    mini = true,
                },
                -- 语法高亮强化（透明下更清晰）
                highlights = {
                    Comment = { fg = "#696969", bg = "none", italic = true },
                    Function = { fg = "#00ff00", bold = true }, -- 函数名亮绿加粗
                    Keyword = { fg = "#ff00ff", bold = true }, -- 关键字洋红加粗
                    String = { fg = "#ffff00" },      -- 字符串亮黄
                },
            })

            -- 设置 CyberDream 为唯一默认主题
            vim.cmd("colorscheme cyberdream")
        end,
    },

    -- Lualine 状态栏（适配 CyberDream 透明主题）
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- 自动适配 CyberDream 透明主题
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {},
                    globalstatus = true,
                },
                -- 状态栏也设置透明（关键补充）
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                -- 覆盖状态栏高亮，确保透明
                winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
            })
            -- 手动设置状态栏背景透明
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
        end,
    },
}
