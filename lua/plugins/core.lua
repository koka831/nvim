return {
  -- textobj
  {
    "kylechui/nvim-surround",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  -- lua
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
}
