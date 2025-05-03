-- optimized-yazi.lua
-- Improved Yazi plugin configuration with performance optimizations and j-key fix
-- Place this in your ~/.config/nvim/lua/plugins/ directory

return {
  "nvim-lua/plenary.nvim", -- Dependency for creating the floating terminal
  event = "VeryLazy",
  config = function()
    -- Environment variables to optimize Yazi performance
    local function set_yazi_env()
      -- Reduce frames per second to ease terminal rendering
      vim.env.YAZI_FPS = "30"

      -- Disable animations
      vim.env.YAZI_DISABLE_ANIMATIONS = "1"

      -- Set lower image quality
      vim.env.YAZI_IMAGE_QUALITY = "30"

      -- Use a simpler image filter
      vim.env.YAZI_IMAGE_FILTER = "nearest"
    end

    -- Restore environment
    local function restore_env()
      vim.env.YAZI_FPS = nil
      vim.env.YAZI_DISABLE_ANIMATIONS = nil
      vim.env.YAZI_IMAGE_QUALITY = nil
      vim.env.YAZI_IMAGE_FILTER = nil
    end

    -- Fix j key delay issues in terminal buffers
    local function fix_terminal_j_key(buf)
      -- Create a function to immediately send the j key without delay
      local send_j = function()
        vim.api.nvim_chan_send(vim.bo[buf].channel, "j")
        return ""
      end

      -- Map j in terminal mode for this buffer to use our custom function
      vim.api.nvim_buf_set_keymap(buf, "t", "j", "", {
        noremap = true,
        nowait = true,
        callback = send_j,
      })
    end

    local function open_yazi(path, opts)
      opts = opts or {}

      -- Set Yazi optimized environment variables
      set_yazi_env()

      -- Use a split window instead of floating for better performance
      if opts.use_split then
        -- Create a horizontal split that's smaller than default
        vim.cmd("botright split")
        vim.cmd("resize 15")

        -- Get current buffer
        local buf = vim.api.nvim_get_current_buf()

        -- Determine path to open Yazi at
        local target_path
        if path == "cwd" then
          target_path = vim.fn.getcwd()
        elseif path == "file" then
          target_path = vim.fn.expand("%:p:h")
        else
          target_path = path or vim.fn.expand("%:p:h")
        end

        -- Fix key mapping issues for the buffer
        vim.api.nvim_create_autocmd("TermOpen", {
          buffer = buf,
          once = true,
          callback = function()
            -- Disable timeouts in terminal mode for this buffer
            vim.opt_local.timeout = false
            vim.opt_local.ttimeout = false

            -- Apply j key fix after a slight delay to ensure terminal is initialized
            vim.defer_fn(function()
              fix_terminal_j_key(buf)
            end, 100)
          end,
        })

        -- Start yazi with performance flags
        vim.fn.termopen("yazi " .. vim.fn.shellescape(target_path), {
          on_exit = function()
            -- Restore environment variables
            restore_env()
            -- Close the buffer if it still exists
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end,
        })

        -- Enter insert mode
        vim.cmd("startinsert")

        -- Store the buffer for later reference
        if not _G.yazi_state then
          _G.yazi_state = {}
        end
        _G.yazi_state.buf = buf

        return nil, buf
      else
        -- Default settings for floating window (reduced size)
        local width = opts.width or 0.7 -- Smaller than original 0.8
        local height = opts.height or 0.7 -- Smaller than original 0.8
        local border = opts.border or "single" -- Simpler border

        -- Create a terminal buffer
        local buf = vim.api.nvim_create_buf(false, true)

        -- Get dimensions
        local ui = vim.api.nvim_list_uis()[1]
        local win_width = math.floor(ui.width * width)
        local win_height = math.floor(ui.height * height)

        -- Calculate position (centered)
        local row = math.floor((ui.height - win_height) / 2)
        local col = math.floor((ui.width - win_width) / 2)

        -- Window options - simplified
        local win_opts = {
          relative = "editor",
          width = win_width,
          height = win_height,
          row = row,
          col = col,
          style = "minimal",
          border = border,
        }

        -- Create window
        local win = vim.api.nvim_open_win(buf, true, win_opts)

        -- Configure window appearance - minimal settings
        vim.api.nvim_win_set_option(win, "winblend", 0)
        vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")

        -- Fix key mapping issues for the buffer
        vim.api.nvim_create_autocmd("TermOpen", {
          buffer = buf,
          once = true,
          callback = function()
            -- Disable timeouts in terminal mode for this buffer
            vim.opt_local.timeout = false
            vim.opt_local.ttimeout = false

            -- Apply j key fix after a slight delay to ensure terminal is initialized
            vim.defer_fn(function()
              fix_terminal_j_key(buf)
            end, 100)
          end,
        })

        -- Determine path to open Yazi at
        local target_path
        if path == "cwd" then
          target_path = vim.fn.getcwd()
        elseif path == "file" then
          target_path = vim.fn.expand("%:p:h")
        else
          target_path = path or vim.fn.expand("%:p:h")
        end

        -- Start yazi in the buffer with performance flags
        vim.fn.termopen("yazi " .. vim.fn.shellescape(target_path), {
          on_exit = function()
            -- Restore environment variables
            restore_env()
            -- Close the window if it still exists when yazi exits
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
            -- Close the buffer
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end,
        })

        -- Enter insert mode
        vim.cmd("startinsert")

        -- Store the window and buffer for later reference
        if not _G.yazi_state then
          _G.yazi_state = {}
        end
        _G.yazi_state.win = win
        _G.yazi_state.buf = buf

        return win, buf
      end
    end

    -- Function to toggle yazi (close if open, open if closed)
    local function toggle_yazi(opts)
      opts = opts or {}

      if _G.yazi_state then
        if _G.yazi_state.win and vim.api.nvim_win_is_valid(_G.yazi_state.win) then
          vim.api.nvim_win_close(_G.yazi_state.win, true)
        end
        if _G.yazi_state.buf and vim.api.nvim_buf_is_valid(_G.yazi_state.buf) then
          vim.api.nvim_buf_delete(_G.yazi_state.buf, { force = true })
        end
        _G.yazi_state = nil
      else
        open_yazi("file", opts)
      end
    end

    -- Create the Yazi command with additional options
    vim.api.nvim_create_user_command("Yazi", function(opts)
      local args = opts.args
      local use_split = false

      -- Check for split flag
      if args:match("%-%-split") then
        use_split = true
        args = args:gsub("%-%-split%s*", "")
      end

      if args:match("toggle") then
        toggle_yazi({ use_split = use_split })
      elseif args:match("cwd") then
        open_yazi("cwd", { use_split = use_split })
      else
        open_yazi(args ~= "" and args or "file", { use_split = use_split })
      end
    end, {
      nargs = "?",
      complete = function(_, _, _)
        return { "toggle", "cwd", "--split" }
      end,
    })

    -- Set up keymappings including the split option
    vim.keymap.set("n", "<leader>yy", function()
      open_yazi("file")
    end, { desc = "Open yazi at the current file" })

    vim.keymap.set("n", "<leader>yc", function()
      open_yazi("cwd")
    end, { desc = "Open yazi in nvim's working directory" })

    vim.keymap.set("n", "<leader>yt", function()
      toggle_yazi()
    end, { desc = "Toggle yazi" })

    -- New split window option
    vim.keymap.set("n", "<leader>ys", function()
      open_yazi("file", { use_split = true })
    end, { desc = "Open yazi in split window (better performance)" })

    -- Global fix for terminal key timeout issues
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        -- Apply terminal-specific settings
        vim.opt_local.timeout = false
        vim.opt_local.ttimeout = false
        vim.opt_local.timeoutlen = 0
        vim.opt_local.ttimeoutlen = 0

        -- Disable cursor line/column highlighting
        vim.opt_local.cursorline = false
        vim.opt_local.cursorcolumn = false

        -- Disable line numbers
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    })

    -- Add a global config option to improve key responsiveness
    vim.g.terminal_responsive = true
  end,
}
