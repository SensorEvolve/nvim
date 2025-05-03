-- Contains Python specific configurations

return {
  -- Configure Python LSPs (pylsp, pyright)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright: Focused on type checking and performance
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace", -- Analyze whole workspace
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic", -- Can be "off", "basic", or "strict"
                -- reportMissingImports = "warning", -- Example adjustment
              },
            },
          },
          -- Optional: Define root directory patterns if needed
          -- root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", ".git")
        },
        -- Pylsp: Offers broader plugins (linting, formatting, refactoring via rope)
        -- Consider disabling if pyright + conform/none-ls (ruff) is sufficient
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- Linters (Ruff via none-ls is generally preferred)
                -- pycodestyle = { enabled = false },
                -- pyflakes = { enabled = false },
                -- pylint = { enabled = false },
                ruff = { enabled = true }, -- Enable if using pylsp's ruff integration *instead* of none-ls

                -- Type checking (handled by pyright)
                mypy = { enabled = false },

                -- Formatters (handled by conform.nvim)
                black = { enabled = false },
                isort = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },

                -- Code Intelligence / Refactoring
                jedi_completion = { enabled = true, fuzzy = true },
                jedi_definition = { enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true },
                rope = { enabled = true }, -- Keep if Rope refactoring is desired
                rope_autoimport = { enabled = true },
              },
            },
          },
        },
      },
    },
  },

  -- Python Virtual Environment Selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }, -- Add Plenary
    event = "VeryLazy", -- Load when needed
    opts = {
      name = { "venv", ".venv", "env", ".env" }, -- Common venv names
      auto_refresh = true,
      stay_on_this_version = true, -- Add this line to silence the upgrade warning
      -- Optional settings:
      -- search_depth = 5,
      -- border = "rounded",
      -- python_executable = "/usr/bin/python3", -- Specify python for venv creation
      -- window_commands = { -- Commands to run after venv selection
      --   prompt_update_venv = true,
      -- },
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python Venv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
    },
  },

  -- Debugging support (Core DAP and Python adapter)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Python Debug Adapter
      {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" }, -- Ensure DAP loads first
        config = function()
          -- Setup dap-python, attempting to find python used by debugpy
          -- Ensure 'debugpy' is installed (e.g., via Mason)
          local status_ok, mason_registry = pcall(require, "mason-registry")
          if not status_ok then
            vim.notify("Mason registry not found. Cannot automatically find debugpy.", vim.log.levels.WARN)
            require("dap-python").setup() -- Fallback setup
            return
          end

          local pkg = mason_registry.get_package("debugpy")
          local dap_python_path = pkg:get_install_path() .. "/venv/bin/python" -- Adjust path if needed

          if vim.fn.executable(dap_python_path) == 1 then
            require("dap-python").setup(dap_python_path)
            vim.notify("dap-python setup with: " .. dap_python_path, vim.log.levels.INFO)
          else
            vim.notify("WARNING: debugpy python executable not found for dap-python.", vim.log.levels.WARN)
            require("dap-python").setup() -- Fallback
          end

          -- Setup Python DAP keymaps using a FileType autocmd
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            group = vim.api.nvim_create_augroup("custom_python_dap_maps", { clear = true }),
            callback = function(event)
              local map = vim.keymap.set
              local opts = { buffer = event.buf, silent = true }
              map("n", "<leader>dpr", function()
                require("dap-python").test_method()
              end, vim.tbl_extend("force", opts, { desc = "Debug Python Method" }))
              map("n", "<leader>dpc", function()
                require("dap-python").test_class()
              end, vim.tbl_extend("force", opts, { desc = "Debug Python Class" }))
              map("n", "<leader>dps", function()
                require("dap-python").debug_selection()
              end, vim.tbl_extend("force", opts, { desc = "Debug Selected Python" }))
              -- Standard DAP keys (toggle breakpoint, continue, step over, etc.)
              map("n", "<leader>db", function()
                require("dap").toggle_breakpoint()
              end, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
              map("n", "<leader>dc", function()
                require("dap").continue()
              end, vim.tbl_extend("force", opts, { desc = "Continue" }))
              map("n", "<leader>do", function()
                require("dap").step_over()
              end, vim.tbl_extend("force", opts, { desc = "Step Over" }))
              map("n", "<leader>di", function()
                require("dap").step_into()
              end, vim.tbl_extend("force", opts, { desc = "Step Into" }))
              map("n", "<leader>du", function()
                require("dap").step_out()
              end, vim.tbl_extend("force", opts, { desc = "Step Out" }))
              map("n", "<leader>dr", function()
                require("dap").repl.toggle()
              end, vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))
              map("n", "<leader>dl", function()
                require("dap").run_last()
              end, vim.tbl_extend("force", opts, { desc = "Run Last DAP Config" }))
              map("n", "<leader>dt", function()
                require("dap").terminate()
              end, vim.tbl_extend("force", opts, { desc = "Terminate DAP" }))
            end,
          })
        end,
      },
      -- DAP UI for a graphical debugging interface
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap", -- Ensure DAP core is loaded first
          "nvim-neotest/nvim-nio", -- Required dependency
        },
        opts = {
          -- Configure icons, layouts, controls etc.
          -- See https://github.com/rcarriga/nvim-dap-ui#available-options
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 40, -- Width of the sidebar
              position = "left",
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 0.25, -- Height of the bottom panel
              position = "bottom",
            },
          },
          controls = { enabled = true },
          floating = { max_height = nil, max_width = nil },
          render = { max_value_lines = 100 },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)
          -- Open/close UI automatically on DAP events
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
    },
    keys = {
      -- Define global DAP keys if desired (e.g., <F5> to continue)
      -- { "<F5>", function() require("dap").continue() end, desc = "DAP Continue"},
    },
  },
}
