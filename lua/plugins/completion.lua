-- lua/plugins/cmp.lua (or similar file for lazy.nvim)
return {
  -- Main completion plugin: nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    version = false, -- Improves startup time
    event = "InsertEnter", -- Load plugin once entering insert mode
    dependencies = {
      -- Source for LSP suggestions
      "hrsh7th/cmp-nvim-lsp",
      -- Source for buffer words
      "hrsh7th/cmp-buffer",
      -- Source for file paths
      "hrsh7th/cmp-path",
      -- Snippet integration
      "saadparwaiz1/cmp_luasnip",
      -- Copilot integration <<< Added Dependency
      "zbirenbaum/copilot-cmp",
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: Load default snippets
        config = function()
          -- Load snippets from various sources (optional)
          require("luasnip.loaders.from_vscode").lazy_load()
          -- You might have other LuaSnip configurations here
        end,
      },
    },
    -- Configuration function for nvim-cmp
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Helper function to check if there are words before the cursor
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- Setup nvim-cmp
      cmp.setup({
        -- Snippet engine integration
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- Expand snippets using LuaSnip
          end,
        },
        -- Appearance settings
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- Key mappings for completion
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
          ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation down
          ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion manually
          ["<C-e>"] = cmp.mapping.abort(), -- Close completion menu
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection

          -- Custom mapping for <C-l> (Accept cmp completion or Copilot suggestion)
          ["<C-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              -- Check if copilot suggestion is visible and accept it
              local copilot_sugg_status, copilot_sugg = pcall(require, "copilot.suggestion")
              if copilot_sugg_status and copilot_sugg.is_visible() then
                copilot_sugg.accept()
              else
                -- Otherwise, fallback to default behavior (e.g., insert literal <C-l>)
                fallback()
              end
            end
          end, { "i", "s" }), -- Apply mapping in insert and select modes

          -- Custom mapping for <C-n> (Select next item in cmp or fallback)
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              -- If cmp menu isn't visible, let <C-n> do its default action
              -- (or potentially cycle Copilot suggestions if mapped separately)
              fallback()
            end
          end, { "i", "s" }),

          -- Custom mapping for <C-p> (Select previous item in cmp or fallback)
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              -- If cmp menu isn't visible, let <C-p> do its default action
              -- (or potentially cycle Copilot suggestions if mapped separately)
              fallback()
            end
          end, { "i", "s" }),

          -- Tab completion logic (integrates snippets and auto-completion)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item() -- Select next item in completion menu
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump() -- Expand or jump in snippet
            elseif has_words_before() then
              cmp.complete() -- Trigger completion if there's text before cursor
            else
              fallback() -- Otherwise, fallback to inserting a tab character
            end
          end, { "i", "s" }),

          -- Shift-Tab logic (integrates snippets)
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item() -- Select previous item in completion menu
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1) -- Jump back in snippet
            else
              fallback() -- Otherwise, fallback to default Shift-Tab behavior
            end
          end, { "i", "s" }),
        }),

        -- Define completion sources <<< Copilot Added Here
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP suggestions
          { name = "luasnip" }, -- Snippet suggestions
          { name = "copilot" }, -- GitHub Copilot suggestions
          { name = "buffer" }, -- Buffer word suggestions
          { name = "path" }, -- File path suggestions
        }),

        -- You can add other cmp settings here if needed (e.g., formatting, experimental options)
      })
    end,
  }, -- End of nvim-cmp block

  -- Ensure you also have the simplified copilot-cmp block elsewhere
  -- (as discussed in the previous step) and the main copilot.lua block.
} -- End of the returned table (assuming this file returns a list of plugins)
