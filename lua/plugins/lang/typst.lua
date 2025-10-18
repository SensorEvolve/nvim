-- Contains Typst specific configurations

return {
  -- Configure Typst LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typst_lsp = {
          settings = {
            -- Options for the typst-lsp server
            exportPdf = "onSave", -- "onSave" or "onType" or "never"
            -- serverPath = "path/to/typst-lsp", -- Only needed if not managed by Mason
          },
        },
      },
    },
  },

  -- Typst file settings and keymaps
  {
    "kaarmu/typst.vim",
    ft = "typst",
    config = function()
      -- Additional Typst buffer settings and keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        group = vim.api.nvim_create_augroup("custom_typst_settings", { clear = true }),
        callback = function(event)
          local bufnr = event.buf

          -- Buffer settings
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.opt_local.wrap = true

          -- Typst keymaps (buffer-local)
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
          end, { buffer = bufnr, desc = "Compile & Open Typst PDF" })

          vim.keymap.set("n", "<leader>tw", function()
            local file = vim.fn.expand("%:p")
            vim.notify("Starting Typst watch...", vim.log.levels.INFO)
            vim.fn.jobstart({ "typst", "watch", file, "--open" }, {
              detach = true,
            })
          end, { buffer = bufnr, desc = "Start Typst Watch" })
        end,
      })
    end,
  },
}
