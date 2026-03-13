-- Contains Typst specific configurations

return {
  -- Configure Typst LSP (tinymist is the modern replacement for typst-lsp)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            exportPdf = "onSave",
          },
        },
      },
    },
  },

  -- Typst syntax and buffer settings
  {
    "kaarmu/typst.vim",
    ft = "typst",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        group = vim.api.nvim_create_augroup("custom_typst_settings", { clear = true }),
        callback = function(bufnr)
          vim.bo[bufnr].spelllang = "en_us"
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          vim.opt_local.spell = true
          vim.opt_local.wrap = true
        end,
      })
    end,
  },
}
