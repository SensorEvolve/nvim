-- Contains configurations for Web Development (TS, JS, HTML, CSS, etc.)

return {
  -- Configure TS/JS Language Servers (tsserver, eslint)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript / JavaScript LSP
        tsserver = {
          -- Settings moved to typescript-tools.nvim for better integration
        },
        -- ESLint LSP
        eslint = {
          settings = {
            -- Explicitly specify package manager if needed (npm, yarn, pnpm)
            -- packageManager = "npm",
            -- Example: Enable experimental flat config support if using eslint.config.js
            -- experimental = { useFlatConfig = true },
            -- codeAction = { disableRuleComment = true, showDocumentation = { enable = true } },
            -- codeActionOnSave = { mode = "all" }, -- Example: Fix on save
            -- format = true, -- Enable if using ESLint for formatting (prettier via conform is likely better)
          },
        },
        -- HTML LSP
        html = {
          -- filetypes = { "html", "htmldjango", "jinja", "njk" }, -- Customize filetypes if needed
        },
        -- CSS LSP (includes SCSS, Less)
        cssls = {
          -- filetypes = { "css", "scss", "less" },
        },
        -- Tailwind CSS LSP (ensure installed via Mason)
        tailwindcss = {
          -- settings specific to tailwindcss-intellisense
          -- filetypes = { "html", "javascriptreact", "typescriptreact", "svelte", "vue" } -- Add relevant filetypes
        },
        -- Emmet LSP (ensure installed via Mason)
        emmet_language_server = {
          filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" }, -- Add relevant filetypes
        },
      },
    },
  },

  -- TypeScript Tools for enhanced TS/JS experience
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    opts = {
      -- Settings passed directly to tsserver setup
      settings = {
        -- Use settings from tsconfig.json automatically
        -- Specifytsserver options if needed
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "shortest", -- "shortest", "relative", "non-relative", "project-relative"
          quotePreference = "double", -- "auto", "double", "single"
        },
        tsserver_format_options = {
          -- Example options:
          -- insertSpaceAfterCommaDelimiter= true,
          -- insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces= true,
        },
        -- Enable/disable inlay hints sourced from tsserver
        -- These will show alongside inlay hints from other sources if enabled globally
        tsserver_plugins = {
          "@typescript-tools/inlay-hints-plugin",
        },
        -- typescript-tools specific settings
        expose_as_code_action = { -- Make TS actions available via code action menu
          "organize_imports",
          "remove_unused",
          "add_missing_imports",
          "fix_all",
          -- "source_definition", -- Example: Add go-to-source if needed
        },
        -- completion_supported = true, -- Use cmp-nvim-lsp instead usually
        -- code_lens = "all", -- Enable code lens if desired ("all", "references", "implementations")
        -- document_highlighting = true, -- Use LSP default usually
      },
      -- Debugging specific settings if needed
      -- debugger_config = { adapter = 'node-debug2', configuration = { ... } },
    },
    config = function(_, opts)
      require("typescript-tools").setup(opts)

      -- Setup keymaps specifically for TS/JS buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        group = vim.api.nvim_create_augroup("custom_ts_maps", { clear = true }),
        callback = function(event)
          local map = vim.keymap.set
          local map_opts = { buffer = event.buf, silent = true }

          map(
            "n",
            "<leader>lo",
            "<cmd>TSToolsOrganizeImports<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Organize Imports (TS)" })
          )
          map(
            "n",
            "<leader>lR",
            "<cmd>TSToolsRemoveUnused<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Remove Unused (TS)" })
          )
          map(
            "n",
            "<leader>la",
            "<cmd>TSToolsAddMissingImports<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Add Missing Imports (TS)" })
          )
          map("n", "<leader>lf", "<cmd>TSToolsFixAll<CR>", vim.tbl_extend("force", map_opts, { desc = "Fix All (TS)" }))
          map(
            "n",
            "<leader>lr",
            "<cmd>TSToolsRenameFile<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Rename File (TS)" })
          )
          map(
            "n",
            "<leader>ls",
            "<cmd>TSToolsSortImports<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Sort Imports (TS)" })
          )
          map(
            "n",
            "gI",
            "<cmd>TSToolsGoToSourceDefinition<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Go To Source Definition (TS)" })
          )
          -- gD (Go to Type Definition) is handled by core LSP/Lspsaga

          -- You might map other TSTools actions here if expose_as_code_action is not used
        end,
      })
    end,
  },
}
