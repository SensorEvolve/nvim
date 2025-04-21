return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
        return 20
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = { noremap = true }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    end

    -- Automatically set terminal keymaps when opening a terminal
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    -- Create shortcuts for different terminal layouts
    local Terminal = require("toggleterm.terminal").Terminal

    -- Floating terminal
    local float = Terminal:new({ direction = "float" })
    function _FLOAT_TOGGLE()
      float:toggle()
    end
    vim.keymap.set("n", "<leader>tf", "<cmd>lua _FLOAT_TOGGLE()<CR>", { desc = "Float Terminal" })

    -- Horizontal terminal
    local horizontal = Terminal:new({ direction = "horizontal" })
    function _HORIZONTAL_TOGGLE()
      horizontal:toggle()
    end
    vim.keymap.set("n", "<leader>th", "<cmd>lua _HORIZONTAL_TOGGLE()<CR>", { desc = "Horizontal Terminal" })

    -- Vertical terminal
    local vertical = Terminal:new({ direction = "vertical" })
    function _VERTICAL_TOGGLE()
      vertical:toggle()
    end
    vim.keymap.set("n", "<leader>tv", "<cmd>lua _VERTICAL_TOGGLE()<CR>", { desc = "Vertical Terminal" })

    -- Lazygit terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
      },
    })
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
    vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
  end,
}
