-- Contains configurations for other LSPs and related tools

return {
  -- Configure other LSPs (basic setup)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- JSON LSP (basic setup, schemas configured via schemastore plugin below)
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
              -- Schemas setup is deferred to schemastore.nvim config
            },
          },
        },
        -- YAML LSP (basic setup, schemas configured via schemastore plugin below)
        yamlls = {
          settings = {
            yaml = {
              -- Disable built-in schema store if using schemastore.nvim
              schemaStore = { enable = false },
              -- Schemas setup is deferred to schemastore.nvim config
            },
          },
        },
        -- Markdown LSP (ensure marksman is installed)
        marksman = {
          -- Settings for marksman if needed
        },
        -- TOML LSP is likely configured via lang/rust.lua (using taplo)
      },
    },
  },

  -- Schemastore integration for JSON/YAML schemas
  {
    "b0o/schemastore.nvim",
    -- lazy = true, -- Can be lazy-loaded, config runs on load
    config = function()
      -- Now that schemastore.nvim is loaded, 'schemastore' module is available
      local schemastore = require("schemastore")
      local lspconfig = require("lspconfig")

      -- Update jsonls settings with schemas
      lspconfig.jsonls.setup({
        -- Reuse existing settings if possible, otherwise define fully
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
        -- Add on_attach or other lspconfig options if needed for jsonls specifically
      })

      -- Update yamlls settings with schemas
      lspconfig.yamlls.setup({
        -- Reuse existing settings if possible, otherwise define fully
        settings = {
          yaml = {
            schemaStore = { enable = false }, -- Ensure built-in is off
            schemas = schemastore.yaml.schemas(),
          },
        },
        -- Add on_attach or other lspconfig options if needed for yamlls specifically
      })

      vim.notify("schemastore.nvim configured jsonls and yamlls", vim.log.levels.INFO)
    end,
  },

  -- Code Outline window
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    opts = {
      outline_window = {
        width = 25,
        focus_on_open = true,
        show_numbers = false,
        show_relative_numbers = false,
        wrap = false,
      },
      symbols = {
        icons = { -- Your preferred icons
          File = { icon = "󰈙", hl = "Identifier" },
          Module = { icon = "󰆧", hl = "Include" },
          Namespace = { icon = "󰌗", hl = "Include" },
          Package = { icon = "󰏖", hl = "Include" },
          Class = { icon = "󰌗", hl = "Type" },
          Method = { icon = "󰆧", hl = "Function" },
          Function = { icon = "󰊕", hl = "Function" },
          Field = { icon = "󰆨", hl = "Identifier" },
          Enum = { icon = "󰕘", hl = "Type" },
          Variable = { icon = "󰀫", hl = "Constant" }, -- Example adjustment
          Constant = { icon = "󰏿", hl = "Constant" }, -- Example adjustment
          String = { icon = "󰉿", hl = "String" }, -- Example adjustment
          Number = { icon = "#", hl = "Number" }, -- Example adjustment
          Boolean = { icon = "⊨", hl = "Boolean" }, -- Example adjustment
        },
      },
    },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
  },

  -- Git diff viewer
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
      { "<leader>gf", "<cmd>DiffviewFocusFiles<CR>", desc = "Focus Files (Diffview)" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle Files (Diffview)" },
    },
  },
}
