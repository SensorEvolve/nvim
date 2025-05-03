-- Contains Lua specific configurations

return {
  -- Optional: Fine-tune lua-language-server settings if needed
  -- Most settings are likely handled by LazyVim defaults or core.lua
  -- Example: Add specific globals or disable diagnostics
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- Prevent diagnostics for undefined globals like 'vim'
              diagnostics = { globals = { "vim" } },
              workspace = {
                -- Make sure it knows about runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
                checkThirdParty = false, -- Avoid checking node_modules etc.
              },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
      },
    },
  },

  -- Nvim Lua Development Enhancements
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Only load when editing Lua files
    opts = {
      library = {
        -- Add paths to libraries specs for external plugins
        -- See https://github.com/folke/lazydev.nvim#-library
      },
    },
    dependencies = {
      -- Provides types for Neovim runtime APIs
      "folke/neodev.nvim",
    },
  },

  -- Optional: Add setup for stylua / luacheck here if not handled globally
}
