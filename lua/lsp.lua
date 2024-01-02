--- Keybinds for LSP are also configured in `keymap.lua`.
local c = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities(c)
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers({
  function(ls)
    lspconfig[ls].setup({ capabilities = capabilities })
  end,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = { enable = false },
    },
  },
})

lspconfig.hls.setup({
  capabilities = capabilities,
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      cabalFormattingProvider = "cabalfmt",
    },
  },
})

---@param workspace string path
---@return string
local function python_path(workspace)
  local path = require("lspconfig/util").path
  if vim.fn.glob(path.join(workspace, "poetry.lock")) ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return path.join(venv, "bin", "python")
  end

  return vim.fn.trim(vim.fn.system("command -v python"))
end

lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      venvPath = ".",
      analysis = { extraPaths = "." },
    },
  },
  on_init = function(client)
    client.config.settings.python.pythonPath = python_path(client.config.root_dir)
  end,
})

require("rust-tools").setup({
  tools = {
    inlay_hints = {
      auto = true,
      parameter_hints_prefix = " ",
      other_hints_prefix = "-> ",
    },
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(
        "/usr/bin/codelldb",
        "/lib/codelldb/adapter/libcodelldb.so"
      ),
    },
    hover_actions = {
      -- remove borders
      border = {
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
      },
    },
  },
  server = {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--all", "--", "-W", "clippy::all" },
        },
        inlayHints = { locationLinks = false },
        rustc = {
          source = "discover",
        },
      },
    },
  },
})

require("flutter-tools").setup({
  fvm = true,
})

local ls = require("null-ls")
local builtins = ls.builtins

local function has_eslintrc(util)
  return util.root_has_file({ "eslint.config.js", ".eslintrc.js" })
end

ls.setup({
  capabilities = capabilities,
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    -- Shell
    builtins.diagnostics.shellcheck,
    builtins.code_actions.shellcheck,
    -- Lua
    builtins.formatting.stylua,
    builtins.diagnostics.luacheck.with({ extra_args = { "--globals", "vim" } }),
    -- C++
    builtins.formatting.clang_format,
    -- ECMAScript
    builtins.formatting.eslint.with({ condition = has_eslintrc }),
    builtins.diagnostics.eslint.with({ condition = has_eslintrc }),
    builtins.code_actions.eslint.with({ condition = has_eslintrc }),

    builtins.formatting.prettier,
    -- GHA
    builtins.diagnostics.actionlint,
    -- Python
    builtins.formatting.ruff,
    builtins.diagnostics.ruff,
  },
})

-- Disable highlight by LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DisableLspHighlight", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- Highlight variables under the cursor
-- TODO: Check if the current LSP supports document highlighting
-- ref: `client.supports_method('textDocument/documentHighlight')`
--
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--   group = vim.api.nvim_create_augroup('HighlightLspCursorVariable', {}),
--   callback = vim.lsp.buf.document_highlight
-- })
-- vim.api.nvim_create_autocmd('CursorMoved', {
--   group = vim.api.nvim_create_augroup('ClearHighlightLspCursorVariable', {}),
--   callback = vim.lsp.buf.clear_references
-- })
