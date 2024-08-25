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

lspconfig.gopls.setup({
  capabilities = capabilities,
})

lspconfig.nil_ls.setup({
  capabilities = capabilities,
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

lspconfig.ruff_lsp.setup({
  capabilities = capabilities,
  on_init = function(client)
    client.config.settings.python.pythonPath = python_path(client.config.root_dir)
  end,
})

lspconfig.terraformls.setup({})

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
  lsp = {
    capabilities = capabilities,
    settings = {
      lineLength = 120,
    },
  },
})

local ls = require("null-ls")
local builtins = ls.builtins

ls.setup({
  capabilities = capabilities,
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    -- Shell
    require("none-ls-shellcheck.diagnostics"),
    require("none-ls-shellcheck.code_actions"),
    -- Lua
    builtins.formatting.stylua,
    builtins.diagnostics.selene,
    -- C++
    builtins.formatting.clang_format,
    -- ECMAScript
    require("none-ls.formatting.eslint"),
    require("none-ls.diagnostics.eslint"),
    require("none-ls.code_actions.eslint"),

    builtins.formatting.prettier,
    -- GHA
    builtins.diagnostics.actionlint,
    -- Terraform
    builtins.formatting.terraform_fmt,
    builtins.diagnostics.terraform_validate,
    builtins.diagnostics.trivy,
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

-- Enable inlay hint in normal mode
-- vim.api.nvim_create_autocmd({ "LspAttach", "InsertEnter", "InsertLeave" }, {
--   group = vim.api.nvim_create_augroup("ToggleInlayHint", {}),
--   callback = function(ev)
--     local mode = ev.event ~= "InsertEnter"
--     vim.lsp.inlay_hint.enable(mode, { bufnr = ev.buf })
--   end,
-- })

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
