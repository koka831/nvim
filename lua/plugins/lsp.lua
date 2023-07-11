-- config in lua/lsp.lua
return {
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = "nvim-telescope/telescope.nvim",
  },
}
