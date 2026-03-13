return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      -- Global groups
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>m", group = "markdown" },
      { "<leader>r", group = "rename/rust" },
      { "<leader>t", group = "terminal/typst" },
      { "<leader>tp", desc = "Compile & open PDF" },
      { "<leader>tw", desc = "Watch (live preview)" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>y", group = "yazi" },
    },
  },
}
