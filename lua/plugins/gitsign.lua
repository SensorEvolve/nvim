-- ~/.config/nvim/lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
    opts = {
      -- All your gitsigns options *except* the 'keys' table go here
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      -- Note: The 'keys' table that was here is now moved outside 'opts'
      -- The commented out 'on_attach' could also be used here if you prefer that method
      --[[
      on_attach = function(bufnr)
        -- ... your on_attach function ...
      end
      --]]
    }, -- End of opts table

    -- Keymaps are now defined here, at the same level as 'opts' and 'event'
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
    }, -- End of the keys table
  }, -- End of gitsigns plugin specification
} -- End of the returned table
