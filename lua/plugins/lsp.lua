return {
  -- Configure LSP for Rust
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Python LSP configuration
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- Linting
                pycodestyle = { enabled = true, maxLineLength = 88 },
                pyflakes = { enabled = true },
                pylint = { enabled = true },

                -- Type checking
                mypy = { enabled = true },

                -- Formatters
                black = { enabled = true },
                autopep8 = { enabled = false }, -- Disabled in favor of black
                yapf = { enabled = false }, -- Disabled in favor of black

                -- Refactoring and code intelligence
                rope = { enabled = true },
                rope_autoimport = { enabled = true },

                -- Documentation and analysis
                jedi_completion = { enabled = true, fuzzy = true },
                jedi_definition = { enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true },

                -- Additional linters via ruff integration
                ruff = { enabled = true },
              },
            },
          },
        },

        -- TypeScript/JavaScript LSP configuration
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText = true,
                includeAutomaticOptionalChainCompletions = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              preferences = {
                importModuleSpecifierPreference = "shortest",
                quotePreference = "double",
              },
              updateImportsOnFileMove = {
                enabled = "always",
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText = true,
                includeAutomaticOptionalChainCompletions = true,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },

        -- ESLint LSP configuration
        eslint = {
          settings = {
            packageManager = "npm",
            experimental = {
              useFlatConfig = false,
            },
          },
        },

        -- rust-analyzer configuration
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust code
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              -- Enable experimental features
              experimental = {
                procAttrMacros = true,
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
              -- Typehints and inlay hints
              inlayHints = {
                bindingModeHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                  minLines = 1,
                },
                closureReturnTypeHints = {
                  enable = "always",
                },
                expressionAdjustmentHints = {
                  enable = "always",
                },
                lifetimeElisionHints = {
                  enable = "always",
                  useParameterNames = true,
                },
                parameterHints = {
                  enable = true,
                },
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
        },
      },
    },
  },

  -- Configure Mason to ensure Rust tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Rust tools
        "rust-analyzer", -- Rust LSP
        "codelldb", -- Debugging for Rust
        "taplo", -- TOML LSP (for Cargo.toml)

        -- Python tools
        "python-lsp-server", -- Python LSP (correct name for pylsp)
        "ruff", -- Fast Python linter
        "pyright", -- Type checking (alternative to mypy)
        "black", -- Python formatter
        "debugpy", -- Python debugger
        "isort", -- Import sorter

        -- TypeScript/JavaScript tools
        "typescript-language-server", -- TypeScript/JavaScript LSP
        "eslint-lsp", -- ESLint LSP
        "prettier", -- Code formatter
        "deno", -- Deno support
        "json-lsp", -- JSON language server
        "js-debug-adapter", -- JavaScript/TypeScript debugging
      })
    end,
  },

  -- Configure formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["rust"] = { "rustfmt" },
        ["toml"] = { "taplo" },
        ["python"] = { "isort", "black" },
        ["typescript"] = { "prettier" },
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
      },
      formatters = {
        rustfmt = {
          prepend_args = { "--edition=2021" }, -- Use the latest Rust edition by default
        },
        prettier = {
          -- Use .prettierrc or default config
          -- Add specific prettier options if needed
          prepend_args = { "--print-width", "100" },
        },
      },
    },
  },

  -- Configure none-ls for additional linting/formatting
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        -- Rust
        nls.builtins.diagnostics.rustc,

        -- Python
        nls.builtins.diagnostics.ruff,
        nls.builtins.formatting.black,
        nls.builtins.formatting.isort,
        nls.builtins.diagnostics.mypy,

        -- TypeScript/JavaScript
        nls.builtins.formatting.prettier,
        nls.builtins.diagnostics.eslint,
        nls.builtins.code_actions.eslint,
      })
    end,
  },

  -- Add rust-tools for enhanced features
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = function()
      local extension_path = vim.env.HOME .. "\\.vscode\\extensions\\vadimcn.vscode-lldb-1.9.2"
      local codelldb_path = extension_path .. "\\adapter\\codelldb.exe"
      local liblldb_path = extension_path .. "\\lldb\\bin\\liblldb.dll"

      -- You may need to adjust the paths above based on your actual installation

      return {
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        tools = {
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
          },
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- Enable inlay hints
            vim.cmd("autocmd BufEnter,BufWinEnter,TabEnter *.rs lua require('rust-tools').inlay_hints.set()")

            -- Enable hover with K
            vim.keymap.set("n", "K", "<cmd>RustHoverActions<CR>", { buffer = bufnr })

            -- Enable code actions with <leader>ca
            vim.keymap.set("n", "<leader>ca", "<cmd>RustCodeAction<CR>", { buffer = bufnr })

            -- Run code with <leader>rr
            vim.keymap.set("n", "<leader>rr", "<cmd>RustRunnables<CR>", { buffer = bufnr })

            -- Set breakpoints and debug with <leader>dd
            vim.keymap.set("n", "<leader>dd", "<cmd>RustDebuggables<CR>", { buffer = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  -- Add crates.nvim for Cargo.toml dependencies management
  {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "toml" },
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
        },
        null_ls = {
          enabled = true,
        },
      })
      -- Register autocmds for Cargo.toml files
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CargoCrates", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()

          -- Update crates info when opening Cargo.toml
          require("crates").show()

          -- Set keymaps for crates.nvim when in Cargo.toml
          vim.keymap.set("n", "<leader>ct", function()
            require("crates").toggle()
          end, { buffer = bufnr, desc = "Toggle Crate Info" })
          vim.keymap.set("n", "<leader>cr", function()
            require("crates").reload()
          end, { buffer = bufnr, desc = "Reload Crates" })
          vim.keymap.set("n", "<leader>cv", function()
            require("crates").show_versions_popup()
          end, { buffer = bufnr, desc = "Show Versions" })
          vim.keymap.set("n", "<leader>cf", function()
            require("crates").show_features_popup()
          end, { buffer = bufnr, desc = "Show Features" })
          vim.keymap.set("n", "<leader>cd", function()
            require("crates").open_documentation()
          end, { buffer = bufnr, desc = "Open Documentation" })
        end,
      })
    end,
  },

  -- Add Python-specific plugins and tools
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("venv-selector").setup({
        name = { "venv", ".venv", "env", ".env" },
        auto_refresh = true,
        stay_on_this_version = true,
      })

      -- Set keymaps for Python virtual environment management
      vim.keymap.set("n", "<leader>vv", "<cmd>VenvSelect<CR>", { desc = "Select Python Venv" })
      vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<CR>", { desc = "Select Cached Venv" })
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>vv", desc = "Select Python Venv" },
      { "<leader>vc", desc = "Select Cached Venv" },
    },
  },

  -- Debugging support for Python
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup()

          -- Set keymaps for Python debugging
          vim.keymap.set("n", "<leader>dpr", function()
            require("dap-python").test_method()
          end, { desc = "Debug Python Method" })
          vim.keymap.set("n", "<leader>dpc", function()
            require("dap-python").test_class()
          end, { desc = "Debug Python Class" })
        end,
      },
    },
  },

  -- Add TypeScript-specific plugins and tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
    },
    opts = {
      settings = {
        -- Specify TSServer options
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "shortest",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = true,
          allowRenameOfImportPath = true,
        },
        -- Specify completion options
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        -- Code navigation
        expose_as_code_action = "all",
      },
      -- Configure handlers - fixed to use the correct approach
      handlers = {
        source_definition = function(...)
          return require("typescript-tools.api").handlers.source_definition(...)
        end,
        references = function(...)
          return require("typescript-tools.api").handlers.references(...)
        end,
        document_highlight = function(...)
          return vim.lsp.handlers["textDocument/documentHighlight"](...)
        end,
      },
    },
    config = function(_, opts)
      require("typescript-tools").setup(opts)

      -- Add TypeScript specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()

          -- TypeScript specific actions
          vim.keymap.set(
            "n",
            "<leader>to",
            "<cmd>TSToolsOrganizeImports<CR>",
            { buffer = bufnr, desc = "Organize Imports" }
          )
          vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<CR>", { buffer = bufnr, desc = "Remove Unused" })
          vim.keymap.set(
            "n",
            "<leader>ta",
            "<cmd>TSToolsAddMissingImports<CR>",
            { buffer = bufnr, desc = "Add Missing Imports" }
          )
          vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>", { buffer = bufnr, desc = "Fix All" })
          vim.keymap.set("n", "<leader>tR", "<cmd>TSToolsRenameFile<CR>", { buffer = bufnr, desc = "Rename File" })
          vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<CR>", { buffer = bufnr, desc = "Sort Imports" })

          -- Go to functions, imports, etc.
          vim.keymap.set(
            "n",
            "gti",
            "<cmd>TSToolsGoToSourceDefinition<CR>",
            { buffer = bufnr, desc = "Go To Implementation" }
          )
          vim.keymap.set(
            "n",
            "gT",
            "<cmd>TSToolsGoToTypeDefinition<CR>",
            { buffer = bufnr, desc = "Go To Type Definition" }
          )
        end,
      })
    end,
  },
}
