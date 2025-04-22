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

-- Auto-format on save for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("format_on_save"),
  pattern = { "lua", "python", "rust", "typescript", "typescriptreact", "javascript", "javascriptreact", "go" },
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup("format_on_save_" .. vim.bo.filetype),
      buffer = 0,
      callback = function()
        -- Check if conform.nvim is available
        local ok, conform = pcall(require, "conform")
        if ok then
          conform.format({ bufnr = 0 })
        else
          -- Try using LSP formatting as fallback
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end
      end,
    })
  end,
})

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

-- Special Rust settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("rust_settings"),
  pattern = { "rust" },
  callback = function()
    -- Auto-run rustfmt on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup("rust_format"),
      buffer = 0,
      callback = function()
        -- Check if rust-tools is available
        local rt_ok, _ = pcall(require, "rust-tools")
        if rt_ok then
          vim.cmd("RustFmt")
        else
          -- Fallback to LSP formatting
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end
      end,
    })
  end,
})

-- Typst settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("typst_settings"),
  pattern = { "typst" },
  callback = function()
    -- Enable previewing
    vim.opt_local.wrap = true
    vim.opt_local.spell = true

    -- Add keymaps
    vim.keymap.set("n", "<leader>tw", "<cmd>TypstWatch<CR>", { buffer = 0, desc = "Typst Watch" })
  end,
})

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

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_settings"),
  pattern = { "markdown" },
  callback = function()
    -- Enable markview
    vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<CR>", { buffer = 0, desc = "Toggle Markview" })
  end,
})

-- CSV settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("csv_settings"),
  pattern = { "csv" },
  callback = function()
    vim.keymap.set("n", "<leader>cv", "<cmd>CsvViewToggle<CR>", { buffer = 0, desc = "Toggle CSV View" })
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
