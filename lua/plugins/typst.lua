return {
  -- Typst syntax highlighting
  {
    "kaarmu/typst.vim",
    ft = "typst",
    init = function()
      vim.g.typst_pdf_viewer = "" -- Disable built-in viewer
      vim.g.typst_conceal = 1
      vim.g.typst_auto_open_quickfix = 0 -- Disable auto quickfix
    end,
  },
}
