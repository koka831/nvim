return {
  -- textobj
  {
    "kylechui/nvim-surround",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  -- lua
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  -- comment
  "tpope/vim-commentary",
}
