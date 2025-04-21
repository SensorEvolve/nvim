return {
  {
    "kaarmu/typst.vim",
    ft = "typst", -- Load plugin only for Typst files
    opts = {
      -- Optional: Customize plugin options here
      conceal = true, -- Enable concealment for italic, bold, etc.
      conceal_math = true, -- Enable math symbol concealment
      conceal_emoji = true, -- Enable emoji concealment
      auto_open_quickfix = true, -- Auto-open quickfix on errors
      embedded_languages = { "python", "rust", "rs -> rust" }, -- Syntax highlighting for code blocks
    },
  },
}
