return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
    end,
  },
  "nvim-telescope/telescope-ui-select.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
