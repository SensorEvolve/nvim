-- Contains Rust specific configurations

-- Helper function to check if a path exists and is executable
local function executable(path)
  return path and vim.fn.executable(path) == 1
end

-- Helper function to find codelldb paths
local function get_codelldb_paths()
  local mason_registry = require("mason-registry")
  local codelldb_pkg = mason_registry.get_package("codelldb")
  local extension_path = codelldb_pkg:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb"

  if vim.fn.has("win32") == 1 then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  elseif vim.fn.has("mac") == 1 then
    liblldb_path = liblldb_path .. ".dylib"
  else -- Linux
    liblldb_path = liblldb_path .. ".so"
  end

  if executable(codelldb_path) and vim.loop.fs_stat(liblldb_path) then
    return codelldb_path, liblldb_path
  end
  print("WARNING: codelldb executable or liblldb not found in Mason package path.")
  return nil, nil -- Return nil if paths are not valid
end

return {
  -- Configure Rust Analyzer
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          -- Settings are automatically merged with rust-tools settings below
          -- You can add overrides here if needed, but rust-tools is preferred
        },
        -- TOML LSP for Cargo.toml etc. (ensure taplo is installed)
        taplo = {
          -- Taplo settings if needed
        },
      },
    },
  },

  -- Rust Tools for enhanced Rust workflow
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" }, -- Load only for Rust files
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    opts = function()
      local codelldb_path, liblldb_path = get_codelldb_paths()
      local dap_adapter = nil

      if codelldb_path and liblldb_path then
        dap_adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      else
        print("WARNING: Falling back to default dap adapter setup for rust-tools.")
      end

      return {
        -- DAP configuration
        dap = {
          adapter = dap_adapter, -- Use discovered adapter or fallback
          -- You might need additional DAP config here depending on your setup
        },
        -- Tools settings (runnables, inlay hints, hover actions)
        tools = {
          runnables = { use_telescope = true },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
          hover_actions = { auto_focus = true },
          -- Executor = require("rust-tools.executors").termopen, -- Example: Use termopen
        },
        -- Server settings (merged with nvim-lspconfig settings)
        server = {
          settings = {
            -- rust-analyzer settings
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Use clippy for checks
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = { enable = true },
              diagnostics = { enable = true },
              -- Inlay hints configuration (fine-tune specific hints)
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 10 },
                closureReturnTypeHints = { enable = "never" }, -- Example override
                lifetimeElisionHints = { enable = "skip_trivial" },
                maxLength = 15,
                parameterHints = { enable = true },
                reborrowHints = { enable = "never" },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
          -- on_attach function specific to rust-analyzer
          on_attach = function(client, bufnr)
            -- Call default on_attach if defined in core.lua
            -- require('plugins.lsp.core').on_attach(client, bufnr) -- Example if needed

            -- Rust specific keymaps
            local map = vim.keymap.set
            local opts = { buffer = bufnr }
            map("n", "K", "<cmd>RustHoverActions<CR>", vim.tbl_extend("force", opts, { desc = "Hover Actions (Rust)" }))
            map(
              "n",
              "<leader>ca",
              "<cmd>RustCodeAction<CR>",
              vim.tbl_extend("force", opts, { desc = "Code Action (Rust)" })
            )
            map(
              "n",
              "<leader>rr",
              "<cmd>RustRunnables<CR>",
              vim.tbl_extend("force", opts, { desc = "Runnables (Rust)" })
            )
            map(
              "n",
              "<leader>dd",
              "<cmd>RustDebuggables<CR>",
              vim.tbl_extend("force", opts, { desc = "Debuggables (Rust)" })
            )
            map(
              "n",
              "<leader>re",
              "<cmd>RustExpandMacro<CR>",
              vim.tbl_extend("force", opts, { desc = "Expand Macro (Rust)" })
            )
            map(
              "n",
              "<leader>rc",
              "<cmd>RustOpenCargo<CR>",
              vim.tbl_extend("force", opts, { desc = "Open Cargo.toml (Rust)" })
            )
            map(
              "n",
              "<leader>rp",
              "<cmd>RustParentModule<CR>",
              vim.tbl_extend("force", opts, { desc = "Go Parent Module (Rust)" })
            )

            -- You might not need this if inlay hints are enabled globally in core.lua's on_attach
            -- vim.cmd("autocmd BufEnter,BufWinEnter,TabEnter <buffer> lua require('rust-tools').inlay_hints.set()")
          end,
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  -- Crates.nvim for Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead Cargo.toml", -- Load when opening Cargo.toml
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
          border = "rounded",
        },
        -- null_ls integration can be enabled if you use none-ls for TOML actions
        -- null_ls = { enabled = true, name = "crates.nvim" },
      })

      -- Setup keymaps specifically for Cargo.toml buffers
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("custom_crates_maps", { clear = true }),
        pattern = "Cargo.toml",
        callback = function(args)
          local map = vim.keymap.set
          local opts = { buffer = args.buf, noremap = true, silent = true }

          -- Show dependency info automatically or manually
          -- require("crates").show() -- Show automatically on BufRead

          map("n", "<leader>ct", function()
            require("crates").toggle()
          end, vim.tbl_extend("force", opts, { desc = "Toggle Crate Info" }))
          map("n", "<leader>cr", function()
            require("crates").reload()
          end, vim.tbl_extend("force", opts, { desc = "Reload Crates" }))
          map("n", "<leader>cv", function()
            require("crates").show_versions_popup()
          end, vim.tbl_extend("force", opts, { desc = "Show Versions" }))
          map("n", "<leader>cf", function()
            require("crates").show_features_popup()
          end, vim.tbl_extend("force", opts, { desc = "Show Features" }))
          map("n", "<leader>cd", function()
            require("crates").open_documentation()
          end, vim.tbl_extend("force", opts, { desc = "Open Documentation" }))
          map("n", "<leader>cu", function()
            require("crates").update_crate()
          end, vim.tbl_extend("force", opts, { desc = "Update Crate" }))
          map("n", "<leader>ca", function()
            require("crates").update_all_crates()
          end, vim.tbl_extend("force", opts, { desc = "Update All Crates" }))
          map("n", "<leader>cU", function()
            require("crates").upgrade_crate()
          end, vim.tbl_extend("force", opts, { desc = "Upgrade Crate" }))
          map("n", "<leader>cA", function()
            require("crates").upgrade_all_crates()
          end, vim.tbl_extend("force", opts, { desc = "Upgrade All Crates" }))
        end,
      })
    end,
  },
}
