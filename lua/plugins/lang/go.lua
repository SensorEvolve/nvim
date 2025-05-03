-- Contains Go language specific configurations

return {
  -- Configure Go LSP (gopls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- Example analyses (enable/disable as needed)
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true, -- Suggest using 'any' where applicable
              },
              -- Enable staticcheck analysis
              staticcheck = true,
              -- Hints configuration
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              -- Use semantic tokens for better highlighting
              semanticTokens = true,
              -- Enable experimental features if desired
              -- experimentalPostfixCompletions = true,
              -- gopls features
              usePlaceholders = true, -- Use snippets for completing functions
              completeUnimported = true, -- Auto-import completions
              -- UI enhancements
              -- codelenses = { generate = true, gc_details = true, test = true, tidy = true, upgrade_dependency = true },
              -- hoverKind = "FullDocumentation", -- Options: SingleLine, Structured, FullDocumentation
            },
          },
        },
      },
    },
  },

  -- Go plugin for enhanced development experience
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- Required dependency for UI elements
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter", -- For syntax-aware features
    },
    event = "FileType go", -- Load when a Go file is opened
    build = ':lua require("go.install").update_all_sync()', -- Installs/updates tools on setup
    config = function()
      require("go").setup({
        -- Disable standard lsp keymapping, we define them below or use globals/lspsaga
        lsp_keymaps = false,
        -- Automatically set inlay hints (autocmd recommended by go.nvim)
        lsp_inlay_hints = { enable = true, only_current_line = false },
        -- Enable codelens (run test, etc)
        lsp_codelens = true,
        -- Use go.nvim diagnostics handler
        lsp_diag_hdlr = true,
        lsp_diag_virtual_text = { spacing = 4, prefix = "●" },
        -- Automatically format on save using LSP (can be disabled if conform.nvim is preferred)
        lsp_document_formatting = true,
        -- Configure test runner (gotestsum requires separate install)
        -- test_runner = "gotestsum",
        -- verbose_tests = true,
        -- Run tests in floating terminal
        run_in_floaterm = true,
        -- Configure delve debugger (ensure go-debug-adapter is installed via Mason)
        -- dap_debug = true,
        -- dap_debug_keymap = "<leader>dd",
        -- dap_debug_term_mode = "integrated", -- "integrated", "external", "floaterm"

        -- Custom on_attach specifically for gopls via go.nvim
        lsp_on_attach = function(client, bufnr)
          -- Call default on_attach if defined in core.lua
          -- require('plugins.lsp.core').on_attach(client, bufnr) -- Example if needed

          -- Go specific keymaps
          local map = vim.keymap.set
          local opts = { buffer = bufnr }
          map("n", "<leader>gs", "<cmd>GoStatus<CR>", vim.tbl_extend("force", opts, { desc = "Go Status" }))
          map("n", "<leader>gt", "<cmd>GoTestFunc<CR>", vim.tbl_extend("force", opts, { desc = "Go Test Function" }))
          map("n", "<leader>gT", "<cmd>GoTestFile<CR>", vim.tbl_extend("force", opts, { desc = "Go Test File" }))
          map("n", "<leader>gi", "<cmd>GoImport<CR>", vim.tbl_extend("force", opts, { desc = "Go Add Import" }))
          map("n", "<leader>ge", "<cmd>GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go Add if err != nil" }))
          map(
            "n",
            "<leader>gc",
            "<cmd>GoCoverageToggle<CR>",
            vim.tbl_extend("force", opts, { desc = "Go Toggle Coverage" })
          )
          map("n", "<leader>gr", "<cmd>GoRun<CR>", vim.tbl_extend("force", opts, { desc = "Go Run" }))
          map("n", "<leader>gd", "<cmd>GoDescribe<CR>", vim.tbl_extend("force", opts, { desc = "Go Describe Symbol" }))
          map("n", "<leader>gj", "<cmd>GoAddJsonTag<CR>", vim.tbl_extend("force", opts, { desc = "Go Add JSON Tag" }))
          map("n", "<leader>gu", "<cmd>GoUpdateDeps<CR>", vim.tbl_extend("force", opts, { desc = "Go Update Deps" }))
          -- Add other go.nvim mappings as desired (e.g., delve debugging)
        end,
      })
    end,
  },
}
