-- Contains core LSP setup (lspconfig, mason, lspsaga)

return {
  -- LSP Configuration Foundation
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim", -- UPDATED
      "mason-org/mason-lspconfig.nvim", -- UPDATED
    },
    opts = {
      -- Global options for nvim-lspconfig
      servers = {
        -- Define global server settings or overrides here if needed
        -- Specific settings are primarily in lang/*.lua files
      },
      handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client and client.name == "eslint" then
            if result.diagnostics and #result.diagnostics > 0 then
              for _, diag in ipairs(result.diagnostics) do
                diag.severity = vim.diagnostic.severity.HINT
              end
            end
          end
          vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
        end,
      },
      on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
        local function map(mode, lhs, rhs, desc)
          local silent = type(rhs) ~= "function"
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = silent })
        end
        map("n", "gI", vim.lsp.buf.implementation, "Go to Implementation")
        map("n", "gD", vim.lsp.buf.type_definition, "Go to Type Definition")
        map("n", "<leader>cf", vim.lsp.buf.format, "Format Buffer (LSP)")
      end,
    },
  },

  -- Mason setup (Manages installations)
  {
    "mason-org/mason.nvim", -- UPDATED
    cmd = "Mason",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- List ALL tools (LSPs, DAPs, Linters, Formatters) you want Mason to manage installation for here
      -- Use MASON package names
      local tools_to_install = {
        -- Lua
        "lua-language-server",
        "stylua",
        "luacheck",
        -- Rust
        "rust-analyzer",
        "codelldb",
        "taplo",
        -- Python
        "python-lsp-server",
        "pyright",
        "ruff",
        "black",
        "debugpy",
        "isort",
        -- Web/TS/JS
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "deno",
        "js-debug-adapter",
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
        "tailwindcss-language-server",
        -- Typst
        "typst-lsp",
        "typstfmt",
        -- JSON/YAML/TOML
        "json-lsp",
        "yaml-language-server",
        "jsonlint",
        -- Go
        "gopls",
        "goimports",
        "gotests",
        "go-debug-adapter",
        "golangci-lint",
        -- General / Other
        "markdownlint",
        "marksman",
        "shellcheck",
        -- NOTE: Removed nvim-nio here - rely on dap-ui dependency install
      }
      vim.list_extend(opts.ensure_installed, tools_to_install)

      -- Ensure no duplicates in Mason list
      local unique_mason_tools = {}
      local seen_mason = {}
      for _, tool in ipairs(opts.ensure_installed) do
        if type(tool) == "string" and not seen_mason[tool] then
          table.insert(unique_mason_tools, tool)
          seen_mason[tool] = true
        end
      end
      opts.ensure_installed = unique_mason_tools
      return opts
    end,
  },

  -- Bridge Mason and nvim-lspconfig (Handles LSP server setup)
  {
    "mason-org/mason-lspconfig.nvim", -- UPDATED
    dependencies = { "mason-org/mason.nvim" }, -- UPDATED: Ensure Mason runs first
    opts = {
      -- *** REMOVED ensure_installed list entirely ***
      -- We will rely on automatic_installation to set up servers
      -- found by Mason that lspconfig knows about.

      -- Ensure automatic installation is enabled
      automatic_installation = true,

      -- You can still define custom handlers here if needed
      -- handlers = {
      --   ["some_server"] = function(server_name) ... end
      -- }
    },
  },

  -- Enhanced UI for LSP (Lspsaga)
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      ui = { border = "rounded", code_action = "💡" },
      symbol_in_winbar = { enable = true, separator = " › ", hide_keyword = true, show_file = true, folder_level = 1 },
      lightbulb = { enable = true, enable_in_insert = false, sign = true, sign_priority = 40, virtual_text = false },
    },
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Finder (Lspsaga)" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to Definition (Lspsaga)" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition (Lspsaga)" },
      { "gr", "<cmd>Lspsaga finder<CR>", desc = "Find References (Lspsaga)" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation (Lspsaga)" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Actions (Lspsaga)" },
      { "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "Rename (Lspsaga)" },
      { "<leader>cld", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics (Lspsaga)" },
      { "<leader>cp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic (Lspsaga)" },
      { "<leader>cn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic (Lspsaga)" },
    },
  },
}
