return {
  {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("n", "<leader>mf", ":Neoformat<CR>", { desc = "Format with Neoformat" })
    end,
  },
  {
    "ixru/nvim-markdown", -- Primarily for concealing markdown markers in buffer
    ft = { "markdown" },
    -- No config needed here if you're just using its default conceal features.
    -- Or, if it has specific options you want to set, add them here,
    -- but not a keymap for a preview command it doesn't own.
  },
  {
    "iamcco/markdown-preview.nvim",
    -- cmd = { ... }, -- These are fine, can be inferred by ft and commands in config
    ft = { "markdown" }, -- This is a good trigger
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0 -- Good to keep this 0 while debugging
      vim.g.mkdp_echo_preview_url = 1 -- Important: This will try to print the URL
      vim.g.mkdp_debug = 1 -- Important: This enables verbose debug messages
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
      -- You can also add other keymaps if needed, e.g.,
      -- vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", { desc = "Stop Markdown Preview" })
    end,
  },
  -- For syntax highlighting, ensure nvim-treesitter is set up for markdown
  -- Lazynvim usually handles this by default in its treesitter configuration.
  -- e.g., in your lua/plugins/treesitter.lua or similar:
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "markdown",
  --       "markdown_inline",
  --       -- other languages
  --     },
  --   },
  -- },
}
