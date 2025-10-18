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

-- Typst keymaps (buffer-local, only work in .typ files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set("n", "<leader>tp", function()
      local file = vim.fn.expand("%:p")
      local pdf = vim.fn.expand("%:p:r") .. ".pdf"
      vim.fn.jobstart({ "typst", "compile", file }, {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("Typst compiled successfully", vim.log.levels.INFO)
            vim.fn.jobstart({ "cmd.exe", "/c", "start", '""', pdf }, { detach = true })
          else
            vim.notify("Typst compilation failed", vim.log.levels.ERROR)
          end
        end,
      })
    end, { buffer = bufnr, desc = "Compile & Open Typst PDF", noremap = true })

    vim.keymap.set("n", "<leader>tw", function()
      local file = vim.fn.expand("%:p")
      vim.notify("Starting Typst watch...", vim.log.levels.INFO)
      vim.fn.jobstart({ "typst", "watch", file, "--open" }, { detach = true })
    end, { buffer = bufnr, desc = "Start Typst Watch", noremap = true })
  end,
})

-- Move lines up and down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move line down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move line up" })

-- Markdown preview keymaps (buffer-local, only works in .md files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<CR>", {
      buffer = bufnr,
      desc = "Toggle Markdown Preview",
      noremap = true,
      silent = true,
    })
    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", {
      buffer = bufnr,
      desc = "Start Markdown Preview",
      noremap = true,
      silent = true,
    })
    vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", {
      buffer = bufnr,
      desc = "Stop Markdown Preview",
      noremap = true,
      silent = true,
    })
  end,
})
