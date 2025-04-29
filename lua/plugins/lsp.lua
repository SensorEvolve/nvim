return {
  -- Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Lua LSP configuration
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim", "require" },
                disable = { "missing-fields" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                },
                maxPreload = 2000,
                preloadFileSize = 1000,
              },
              telemetry = {
                enable = false,
              },
              completion = {
                callSnippet = "Replace",
                showWord = "Disable",
                postfix = ".",
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  quote_style = "double",
                  call_arg_parentheses = "keep",
                },
              },
            },
          },
        },

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

        -- Pyright for more advanced Python type checking
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic", -- Can be "off", "basic", or "strict"
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
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

        -- Add typst-lsp for even better typst support
        typst_lsp = {
          settings = {
            exportPdf = "onSave", -- or "onType" for continuous compilation
            serverPath = nil, -- Let Mason handle this
          },
          cmd = { "typst-lsp" },
        },

        -- JSON with schema support
        jsonls = {
          settings = {
            json = {
              -- Using simple schema validation without schemastore dependency
              validate = { enable = true },
              -- We'll add schemas manually if needed
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                  fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
                  url = "https://json.schemastore.org/prettierrc.json",
                },
              },
            },
          },
        },

        -- YAML with schema support
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
            },
          },
        },

        -- HTML, CSS and related languages
        html = { filetypes = { "html", "htmldjango", "njk", "jinja", "jinja2" } },
        cssls = { filetypes = { "css", "scss", "less" } },
        emmet_language_server = {},

        -- Go language support
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                unusedvariable = true,
                nilness = true,
                shadow = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
              semanticTokens = true,
              usePlaceholders = true,
            },
          },
        },
      },

      -- Configure LSP handlers
      handlers = {
        -- Set cursor position to first error on buffer
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client and client.name == "eslint" then
            if result.diagnostics and #result.diagnostics > 0 then
              -- Show signs in signcolumn but no virtual text or underline
              for _, diag in ipairs(result.diagnostics) do
                diag.severity = vim.diagnostic.severity.HINT
              end
            end
          end
          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
      },

      -- Configure on_attach to run when a LSP connects to a particular buffer
      -- This is where we'll configure key mappings for LSP capabilities
      on_attach = function(client, bufnr)
        -- Enable inlay hints for supported language servers
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end

        -- Set up LSP specific keymaps
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Language-specific keymaps based on filetype
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

        -- Basic LSP actions available for all LSP supported filetypes
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "gr", vim.lsp.buf.references, "Go to References")
        map("n", "gI", vim.lsp.buf.implementation, "Go to Implementation")
        map("n", "gD", vim.lsp.buf.type_definition, "Go to Type Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>cf", vim.lsp.buf.format, "Format Buffer")

        -- Additional filetype-specific keymaps
        if filetype == "rust" then
          -- Rust specific keymaps handled by rust-tools
        elseif filetype == "python" then
          map("n", "<leader>pd", "<cmd>PyrightOrganizeImports<CR>", "Organize Imports")
          map("n", "<leader>pt", "<cmd>lua require('dap-python').test_method()<CR>", "Test Method")
        elseif
          filetype == "typescript"
          or filetype == "typescriptreact"
          or filetype == "javascript"
          or filetype == "javascriptreact"
        then
          -- TypeScript/React specific keymaps handled by typescript-tools
        elseif filetype == "typst" then
          map("n", "<leader>tw", "<cmd>TypstWatch<CR>", "Typst Watch")
          map("n", "<leader>tc", "<cmd>TypstCompile<CR>", "Typst Compile")
          map("n", "<leader>tp", "<cmd>TypstPreview<CR>", "Typst Preview")
        elseif filetype == "go" then
          map("n", "<leader>gt", "<cmd>GoTest<CR>", "Go Test")
          map("n", "<leader>gi", "<cmd>GoImport<CR>", "Go Import")
          map("n", "<leader>gtc", "<cmd>GoCoverage<CR>", "Go Test Coverage")
        end
      end,
    },
  },

  -- Configure Mason to ensure LSP servers, formatters, and linters are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Lua tools
        "lua-language-server", -- LSP for Lua
        "stylua", -- Lua formatter
        "luacheck", -- Lua linter

        -- Rust tools
        "rust-analyzer", -- Rust LSP
        "codelldb", -- Debugging for Rust
        "taplo", -- TOML LSP (for Cargo.toml)

        -- Python tools
        "python-lsp-server", -- Python LSP
        "pyright", -- Type checking
        "ruff", -- Fast Python linter
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

        -- Typst tools
        "typst-lsp", -- LSP for Typst

        -- HTML/CSS/Web tools
        "html-lsp", -- HTML language server
        "css-lsp", -- CSS language server
        "emmet-language-server", -- Emmet support
        "tailwindcss-language-server", -- TailwindCSS support

        -- JSON/YAML tools
        "yaml-language-server", -- YAML language server
        "jsonlint", -- JSON linter

        -- Go tools
        "gopls", -- Go language server
        "goimports", -- Go imports formatter
        "gotests", -- Go test generator
        "go-debug-adapter", -- Go debugging

        -- General purpose tools
        "markdownlint", -- Markdown linter
        "marksman", -- Markdown language server
      })
    end,
  },

  -- We're not using schemastore.nvim anymore
  -- Add it back later if you want with:
  -- {
  --   "b0o/schemastore.nvim",
  -- },

  -- Configure formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- Lua
        ["lua"] = { "stylua" },

        -- Rust
        ["rust"] = { "rustfmt" },
        ["toml"] = { "taplo" },

        -- Python
        ["python"] = { "isort", "black" },

        -- JavaScript/TypeScript/Frontend
        ["typescript"] = { "prettier" },
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["svelte"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["html"] = { "prettier" },

        -- JSON/YAML
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },

        -- Go
        ["go"] = { "goimports", "gofmt" },

        -- Typst
        ["typst"] = { "typstfmt" },

        -- Markdown
        ["markdown"] = { "prettier", "markdownlint" },
      },
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        rustfmt = {
          prepend_args = { "--edition=2021" }, -- Use the latest Rust edition by default
        },
        prettier = {
          -- Use .prettierrc or default config
          prepend_args = { "--print-width", "100" },
        },
        black = {
          prepend_args = { "--line-length", "88" },
        },
        goimports = {
          prepend_args = { "-local", "github.com/your-username" }, -- Replace with your GitHub username
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
        -- Lua
        nls.builtins.formatting.stylua,
        nls.builtins.diagnostics.luacheck,

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

        -- Go
        nls.builtins.formatting.gofmt,
        nls.builtins.formatting.goimports,

        -- Markdown
        nls.builtins.diagnostics.markdownlint,
        nls.builtins.formatting.markdownlint,

        -- Typst (if available)
        -- nls.builtins.formatting.typstfmt,
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
      local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.2"
      local codelldb_path = extension_path .. "/adapter/codelldb"
      local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

      -- Adjust paths based on OS
      if vim.fn.has("win32") == 1 then
        extension_path = vim.env.HOME .. "\\.vscode\\extensions\\vadimcn.vscode-lldb-1.9.2"
        codelldb_path = extension_path .. "\\adapter\\codelldb.exe"
        liblldb_path = extension_path .. "\\lldb\\bin\\liblldb.dll"
      elseif vim.fn.has("mac") == 1 then
        liblldb_path = extension_path .. "/lldb/lib/liblldb.dylib"
      end

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

            -- Additional useful keymaps
            vim.keymap.set("n", "<leader>re", "<cmd>RustExpandMacro<CR>", { buffer = bufnr, desc = "Expand Macro" })
            vim.keymap.set("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { buffer = bufnr, desc = "Open Cargo.toml" })
            vim.keymap.set(
              "n",
              "<leader>rp",
              "<cmd>RustParentModule<CR>",
              { buffer = bufnr, desc = "Go to Parent Module" }
            )
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
          vim.keymap.set("n", "<leader>cu", function()
            require("crates").update_crate()
          end, { buffer = bufnr, desc = "Update Crate" })
          vim.keymap.set("n", "<leader>ca", function()
            require("crates").update_all_crates()
          end, { buffer = bufnr, desc = "Update All Crates" })
          vim.keymap.set("n", "<leader>cU", function()
            require("crates").upgrade_crate()
          end, { buffer = bufnr, desc = "Upgrade Crate" })
          vim.keymap.set("n", "<leader>cA", function()
            require("crates").upgrade_all_crates()
          end, { buffer = bufnr, desc = "Upgrade All Crates" })
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
          vim.keymap.set("n", "<leader>dps", function()
            require("dap-python").debug_selection()
          end, { desc = "Debug Selected Python Code" })
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
      -- Configure handlers
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

  -- Enhanced support for Typst
  {
    "kaarmu/typst.vim",
    ft = "typst",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Set up any special typst-specific configurations
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typst" },
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()

          -- Set up buffer-local keymaps for typst
          vim.keymap.set(
            "n",
            "<leader>tp",
            "<cmd>TypstPreview<CR>",
            { buffer = bufnr, desc = "Preview Typst Document" }
          )

          -- Add additional typst-specific settings
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
        end,
      })
    end,
  },

  -- Go language support
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp_cfg = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      },
      -- Update the diagnostic settings to use the new format
      diagnostic = {
        -- Use the new diagnostic API instead of lsp_diag_virtual_text and lsp_diag_hdlr
        virtual_text = true, -- This replaces lsp_diag_virtual_text
        hdlr = true, -- This replaces lsp_diag_hdlr
      },
      lsp_on_attach = function(client, bufnr)
        -- Set up buffer-local keymaps for Go
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "<leader>gt", "<cmd>GoTest<CR>", "Run Go Tests")
        map("n", "<leader>gta", "<cmd>GoTestAll<CR>", "Run All Go Tests")
        map("n", "<leader>gi", "<cmd>GoImport<CR>", "Go Import")
        map("n", "<leader>gf", "<cmd>GoFmt<CR>", "Format Go Code")
        map("n", "<leader>gc", "<cmd>GoCoverage<CR>", "Go Coverage")
        map("n", "<leader>gr", "<cmd>GoRun<CR>", "Run Go Program")
        map("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", "Test Go Function")
        map("n", "<leader>gtp", "<cmd>GoTestPkg<CR>", "Test Go Package")
        map("n", "<leader>gdh", "<cmd>GoDoc<CR>", "Go Doc Hover")
      end,
      lsp_inlay_hints = {
        enable = true,
      },
      lsp_keymaps = false, -- We'll set our own keymaps
      lsp_codelens = true,
      lsp_diag_hdlr = true,
      lsp_diag_virtual_text = true,
      lsp_document_formatting = true,
      go_term_enabled = true,
      run_in_floaterm = true,
      trouble = true,
      test_runner = "gotestsum", -- use gotestsum if available
      verbose_tests = true,
      test_env = { "CGO_ENABLED=0" },
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gosum", "gowork" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Add Lua-specific configurations and tools
  -- {
  --   "folke/neodev.nvim",
  --   opts = {
  --     library = {
  --       plugins = { "nvim-dap-ui" },
  --       types = true,
  --     },
  --     setup_jsonls = true,
  --     lspconfig = true,
  --     pathStrict = true,
  --   },
  -- },

  -- Nvim-specific Lua development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
    dependencies = {
      "folke/neodev.nvim",
    },
  },

  -- Better diagnostics and symbols outline
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        width = 25,
        relative_width = false,
        auto_close = true,
        auto_jump = false,
        show_cursorline = true,
        show_numbers = false,
        show_relative_numbers = false,
        wrap = false,
      },
      symbols = {
        icons = {
          File = { icon = "󰈙", hl = "Identifier" },
          Module = { icon = "󰆧", hl = "Include" },
          Namespace = { icon = "󰌗", hl = "Include" },
          Package = { icon = "󰏖", hl = "Include" },
          Class = { icon = "󰌗", hl = "Type" },
          Method = { icon = "󰆧", hl = "Function" },
          Property = { icon = "", hl = "Identifier" },
          Field = { icon = "󰆨", hl = "Identifier" },
          Constructor = { icon = "", hl = "Special" },
          Enum = { icon = "󰕘", hl = "Type" },
          Interface = { icon = "", hl = "Type" },
          Function = { icon = "󰊕", hl = "Function" },
          Variable = { icon = "", hl = "Constant" },
          Constant = { icon = "", hl = "Constant" },
          String = { icon = "󰀬", hl = "String" },
          Number = { icon = "󰎠", hl = "Number" },
          Boolean = { icon = "", hl = "Boolean" },
          Array = { icon = "󰅪", hl = "Constant" },
          Object = { icon = "", hl = "Type" },
          Key = { icon = "󰌋", hl = "Type" },
          Null = { icon = "󰟢", hl = "Type" },
          EnumMember = { icon = "", hl = "Identifier" },
          Struct = { icon = "", hl = "Structure" },
          Event = { icon = "", hl = "Type" },
          Operator = { icon = "󰆕", hl = "Operator" },
          TypeParameter = { icon = "󰊄", hl = "Type" },
        },
      },
    },
  },

  -- Language server installer/manager
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "pyright",
        "pylsp",
        "html",
        "cssls",
        "emmet_language_server",
        "jsonls",
        "yamlls",
        "gopls",
        "taplo",
      },
      automatic_installation = true,
    },
  },

  -- Git diff support in Neovim
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    },
  },

  -- Enhanced UI for LSP
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      ui = {
        border = "rounded",
        code_action = "",
      },
      symbol_in_winbar = {
        enable = true,
        separator = " › ",
        hide_keyword = true,
        show_file = true,
        folder_level = 1,
      },
      lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Finder" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to Definition" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
      { "gr", "<cmd>Lspsaga finder<CR>", desc = "Find References" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Actions" },
      { "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
      { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
    },
  },
}
