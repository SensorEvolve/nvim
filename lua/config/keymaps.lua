-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, desc = "Exit insert mode" }) -- Pressing jk in insert mode will exit insert mode

-- Map leader+ww to write the current buffer
vim.keymap.set("n", "<Leader>ww", ":w<CR>", { noremap = true, silent = true, desc = "Write" })

-- Map double leader to open command line
vim.keymap.set("n", "<Leader><Leader>", ":", { noremap = true, desc = "Command Line" })

-- Horizontal and vertical split
vim.keymap.set("n", "<Leader>bh", ":split<CR>", { noremap = true, desc = "Horizontal Split" })
vim.keymap.set("n", "<Leader>bv", ":vsplit<CR>", { noremap = true, desc = "Vertical Split" })

-- Map CsvView toggle to <leader>cv
vim.keymap.set("n", "<Leader>cv", ":CsvViewToggle<CR>", { noremap = true, desc = "Toggle CSV View" })

-- Typst keymaps
vim.keymap.set("n", "<leader>tw", ":TypstWatch<CR>", { desc = "Typst Watch" })
vim.keymap.set(
  "n",
  "<leader>tl",
  "<cmd>!typst watch % --features html --format html --open<CR>",
  { buffer = 0, desc = "Typst HTML Preview" }
)
-- Move lines up and down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

vim.keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", {
  silent = true,
  noremap = true,
  desc = "Toggle Markdown preview on/off",
})
