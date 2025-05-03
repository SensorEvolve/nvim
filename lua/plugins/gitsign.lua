-- ~/.config/nvim/lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" }, -- Using a different symbol for delete
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      -- Keymaps (optional, LazyVim might provide some defaults)
      -- You can set keymaps specifically for this plugin using the 'keys' table
      -- or configure them globally in your keymaps.lua file.
      -- Example using 'keys' table:
      keys = {
        -- Navigation through hunks
        {
          "]h",
          function()
            require("gitsigns").next_hunk({ navigation_message = false })
          end,
          mode = "n",
          desc = "Next Hunk (gitsigns)",
        },
        {
          "[h",
          function()
            require("gitsigns").prev_hunk({ navigation_message = false })
          end,
          mode = "n",
          desc = "Prev Hunk (gitsigns)",
        },
        -- Actions
        { "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Stage Hunk (gitsigns)" },
        { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Reset Hunk (gitsigns)" },
        { "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", mode = "n", desc = "Undo Stage Hunk (gitsigns)" },
        { "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", mode = "n", desc = "Stage Buffer (gitsigns)" },
        { "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", mode = "n", desc = "Reset Buffer (gitsigns)" },
        { "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", mode = "n", desc = "Preview Hunk (gitsigns)" },
        { "<leader>hb", "<cmd>Gitsigns blame_line<CR>", mode = "n", desc = "Blame Line (gitsigns)" },
        { "<leader>hd", "<cmd>Gitsigns diffthis<CR>", mode = "n", desc = "Diff This (gitsigns)" },
        -- Text object
        { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select Hunk (gitsigns)" },
      },
      --[[
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc = "Next Hunk (gitsigns)"})

        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc = "Prev Hunk (gitsigns)"})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', {desc = "Stage Hunk (gitsigns)"})
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {desc = "Reset Hunk (gitsigns)"})
        map('n', '<leader>hS', gs.stage_buffer, {desc = "Stage Buffer (gitsigns)"})
        map('n', '<leader>hu', gs.undo_stage_hunk, {desc = "Undo Stage Hunk (gitsigns)"})
        map('n', '<leader>hR', gs.reset_buffer, {desc = "Reset Buffer (gitsigns)"})
        map('n', '<leader>hp', gs.preview_hunk, {desc = "Preview Hunk (gitsigns)"})
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = "Blame Line (gitsigns)"})
        map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = "Toggle Blame (gitsigns)"})
        map('n', '<leader>hd', gs.diffthis, {desc = "Diff This (gitsigns)"})
        map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = "Diff This ~ (gitsigns)"})
        map('n', '<leader>td', gs.toggle_deleted, {desc = "Toggle Deleted (gitsigns)"})

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = "Select Hunk (gitsigns)"})
      end
      --]]
      -- End of example on_attach
    },
  },
}
