-- lua/plugins/competion.lua
return {
  -- Main completion plugin: nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    version = false, -- Improves startup time
    event = "InsertEnter", -- nvim-cmp loads when entering insert mode
    dependencies = {
      -- Source for LSP suggestions
      "hrsh7th/cmp-nvim-lsp",
      -- Source for buffer words
      "hrsh7th/cmp-buffer",
      -- Source for file paths
      "hrsh7th/cmp-path",
      -- Snippet integration
      "saadparwaiz1/cmp_luasnip",
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
        unpack = unpack or table.unpack -- for older Lua versions
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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
