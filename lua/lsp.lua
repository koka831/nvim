--- Keybinds for LSP are also configured in `keymap.lua`.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- enable autocomplete for Neovim runtime files
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")

vim.lsp.enable("gopls")

vim.lsp.config("ruby_lsp", {
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop", "standard" },
  },
})
vim.lsp.enable("ruby_lsp")

--- require `npm install -g @tailwindcss/language-server`
vim.lsp.enable("tailwindcss")

---@param workspace string path
---@return string
local function python_path(workspace)
  local path = require("lspconfig/util").path

  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  if vim.fn.glob(path.join(workspace, "uv.lock")) ~= "" then
    return vim.fn.trim(vim.fn.system("uv python find"))
  end

  return vim.fn.trim(vim.fn.system("command -v python3"))
end

vim.lsp.config("pyright", {
  cmd = { ".venv/bin/pyright-langserver", "--stdio" },
  settings = {
    python = {
      analysis = {
        pythonPath = ".venv/bin/python",
      },
    },
  },
})
vim.lsp.enable("pyright")

vim.lsp.config("ts_ls", {
  on_attach = function(client, _)
    -- disable formatting, use biome instead
    client.server_capabilities.documentFormattingProvider = false
  end,
})
vim.lsp.enable("ts_ls")

---detect which package manager is used in the current project
---@return string package_manager pnpm|yarn|npm
local function detect_node_package_manager()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
    return "yarn"
  else
    return "npm"
  end
end

vim.lsp.enable("biome")
vim.lsp.config("biome", {
  settings = {
    ["biome"] = {
      capabilities = capabilities,
      cmd = { detect_node_package_manager(), "biome", "lsp-proxy" },
    },
  },
})

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
  on_init = function(client)
    client.config.settings.interpreter = python_path(client.config.root_dir)
  end,
})
vim.lsp.enable("ruff")

vim.lsp.enable("terraformls")

vim.lsp.config("rust_analyzer", {
  on_attach = function(_client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
  check = {
    command = "clippy",
    extraArgs = { "--all", "--", "-W", "clippy::all" },
  },
  settings = {
    -- see [doc](https://rust-analyzer.github.io/book/configuration.html)
    ["rust-analyzer"] = {
      inlayHints = {
        renderColons = true,
        expressionAdjustmentHints = { enable = true },
        closingBraceHints = { enable = false },
        parameterHints = { enable = false },
        typeHints = {
          enable = false,
          -- hideNamedConstructor = true,
        },
      },
      hover = {
        show = {
          enumVariants = 10,
        },
      },
    },
  },
})
vim.lsp.enable("rust_analyzer")

require("flutter-tools").setup({
  fvm = true,
  lsp = {
    capabilities = capabilities,
    cmd = {
      "/opt/homebrew/bin/fvm",
      "dart",
      "language-server",
      "--protocol=lsp",
    },
    color = {
      enabled = true,
      virtual_text = true,
    },
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
    ---@diagnostic disable-next-line: need-check-nil
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
