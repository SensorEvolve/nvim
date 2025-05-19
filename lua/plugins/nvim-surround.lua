return {
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      vim.keymap.set("n", "sa", "<Plug>YSurround", { noremap = true, silent = true, desc = "Add surround" })
      vim.keymap.set("n", "sc", "<Plug>CSurround", { noremap = true, silent = true, desc = "Change surround" })
      vim.keymap.set("n", "sd", "<Plug>DSurround", { noremap = true, silent = true, desc = "Delete surround" })
      vim.keymap.set("v", "sa", "<Plug>VSurround", { noremap = true, silent = true, desc = "Add surround (visual)" })
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
}
