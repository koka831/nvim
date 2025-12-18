local black = "#3c3836"
local red = "#f55e5e"
local yellow = "#f5a95e"
local green = "#a8a85f"
local blue = "#82a884"

---custom components for lualine. show if VENV is active
-- @return string
local function lualine_venv_component()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
  if venv ~= nil then
    return " venv"
  else
    return ""
  end
end

return {
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_palette = "original"
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          names = false,
          mode = "virtualtext",
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    tag = "nerd-v2-compat",
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = {
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeToggle",
      "NvimTreeFocus",
    },
    config = function()
      require("nvim-tree").setup({
        diagnostics = {
          enable = true,
        },
        filters = {
          custom = {
            "node_modules",
            ".cache",
          },
        },
        git = {
          ignore = false,
        },
        -- note: move file: `x` to cut and `p` to paste
        on_attach = function(bufnr)
          require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "<C-e>", "", { buffer = bufnr })
          vim.keymap.del("n", "<C-e>", { buffer = bufnr })
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local custom_theme = require("lualine.themes.gruvbox")
      custom_theme.command.a.bg = green
      custom_theme.insert.a.bg = blue
      custom_theme.visual.a.bg = yellow

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = "",
          section_separators = "",
          disabled_filetypes = { "NvimTree" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              lualine_venv_component,
              color = { fg = "#FFD43B" },
            },
          },
          lualine_c = {
            {
              "diff",
              diff_color = {
                added = "Aqua",
                modified = "Green",
                removed = "Red",
              },
            },
            {
              "filename",
              path = 1,
            },
          },
          lualine_x = { "filetype" },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              diagnostics_color = {
                error = "Red",
                warn = "Yellow",
                info = "Aqua",
                hint = "Green",
              },
            },
          },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "akinsho/nvim-bufferline.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "none",
          separator_style = { "", "" },
          indicator = {
            icon = "",
          },
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, _, _)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
        },
        highlights = {
          buffer_selected = {
            bg = black,
          },
          error_diagnostic = {
            fg = red,
          },
          error_selected = {
            bg = black,
            fg = red,
          },
          error_diagnostic_selected = {
            bg = black,
            fg = red,
          },
          warning_diagnostic = {
            fg = yellow,
          },
          warning_selected = {
            bg = black,
            fg = yellow,
          },
          warning_diagnostic_selected = {
            bg = black,
            fg = yellow,
          },
          hint_diagnostic = {
            fg = blue,
          },
          hint_selected = {
            bg = black,
            fg = blue,
          },
          hint_diagnostic_selected = {
            bg = black,
            fg = blue,
          },
          info_diagnostic = {
            fg = blue,
          },
          info_selected = {
            bg = black,
          },
          info_diagnostic_selected = {
            bg = black,
            fg = blue,
          },
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
          done = "",
        },
      })
    end,
  },
  {
    "segeljakt/vim-silicon",
    config = function()
      vim.cmd([[
      let g:silicon = {
        \   'theme':        'gruvbox-dark',
        \   'background':   '#32302f',
        \   'line-number':  v:true,
        \   'round-corner': v:true,
        \   'output': '~/documents/screenshots/{time:%Y-%m-%d_%H-%M-%S}.png'
        \ }
      ]])
    end,
  },
}
