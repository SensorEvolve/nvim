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

-- -- Additional escape sequence if needed
-- vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, desc = "Terminal ESC" })

-- Map CsvView toggle to <leader>cv
vim.keymap.set("n", "<Leader>cv", ":CsvViewToggle<CR>", { noremap = true, desc = "Toggle CSV View" })

-- Map to toggle terminal
vim.keymap.set({ "n", "x" }, "<leader>e", function()
  local oil = require("oil")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if ft == "oil" then
    vim.cmd("close")
  else
    oil.open_float()
  end
end, { silent = true, desc = "Toggle Oil" })

-- Toggle Markview
vim.keymap.set("n", "<leader>mt", ":Markview toggle<CR>", { desc = "Toggle Markview" })

-- Typst keymaps
vim.keymap.set("n", "<leader>tw", ":TypstWatch<CR>", { desc = "Typst Watch" })
vim.keymap.set("n", "<leader>tc", ":make<CR>", { desc = "Typst Compile" })
