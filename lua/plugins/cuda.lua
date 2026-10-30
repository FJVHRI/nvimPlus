return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 关掉 clangd 对 cuda 的劫持
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" }, -- 去掉 "cuda"
        },
        -- 启用 CUDA 官方 LSP（基于 LLVM 但头文件与 nvcc 兼容）
        cuda = {
          cmd = { "cuda-language-server" },
          filetypes = { "cuda" },
          root_dir = require("lspconfig.util").root_pattern(".git", "Makefile", "CMakeLists.txt"),
        },
      },
    },
  },
}
