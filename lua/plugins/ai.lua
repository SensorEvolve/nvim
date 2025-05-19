-- In your lazy.nvim plugin specifications (e.g., in lua/plugins/ai.lua or similar)

return {
  {
    "Exafunction/codeium.vim",
    -- Or "Exafunction/windsurf.vim" if preferred by their latest docs for lazy.nvim
    event = "BufEnter",
    config = function()
      -- To disable all default Codeium keybindings:
      -- vim.g.codeium_disable_bindings = 1

      -- To disable only the default Tab keybinding for accepting suggestions:
      vim.g.codeium_no_map_tab = 1

      -- Example custom keymaps (use :help codeium for all available functions)
      -- Accept suggestion
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true, noremap = true })
      -- Dismiss suggestion
      vim.keymap.set("i", "<C-]>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true, noremap = true })
      -- Cycle to next suggestion
      vim.keymap.set("i", "<M-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true, noremap = true })
      -- Cycle to previous suggestion
      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true, noremap = true })
      -- Manually trigger completion (if not automatically showing)
      -- vim.keymap.set('i', '<C-Space>', function () return vim.fn['codeium#Complete']() end, { expr = true, silent = true, noremap = true })

      -- You can also open the Codeium chat panel/window if supported by a command
      -- For example, if there's a :CodeiumChat command:
      -- vim.keymap.set('n', '<leader>ac', "<cmd>CodeiumChat<cr>", { noremap = true, silent = true, desc = "Codeium Chat" })
      -- (Check :help codeium for the exact commands available)
    end,
  },
}
