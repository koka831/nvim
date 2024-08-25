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
          additional_vim_regex_highlighting = { "jack", "haskell", "dart" },
        },
        indent = { enable = true },
        -- windwp/nvim-ts-autotag
        autotag = { enable = true },
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
    config = function()
      require("ts_context_commentstring").setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
}
