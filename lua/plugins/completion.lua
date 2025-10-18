-- lua/plugins/competion.lua
return {
  -- Disable nvim-cmp in favor of blink.cmp (already in lazy-lock.json)
  { "hrsh7th/nvim-cmp", enabled = false },
  { "hrsh7th/cmp-nvim-lsp", enabled = false },
  { "hrsh7th/cmp-buffer", enabled = false },
  { "hrsh7th/cmp-path", enabled = false },
  { "saadparwaiz1/cmp_luasnip", enabled = false },

  -- Keep LuaSnip for snippets (blink.cmp can use it)
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      -- Load snippets from various sources
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- blink.cmp is already installed (from lazy-lock.json)
  -- LazyVim should configure it automatically
}
