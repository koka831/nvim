local keymap = vim.keymap.set
local telescope = require("telescope.builtin")

keymap("i", "<C-h>", "<Left>")
keymap("i", "<C-j>", "<Down>")
keymap("i", "<C-k>", "<Up>")
keymap("i", "<C-l>", "<Right>")

keymap("n", "<C-p>", ":bp<cr>")
keymap("n", "<C-n>", require("nvim-tree.api").tree.toggle)

-- telescope
keymap("n", "<leader>ff", telescope.find_files)
keymap("n", "<leader>fh", telescope.oldfiles)
keymap("n", "<leader>fb", telescope.buffers)
keymap("n", "<leader>lr", telescope.registers)
keymap("n", "<leader>ls", telescope.lsp_document_symbols)
keymap("n", "<leader>fg", require("telescope").extensions.live_grep_args.live_grep_args)
-- telescope.git
keymap("n", "<leader>gb", telescope.git_branches)
keymap("n", "<leader>gc", telescope.git_commits)

-- error/warning
keymap("n", "gn", vim.diagnostic.setqflist)
keymap("n", "g[", vim.diagnostic.goto_prev)
keymap("n", "g]", vim.diagnostic.goto_next)

-- DAP
local dap = require("dap")
keymap("n", "dt", dap.toggle_breakpoint)
keymap("n", "dc", dap.continue)

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "gk", vim.lsp.buf.hover, opts)
    keymap("n", "gr", telescope.lsp_references, opts)
    keymap({ "n", "v" }, "<leader>a", require("actions-preview").code_actions, opts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>fm", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
