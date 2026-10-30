return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local function smart_build_run()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local text = table.concat(lines, "\n")
        local filetype = vim.bo.filetype
        local filename = vim.fn.expand("%:t")
        local basename = vim.fn.expand("%:t:r")

        if filetype == "c" then
          local cmd
          if text:match("#include.*<gtk/gtk%.h>") then
            cmd = string.format("gcc %s -o %s $(pkg-config --cflags --libs gtk4) && ./%s", filename, basename, basename)
          elseif text:match("#include.*<opencv2/") then
            cmd =
              string.format("gcc %s -o %s $(pkg-config --cflags --libs opencv4) && ./%s", filename, basename, basename)
          else
            cmd = string.format("gcc %s -o %s && ./%s", filename, basename, basename)
          end
          vim.cmd("!" .. cmd)
        elseif filetype == "cpp" then
          local cmd
          if text:match("#include.*<[GL/gl|GL/glu|GLFW|glad|gl/GL]") then
            cmd = string.format("g++ %s -o %s -lGL -lGLU -lglfw && ./%s", filename, basename, basename)
          elseif text:match("#include.*<opencv2/") then
            cmd =
              string.format("g++ %s -o %s $(pkg-config --cflags --libs opencv4) && ./%s", filename, basename, basename)
          else
            cmd = string.format("g++ %s -o %s && ./%s", filename, basename, basename)
          end
          vim.cmd("!" .. cmd)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("setlocal syntax=off")
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<F5>",
            ":w<CR>:!firefox --new-tab % &<CR>",
            { noremap = true, silent = true }
          )
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<F5>",
            ":w<CR>:!rustc % -o %:r && ./%:r<CR>",
            { noremap = true, silent = true }
          )
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<F5>", ":w<CR>:!python3 %<CR>", { noremap = true, silent = true })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<F5>", "", {
            noremap = true,
            silent = true,
            callback = function()
              vim.cmd("write")
              smart_build_run()
            end,
          })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<F5>",
            ":w<CR>:!cd %:h && javac %:t && java %:t:r<CR>", -- %:h 是目录，%:t 是文件名
            { noremap = true, silent = true }
          )
        end,
      })
    end,
  },
}
