-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf

    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end

    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)

    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Set specific options for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "markdown", "text", "mail" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto-format on save is now handled by conform.nvim's format_on_save option
-- See lua/plugins/lsp/formatting.lua for configuration

-- Automatically set indent settings based on filetype
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("indent_settings"),
  pattern = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Special Rust settings (removed nested autocmd - formatting handled by main format_on_save)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("rust_settings"),
  pattern = { "rust" },
  callback = function()
    -- Rust-specific settings can go here if needed
    -- Formatting is handled by the main format_on_save autocmd above
  end,
})

-- Typst settings moved to lua/plugins/lang/typst.lua for better organization

-- Python settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python_settings"),
  pattern = { "python" },
  callback = function()
    -- Add keymaps for Python
    vim.keymap.set(
      "n",
      "<leader>pr",
      "<cmd>lua require('dap-python').test_method()<CR>",
      { buffer = 0, desc = "Python Test Method" }
    )
    vim.keymap.set(
      "n",
      "<leader>pc",
      "<cmd>lua require('dap-python').test_class()<CR>",
      { buffer = 0, desc = "Python Test Class" }
    )
    vim.keymap.set(
      "n",
      "<leader>pd",
      "<cmd>lua require('dap-python').debug_selection()<CR>",
      { buffer = 0, desc = "Python Debug Selection" }
    )
  end,
})
-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_settings"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- Autosize quickfix window based on content
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("qf_settings"),
  pattern = { "qf" },
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.cmd("wincmd J") -- Move to bottom of screen

    -- Adjust height based on content (max 10 lines)
    local qf_height = math.min(10, math.max(3, vim.fn.line("$")))
    vim.cmd("resize " .. qf_height)
  end,
})
