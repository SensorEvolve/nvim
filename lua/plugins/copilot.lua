return {
  -- Main copilot plugin
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            -- Changed to use Ctrl instead of Meta
            accept = "<C-l>",
            accept_word = "<C-w>",
            accept_line = "<C-j>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-h>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 16.x
        server_opts_overrides = {},
      })
    end,
  },
  -- Integration with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Check if nvim-cmp is available
      local has_cmp, cmp = pcall(require, "cmp")
      if has_cmp then
        require("copilot_cmp").setup({
          method = "getCompletionsCycling",
          formatters = {
            label = require("copilot_cmp.format").format_label_text,
            insert_text = require("copilot_cmp.format").format_insert_text,
            preview = require("copilot_cmp.format").deindent,
          },
        })

        -- Add copilot source to cmp
        local sources = cmp.get_config().sources
        table.insert(sources, { name = "copilot", group_index = 2 })
        cmp.setup({ sources = sources })
      end
    end,
  },
}
