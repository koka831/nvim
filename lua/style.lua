vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserColorConfig", {}),
  -- stylua: ignore start
  callback = function()
    if vim.g.colors_name == "gruvbox-material" then
      vim.cmd([[
      highlight! Red    guifg=#f55e5e
      highlight! Yellow guifg=#f5a95e
      highlight! Aqua   guifg=#a8a85f
      highlight! Green  guifg=#82a884
      highlight! Gray   guifg=#473c29
      highlight! Normal guibg=#282828

      highlight! BgRed      guifg=#282828 guibg=#f55e5e gui=bold
      highlight! BgYellow   guifg=#282828 guibg=#f5a95e gui=bold
      highlight! BgAqua     guifg=#282828 guibg=#a8a85f gui=bold
      highlight! BgGreen    guifg=#282828 guibg=#82a884 gui=bold
      highlight! BgGray     guifg=#ebdbb2 guibg=#473c29 gui=bold
      ]])
    end

    vim.cmd([[
    " Use `highlight` to override config partially,
    " since `nvim_set_hl` in Lua completely replaces its original definition
    highlight! link RedBold Red
    highlight! link RedItalic Red
    highlight! link YellowBold Yellow
    highlight! link YellowItalic Yellow
    highlight! link AquaBold Aqua
    highlight! link AquaItalic Aqua
    highlight! link GreenBold Green
    highlight! link GreenItalic Green

    highlight! LineNr guibg=none
    highlight! clear CursorLine
    highlight! link CursorLineNr Yellow
    highlight! link SignColumn Normal

    highlight! link Substitute  BgYellow
    highlight! link Search      BgYellow
    highlight! link IncSearch   BgYellow
    highlight! link CurSearch   BgRed
    highlight! link MatchParen  BgGray

    " remove undercurl from diagnostics text
    highlight! ErrorText      gui=none
    highlight! WarningText    gui=none
    highlight! InfoText       gui=none
    highlight! HintText       gui=none

    " code highlight in previewer
    highlight! link Type                Yellow
    highlight! link Special             Yellow
    highlight! link String              Aqua
    highlight! link Character           Aqua
    highlight! link SpecialChar         Yellow
    highlight! link Identifier          Yellow
    highlight! link Function            Green
    highlight! link Macro               Blue
    highlight! link Keyword             Red
    highlight! link Typedef             Red
    highlight! link Statement           Red
    highlight! link Conditional         Red
    highlight! link Repeat              Red
    highlight! link Error               Red
    highlight! link Exception           Red
    highlight! link Constant            Purple
    highlight! link Operator            White
    highlight! link rustLifetime        Orange

    " Tree-sitter
    highlight! link @keyword            Red
    highlight! link @symbol             Purple
    highlight! link @string             Aqua
    highlight! link @string.special     Yellow
    highlight! link @text.literal       Aqua
    highlight! link @text.reference     Blue
    highlight! link @namespace          White
    highlight! link @field              White
    highlight! link @variable           White
    highlight! link @property           White
    highlight! link @operator           White
    highlight! link @function.call      Green
    highlight! link @function.builtin   Green
    highlight! link @function.macro     Blue

    highlight! link @text.note          BgAqua
    highlight! link @text.warning       BgYellow
    highlight! link @text.danger        BgRed
    highlight! link @text.todo.comment  BgGreen
    highlight! link @text.safety        BgGray

    highlight! link @text.title.1.markdown          Red
    highlight! link @text.title.2.markdown          Yellow
    highlight! link @text.title.3.markdown          Aqua
    highlight! link @text.title.4.markdown          Green
    highlight! link @text.title.1.marker.markdown   Gray
    highlight! link @text.title.2.marker.markdown   Gray
    highlight! link @text.title.3.marker.markdown   Gray
    highlight! link @text.title.4.marker.markdown   Gray

    highlight! link @function.builtin.lua   Blue
    highlight! link @keyword.luadoc         Purple
    highlight! link @keyword.return.luadoc  Purple
    highlight! link @namespace.crate.rust   Red
    highlight! @comment.documentation       gui=bold

    " Plugin settings
    highlight! link NvimTreeWindowPicker PmenuSel

    " GitGutter
    highlight! link GitSignsAdd         Aqua
    highlight! link GitSignsChange      Yellow
    highlight! link GitSignsDelete      Red
    highlight! link GitSignsUntracked   Gray

    " Neotest
    highlight! link NeotestFailed       Red
    highlight! link NeotestPassed       Aqua
    highlight! link NeotestRunning      Yellow
    highlight! link NeotestAdapterName  Blue
    highlight! link NeotestDir          Green
    highlight! link NeotestFile         White
    highlight! link NeotestNamespace    Yellow
    ]])

    -- LSP
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "Red" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "Yellow" })
    vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "Aqua" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "Blue" })

    -- DAP
    vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "Yellow" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "•", texthl = "Green" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "•", texthl = "Gray" })
    vim.fn.sign_define("DapStopped", { text = "•", texthl = "Red" })
    vim.fn.sign_define("DapLogPoint", { text = "•", texthl = "Blue" })
  end,
  -- stylua: ignore end
})

vim.cmd([[
set background=dark
silent! colorscheme gruvbox-material
]])
