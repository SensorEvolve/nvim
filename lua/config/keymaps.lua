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

-- Additional escape sequence if needed
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, desc = "Terminal ESC" })

-- Map <leader>fh to search help tags using Telescope
vim.keymap.set("n", "<leader>fh", function()
  require("telescope.builtin").help_tags() -- Use Telescope's help tags function
end, { desc = "Search Help Tags (Telescope)" })
