--- Keybinds for LSP are also configured in `keymap.lua`.
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({})

local c = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities(c)
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        checkThirdParty = "Disable",
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")

lspconfig.gopls.setup({
  capabilities = capabilities,
})

lspconfig.nil_ls.setup({
  capabilities = capabilities,
})

lspconfig.ruby_lsp.setup({
  capabilities = capabilities,
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop", "standard" },
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

-- require `npm install -g @tailwindcss/language-server`
require("lspconfig").tailwindcss.setup({
  capabilities = capabilities,
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

---detect which package manager is used in the current JS/TS project
---@return string package_manager one of "pnpm", "yarn" "npm"
local function node_package_manager()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
    return "yarn"
  else
    return "npm"
  end
end

vim.lsp.config("biome", {
  cmd = { node_package_manager(), "biome", "lsp-proxy" },
})
vim.lsp.enable("biome")

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

lspconfig.ruff.setup({
  capabilities = capabilities,
  on_init = function(client)
    client.config.settings.python.pythonPath = python_path(client.config.root_dir)
  end,
})

lspconfig.terraformls.setup({})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
  settings = {
    ["rust-analyzer"] = {
      check = {
        extraArgs = { "--target-dir", "target/ra" },
        -- command = "clippy",
        -- TODO: enable --target-dir
        -- extraArgs = { "--all", "--", "-W", "clippy::all", "--target-dir", "target/ra" },
      },
      inlayHints = {
        renderColons = true,
        -- expressionAdjustmentHints = { enable = true },
        closingBraceHints = { enable = false },
        parameterHints = { enable = false },
        typeHints = {
          enable = false,
          -- hideNamedConstructor = true,
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
    builtins.formatting.prettierd,
    -- Lua
    builtins.formatting.stylua,
    builtins.diagnostics.selene,
    -- C++
    builtins.formatting.clang_format,
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
