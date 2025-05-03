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

  -- Typst syntax highlighting and commands (complements LSP)
  {
    "kaarmu/typst.vim",
    ft = "typst",
    dependencies = { "neovim/nvim-lspconfig" }, -- Ensure LSP config is loaded
    config = function()
      -- Setup Typst-specific configurations and keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typst" },
        group = vim.api.nvim_create_augroup("custom_typst_maps_opts", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local map = vim.keymap.set
          local map_opts = { buffer = bufnr, silent = true }

          -- Set buffer-local keymaps for typst commands
          map("n", "<leader>tw", "<cmd>TypstWatch<CR>", vim.tbl_extend("force", map_opts, { desc = "Typst Watch" }))
          map("n", "<leader>tc", "<cmd>TypstCompile<CR>", vim.tbl_extend("force", map_opts, { desc = "Typst Compile" }))
          map(
            "n",
            "<leader>tp",
            "<cmd>TypstPreview<CR>",
            vim.tbl_extend("force", map_opts, { desc = "Typst Preview Document" })
          )
          -- Note: <leader>tl (HTML preview shell command) remains in keymaps.lua

          -- Add additional typst-specific settings
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.opt_local.wrap = true -- Enable wrap for typst files
        end,
      })
    end,
  },
}
