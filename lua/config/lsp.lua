-- config/lsp.lua
-- Neovim 0.12 原生 LSP 配置

-- ⚡ 启动优化：不要在这里 require("blink.cmp")！
--    实测它会连带把 luasnip + 全部 VSCode 片段（friendly-snippets）在启动时同步加载，
--    仅这一项就吃掉 176ms（占启动总耗时 260ms 的 68%）。
--    这里改成内联一份与 blink.cmp.get_lsp_capabilities() 完全等价的静态表
--    （抄自 blink.cmp/lua/blink/cmp/sources/lib/init.lua:301），
--    并在 blink 真正加载（首次进入插入模式）后再把真实值合并回同一张表，
--    保证后续启动的 client 拿到与原先完全一致的能力，功能零损失。
local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = false,
        documentationFormat = { "markdown", "plaintext" },
        deprecatedSupport = true,
        preselectSupport = false,
        tagSupport = { valueSet = { 1 } },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
        },
        insertTextModeSupport = { valueSet = { 1 } },
        labelDetailsSupport = true,
      },
      completionList = {
        itemDefaults = {
          "commitCharacters",
          "editRange",
          "insertTextFormat",
          "insertTextMode",
          "data",
        },
      },
      contextSupport = true,
      insertTextMode = 1,
    },
  },
})

-- blink 加载后就地合并它的真实 capabilities（同一张表引用，之后启动的 client 直接受益）
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(ev)
    if ev.data ~= "blink.cmp" then
      return
    end
    local ok, blink = pcall(require, "blink.cmp")
    if not ok then
      return
    end
    local ok2, real = pcall(blink.get_lsp_capabilities)
    if ok2 and type(real) == "table" then
      for k, v in pairs(vim.tbl_deep_extend("force", capabilities, real)) do
        capabilities[k] = v
      end
    end
  end,
})

-- 统一 on_attach 逻辑
local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gr", vim.lsp.buf.references, "Goto References")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

  -- 如果使用原生 0.12 inlay hints，可以在这里启用
  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end
end

-- C/C++/CUDA (clangd)
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  filetypes = { "c", "cpp", "cuda", "objc", "objcpp" },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Python (pyright)
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- TypeScript/JavaScript (ts_ls)
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- HTML (修正命令名)
vim.lsp.config("html", {
  cmd = { "vscode-html-language-server", "--stdio" }, -- 或 "html-languageserver"
  filetypes = { "html" },
  root_markers = { ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- CSS/SCSS/Less (修正命令名)
vim.lsp.config("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" }, -- 或 "css-languageserver"
  filetypes = { "css", "scss", "less" },
  root_markers = { ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Emmet
vim.lsp.config("emmet_language_server", {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  root_markers = { ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Go
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
      },
    },
  },
})

-- Java
vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  filetypes = { "java" },
  root_markers = { ".git", "pom.xml", "build.gradle", ".gradle" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- 启用所有 LSP
vim.lsp.enable({
  "clangd",
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "emmet_language_server",
  "gopls",
  "rust_analyzer",
  "jdtls",
})
