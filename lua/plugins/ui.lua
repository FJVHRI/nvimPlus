-- 1. 代码导航面包屑（顶部层级显示）
return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    config = function()
      vim.api.nvim_set_hl(0, "DropBarIconUISeparator", { fg = "#00ffff", bg = "none" })
      vim.api.nvim_set_hl(0, "DropBarMenuNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "DropBarMenuSel", { fg = "#000000", bg = "#00ffff", bold = true })
    end,
  },

  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      })
      opts.presets.lsp_doc_border = true
      opts.popup = { border = { style = "rounded", highlight = "CyberDreamCyan" } }
      opts.notify = { view = "mini", opts = { border = { style = "rounded", highlight = "CyberDreamMagenta" } } }
      vim.api.nvim_set_hl(0, "NoicePopupNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = "#00ffff", bg = "none" })
    end,
  },

  -- 3. 顶部标签栏（Tab/Buffer 管理）
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
        indicator = { style = "icon", icon = "󰅒" },
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
      },
      highlights = {
        fill = { bg = "none" },
        background = { fg = "#eeeeee", bg = "none" },
        buffer_selected = { fg = "#00ff00", bg = "none", bold = true },
        tab_selected = { fg = "#ff00ff", bg = "none", bold = true },
        separator = { fg = "#00ffff", bg = "none" },
        separator_selected = { fg = "#00ffff", bg = "none", bold = true },
        indicator_selected = { fg = "#00ff00", bg = "none" },
      },
    },
  },

  -- 4. 底部状态栏（Lualine）
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      }
      opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
        lualine_x = { "fileformat", "encoding" },
        lualine_y = { "progress" },
        lualine_z = { "filesize", "location" },
      })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "LualineNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "LualineInsert", { fg = "#00ff00", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "LualineVisual", { fg = "#ff00ff", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "LualineCommand", { fg = "#00ffff", bg = "none", bold = true })
    end,
  },

  -- 5. 窗口顶部浮动文件名（多窗口区分）
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
          winhighlight = { Normal = "InclineNormal", CursorLine = "InclineCursorLine" },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold", fg = "#00ffff" },
            " ",
            guibg = "none",
          }
          return buffer
        end,
      })
      vim.api.nvim_set_hl(0, "InclineNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "InclineCursorLine", { bg = "none" })
    end,
  },

  -- 6. 高性能模糊搜索（FZF-Lua）
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy", -- 关键：确保插件完整加载
    dependencies = {
      "romgrk/fzy-lua-native", -- 关键：fzf-lua 必需依赖，缺失会导致功能不全
    },
    config = function()
      local preview_cmd_chafa = { "chafa", "{file}" }
      local image_extensions = {}
      for _, ext in ipairs({ "jpg", "svg", "png", "ico" }) do
        image_extensions[ext] = preview_cmd_chafa
      end
      require("fzf-lua").setup({
        previewers = {
          builtin = {
            extensions = image_extensions,
            winopts = { bg = "none", border = "rounded" },
          },
        },
        winopts = {
          bg = "none",
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          hl = { border = "CyberDreamCyan" },
        },
      })
    end,
  },

  -- 7. 一站式 UI 增强（核心：启动界面 Dashboard）
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- 文件树默认关闭：这里必须写在 init（启动早期、早于 UIEnter）。
    -- 若写在 config/autocmds.lua（VeryLazy 才加载），UIEnter 已经过去，autocmd 永不触发。
    init = function()
      local function launched_with_directory()
        -- 以目录参数启动（nvim somedir/）时保留文件树，其他入口默认关闭
        for _, arg in ipairs(vim.fn.argv()) do
          if vim.fn.isdirectory(arg) == 1 then
            return true
          end
        end
        return false
      end
      local function close_explorer()
        local ok = pcall(function()
          local pickers = Snacks.picker.get({ source = "explorer" })
          for _, p in ipairs(pickers or {}) do
            if p.list and p.list.win and vim.api.nvim_win_is_valid(p.list.win.win) then
              p.list.win:hide()
            end
          end
        end)
        return ok
      end
      vim.api.nvim_create_autocmd("UIEnter", {
        group = vim.api.nvim_create_augroup("user_close_explorer_on_start", { clear = true }),
        callback = function()
          if launched_with_directory() then
            return
          end -- 打开文件夹：保留文件树
          -- 多次重试，覆盖延迟弹出的侧栏（会话恢复等入口）
          vim.defer_fn(close_explorer, 150)
          vim.defer_fn(close_explorer, 600)
          vim.defer_fn(close_explorer, 1500)
        end,
      })
    end,
    keys = {
      {
        "-",
        function()
          local explorer = Snacks.picker.get({ source = "explorer" })[1]
          if explorer and explorer.list and explorer.list.win and vim.api.nvim_win_is_valid(explorer.list.win.win) then
            if vim.api.nvim_get_current_win() == explorer.list.win.win then
              -- 当前焦点在文件树 → 跳回上一个编辑器窗口
              vim.cmd("wincmd p")
            else
              -- 当前在编辑器 → 定位当前文件到树并聚焦树
              Snacks.explorer.reveal()
              explorer.list.win:focus()
            end
          else
            -- 树没打开：打开侧边资源管理器，并定位当前文件
            Snacks.explorer.reveal()
          end
        end,
        desc = "Explorer: 定位当前文件 / 在树和编辑器之间切换",
      },
      {
        "<leader>n",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
      },
    },
    ---@type snacks.Config
    opts = {
      image = { enabled = true, format = "png", kitty = { upload = true } },
      words = { enabled = true },
      statuscolumn = {
        enabled = true,
        folds = { open = true, git_hl = true },
      },
      indent = { enabled = true },
      dashboard = {
        enabled = true, -- ✅ 必须显式开启
        -- 启动界面整体样式（透明+霓虹边框）
        window = {
          border = "rounded",
          winhighlight = "Normal:SnacksDashboard,FloatBorder:CyberDreamMagenta",
        },

        sections = {
          -- 1. banner（BASEACH + CyberDream 信息框，动态日期）
          --    align="left"：与下面的菜单、加载统计同列左对齐（newnvim 的效果）
          {
            section = "terminal",
            align = "left",
            cmd = [[
              echo '  ██████╗ █████╗ ███████╗███████╗ █████╗  ██████╗██╗  ██╗';
              echo '  ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝██║  ██║';
              echo '  ██████╔╝███████║███████╗█████╗  ███████║██║     ███████║';
              echo '  ██╔══██╗██╔══██║╚════██║██╔══╝  ██╔══██║██║     ██╔══██║';
              echo '  ██████╔╝██║  ██║███████╗███████╗██║  ██║╚██████╗██║  ██║';
              echo '  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝';
              printf '  ┌─────────────────────────────────────────────────────┐\n';
              printf '  │           👾 CyberDream Neovim 👾                   │\n';
              printf '  │         %-44s│\n' "$(date '+%Y-%m-%d %H:%M')";
              printf '  └─────────────────────────────────────────────────────┘';
              # 保持 shell 不退出：nvim terminal 在进程退出后会打印 [Process exited 0]
              while :; do sleep 3600; done
            ]],
            height = 10,
            padding = 1,
          },
          -- 2. 菜单（不传自定义 keys：渲染 LazyVim 默认菜单，
          --    即截图里 Find File/Projects/Config/Restore Session 那套）
          { section = "keys", gap = 1, padding = 1, align = "left" },
          -- 3. 加载统计（"Neovim loaded X plugins in Y ms"）
          --    ⚠️ 不用内置 { section = "startup" }：它写死 align="center"
          --    （dashboard.lua:1098），会破坏同列对齐。这里用函数区块自渲染并左对齐。
          {
            function()
              local stats = require("lazy.stats").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return {
                align = "left",
                text = {
                  { "⚡ Neovim loaded ", hl = "footer" },
                  { stats.loaded .. "/" .. stats.count, hl = "special" },
                  { " plugins in ", hl = "footer" },
                  { ms .. "ms", hl = "special" },
                },
              }
            end,
          },
        },
      },
      -- 文件树 (替代 NERDTree)——必须是 opts 顶层键（此前误嵌在 dashboard 下，
      -- 导致 replace_netrw=false 未生效、打开目录时文件树自动弹出）
      explorer = {
        enabled = true,
        -- true = 用 snacks explorer 接管 netrw：打开文件夹（目录）时显示文件树
        -- （snacks 默认值，与 ~/.config/newnvim 的行为一致；打开单个文件不会弹树）
        replace_netrw = true,
        layout = {
          cycle = true,
          preset = "sidebar",
          position = "left",
          width = 30,
          min_width = 30,
        },
        filters = {
          dotfiles = false,
          gitignore = false,
        },
        -- 【文件树内部快捷键】
        keymaps = {
          ["<CR>"] = "preview", -- 回车只预览，不跳转
          ["l"] = "open", -- 按 l 才是真正打开
          ["h"] = "close_node",
          -- 注意：这里不定义 "-"，让全局映射来统一处理
          -- 按 h 折叠目录/返回上级

          -- 禁用所有默认会关闭文件树的快捷键，彻底锁死侧边栏
          ["q"] = false,
          ["<esc>"] = false,
          -- 覆盖 explorer 内部原生的 "-"（原本是返回上级目录）
          ["-"] = function()
            local explorer = Snacks.picker.get({ source = "explorer" })[1]
            if
              explorer
              and explorer.list
              and explorer.list.win
              and vim.api.nvim_win_is_valid(explorer.list.win.win)
            then
              vim.cmd("wincmd p")
            end
          end,
        },
      },
      picker = {
        previewers = {
          diff = { builtin = false, cmd = "delta" },
          git = { builtin = false },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      -- 启动界面透明 + 霓虹色高亮
      vim.api.nvim_set_hl(0, "SnacksDashboard", { bg = "none" })
      vim.api.nvim_set_hl(0, "SnacksDashboardBorder", { fg = "#ff00ff", bg = "none" })
      -- 自定义 CyberDream 高亮组
      vim.api.nvim_set_hl(0, "CyberDreamGreen", { fg = "#00ff00", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamMagenta", { fg = "#ff00ff", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamYellow", { fg = "#ffff00", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamCyan", { fg = "#00ffff", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamRed", { fg = "#ff0000", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamBlue", { fg = "#0000ff", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamOrange", { fg = "#ffa500", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "CyberDreamViolet", { fg = "#8a2be2", bg = "none", bold = true })
    end,
  },

  -- 8. 彩虹括号（Tree-sitter 驱动）
  {
    "hiphish/rainbow-delimiters.nvim",
    submodules = false,
    opts = {
      strategy = { [""] = "rainbow-delimiters.strategy.global", vim = "rainbow-delimiters.strategy.local" },
      query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
      priority = { [""] = 110, lua = 210 },
      highlight = {
        "CyberDreamRed",
        "CyberDreamYellow",
        "CyberDreamBlue",
        "CyberDreamOrange",
        "CyberDreamGreen",
        "CyberDreamViolet",
        "CyberDreamCyan",
      },
    },
    main = "rainbow-delimiters.setup",
  },
}
