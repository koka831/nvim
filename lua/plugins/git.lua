return {
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          delay = 3000,
        },
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
}
