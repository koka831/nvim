local function format_filename(_, path)
  local fname = vim.fs.basename(path)
  local directory = vim.fs.dirname(path)

  if directory == "." then
    return fname
  end

  return string.format("%s\t\t%s", fname, directory)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      vim.fn.matchadd("TelescopeDirectory", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeDirectory", { link = "Comment" })
    end)
  end,
})

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.0",
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
          path_display = format_filename,
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
