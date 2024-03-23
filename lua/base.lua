-- @see https://github.com/nvim-tree/nvim-tree.lua#setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#getting-started
vim.g.skip_ts_context_commentstring_module = true

vim.cmd([[
set termguicolors
set backspace=2
set clipboard+=unnamedplus
set cursorline
set cursorlineopt=number
set expandtab
set ignorecase
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
set noswapfile
set nobackup
set nowritebackup
set number
set shiftwidth=4
set splitbelow
set splitright
set updatetime=300
set tabstop=4
" unfold on open
set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set inccommand=split
set pumblend=10
set winblend=10
set signcolumn=yes
]])
