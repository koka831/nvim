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
    ft = "rust",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
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
  {
    "tpope/vim-rails",
    ft = "ruby",
    config = function()
      vim.cmd([[
      let g:rails_projections = {
      \     'app/controllers/*_controller.rb': {
      \         'alternate': [
      \             'spec/requests/{}_spec.rb',
      \             'spec/requests/{}_controller_spec.rb',
      \             'spec/controllers/{}_spec.rb'
      \         ]
      \     },
      \     'spec/requests/*_spec.rb': {
      \         'alternate': [
      \             'app/controllers/{}_controller.rb',
      \             'app/controllers/{}.rb'
      \         ]
      \     }
      \ }
      ]])
    end,
  },
}
