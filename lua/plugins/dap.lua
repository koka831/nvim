return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust")({
            args = { "--no-capture" },
          }),
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "docker",
                "compose",
                "exec",
                "-e",
                "RAILS_ENV=test",
                "api",
                "bundle",
                "exec",
                "rspec",
              })
            end,

            transform_spec_path = function(path)
              local prefix = require("neotest-rspec").root(path)
              return string.sub(path, string.len(prefix) + 2, -1)
            end,

            results_path = "tmp/rspec.output",
          }),
        },
        quickfix = {
          enabled = true,
          open = true,
        },
      })
    end,
  },
  "rouge8/neotest-rust",
  "olimorris/neotest-rspec",
  "mfussenegger/nvim-dap",
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
  },
}
