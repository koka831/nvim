return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = { "yaml", "jack" },
          additional_vim_regex_highlighting = { "yaml", "jack", "haskell" },
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
