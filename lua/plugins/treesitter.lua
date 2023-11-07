return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        ignore_install = { "dart" },
        highlight = {
          enable = true,
          disable = { "yaml", "jack", "dart" },
          additional_vim_regex_highlighting = { "yaml", "jack", "haskell", "dart" },
        },
        indent = { enable = true },
        -- windwp/nvim-ts-autotag
        autotag = { enable = true },
        -- JoosepAlviste/nvim-ts-context-commentstring
        context_commentstring = { enable = true },
        -- nvim-treesitter-textobjects
        textobjects = {
          select = { enable = true },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "InsertEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
    dependencies = "tpope/vim-commentary",
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
}
