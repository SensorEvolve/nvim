-- Contains configurations for formatters (conform)
-- Linters are handled by LazyVim's default nvim-lint integration

return {
  -- Configure formatter (conform.nvim)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- Trigger format on save
    cmd = { "ConformInfo" },
    opts = {
      -- Define formatters for each filetype
      formatters_by_ft = {
        ["lua"] = { "stylua" },
        ["rust"] = { "rustfmt" },
        ["toml"] = { "taplo" },
        ["python"] = { "isort", "black" },
        ["typescript"] = { "prettier" },
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["svelte"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["go"] = { "goimports", "gofmt" },
        ["typst"] = { "typstfmt" }, -- Ensure typstfmt installed via Mason
      },
      -- Configure formatter arguments
      formatters = {
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        rustfmt = { prepend_args = { "--edition=2021" } },
        prettier = { prepend_args = { "--print-width", "100", "--tab-width", "2" } },
        black = { prepend_args = { "--line-length", "88" } },
        isort = {},
        goimports = { prepend_args = { "-local", "your_go_module_prefix" } }, -- Replace if needed
        gofmt = {},
        typstfmt = {},
      },
      -- Configuration for format-on-save behavior can be set here
      -- instead of autocmds.lua if preferred.
      -- format_on_save = {
      --   timeout_ms = 1000,
      --   lsp_fallback = true, -- Try LSP formatting if conform fails
      -- },
    },
  },

  -- ** null-ls.nvim section removed ** --
}
