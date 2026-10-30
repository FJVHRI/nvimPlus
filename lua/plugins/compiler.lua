--~/.config/nvim/lua/plugins/compiler.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- ===== 原生浮动终端（保持打开）=====
      local function float_term_keep(cmd, is_input)
        -- 1. 当前窗口句柄
        local cur_win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_create_buf(false, true)

        -- 2. 基准尺寸（输入阶段尺寸）
        local fixed_width = math.min(80, vim.o.columns - 4)
        local fixed_height = math.min(20, vim.o.lines - 4)
        -- 3. 两档尺寸
        local width, height
        if is_input then
          -- 输入阶段 → 基准尺寸
          width = fixed_width
          height = fixed_height
        else
          -- 输出阶段 → 动态尺寸（统计行数 + 最长行）(不会小于基准）
          local tmp =
            vim.fn.system(cmd .. " | wc -l && " .. cmd .. " | awk '{max=max<length?length:max} END {print max+2}'")
          local lines = tonumber(vim.fn.split(tmp, "\n")[1]) or 1
          local max_width = tonumber(vim.fn.split(tmp, "\n")[2]) or 80

          --  自适应尺寸(不小于基准尺寸)
          width = math.max(fixed_width, math.min(max_width, vim.o.columns - 4))
          height = math.max(fixed_height, math.min(lines + 2, vim.o.lines - 4))
        end
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2,
          style = "minimal",
          border = "rounded",
        })
        -- 清屏 + 运行（不自动关）
        vim.fn.termopen(string.format('printf "\\033[2J\\033[H"; %s', cmd), {
          on_exit = function() end,
        })
        vim.cmd("startinsert")
        -- 手动退出
        vim.api.nvim_buf_set_keymap(buf, "t", "q", "<Cmd>close<CR>", { nowait = true })
        vim.api.nvim_create_autocmd("WinClosed", {
          buffer = buf,
          once = true,
          callback = function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
            vim.api.nvim_set_current_win(cur_win)
          end,
        })
      end

      -- 命令生成器（保持你原来逻辑）
      local function build_cmd()
        local ft = vim.bo.filetype
        local file = vim.fn.expand("%:t")
        local base = vim.fn.expand("%:t:r")
        local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

        if ft == "c" then
          if text:match("#include.*<gtk/gtk%.h>") then
            return string.format("gcc %s -o %s $(pkg-config --cflags --libs gtk4) && ./%s", file, base, base)
          elseif text:match("#include.*<opencv2/") then
            return string.format("gcc %s -o %s $(pkg-config --cflags --libs opencv4) && ./%s", file, base, base)
          elseif text:match("#include.*<GLFW/glfw%.h>") then
            return string.format("gcc %s -o %s -lGL -lGLU -lglfw && ./%s", file, base, base)
          else
            return string.format("gcc %s -o %s && ./%s", file, base, base)
          end
        elseif ft == "cpp" then
          if text:match("#include.*<GLFW/glfw%.h>") then
            return string.format("g++ %s -o %s -lGL -lGLU -lglfw && ./%s", file, base, base)
          elseif text:match("#include.*<opencv2/") then
            return string.format("g++ %s -o %s $(pkg-config --cflags --libs opencv4) && ./%s", file, base, base)
          else
            return string.format("g++ %s -o %s && ./%s", file, base, base)
          end
        elseif ft == "rust" then
          return string.format("rustc %s -o %s && ./%s", file, base, base)
        elseif ft == "python" then
          return string.format("python3 %s", file)
        elseif ft == "java" then
          return string.format("cd %s && javac %s && java %s", vim.fn.expand("%:h"), file, base)
        elseif ft == "r" then
          return string.format("Rscript %s", file)
        elseif ft == "cuda" then
          return string.format("nvcc %s -o %s && ./%s", file, base, base)
        elseif ft == "html" then
          vim.cmd("silent write")
          local base = vim.fn.expand("%:t")
          local dir = vim.fn.expand("%:p:h")
          local url = "http://localhost:3000/" .. base

          -- 1. 启动 browser-sync（如果未运行）
          local bs_running = vim.fn.system("pgrep -f 'browser-sync start' 2>/dev/null"):gsub("%s+", "") ~= ""
          if not bs_running then
            vim.fn.jobstart(
              string.format("browser-sync start --server '%s' --files '*.html' --port 3000 --no-open", dir),
              {
                detach = true,
              }
            )
            vim.wait(1000)
            vim.notify("Server 启动: " .. url, vim.log.levels.INFO)
          end

          -- 2. 关键改进：检查是否有浏览器连接到 3000 端口
          -- 如果有 ESTABLISHED 连接，说明页面仍打开；否则需要重新打开
          local has_connection = vim.fn
            .system("lsof -i :3000 2>/dev/null | grep -i chrome | grep -q ESTABLISHED && echo 'yes' || echo 'no'")
            :gsub("%s+", "") == "yes"

          -- 3. 如果没有连接（页面被关闭），重新打开
          if not has_connection then
            local chrome_cmd = nil
            for _, cmd in ipairs({ "google-chrome", "google-chrome-stable", "chromium", "chromium-browser" }) do
              if vim.fn.executable(cmd) == 1 then
                chrome_cmd = cmd
                break
              end
            end

            if chrome_cmd then
              -- 使用 --app 模式创建应用窗口（更像 IDE 内置浏览器）
              vim.fn.jobstart(string.format("%s --app='%s' --new-window >/dev/null 2>&1 &", chrome_cmd, url))
              vim.notify("浏览器已打开", vim.log.levels.INFO)
            else
              vim.fn.jobstart(string.format("xdg-open '%s' &", url))
            end
          else
            -- 连接存在，browser-sync 会自动刷新页面
            vim.notify("文件已保存，自动刷新...", vim.log.levels.INFO)
          end

          return nil
        elseif ft == "javascript" then
          return string.format("node %s", file)
        elseif ft == "typescript" then
          return string.format(
            "if [ -x ./node_modules/.bin/ts-node ]; then ./node_modules/.bin/ts-node %s; elif command -v ts-node >/dev/null 2>&1; then ts-node %s; else echo '请先安装 ts-node: npm i -g ts-node 或本地 npm i ts-node'; fi",
            file,
            file
          )
        elseif ft == "go" then
          -- 直接 go run，无需手动编译可执行文件
          return string.format("go run %s", file)
        --------------------------------------------------
        else
          return nil
        end
      end

      -- 统一 <F5>
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "rust", "python", "java", "html", "r", "cuda", "javascript", "typescript", "go" },
        callback = function()
          vim.keymap.set("n", "<F5>", function()
            local cmd = build_cmd()
            if cmd then
              vim.cmd("write")
              float_term_keep(cmd)
            end
          end, { buffer = 0, desc = "Compile & Run (float term)" })
        end,
      })
    end,
  },
}
