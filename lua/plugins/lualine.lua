return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
  },
  config = function()
    local lualine = require("lualine")
    local navic = require("nvim-navic")
    local icons = require("lazyvim.config").icons

    -- Custom ayu_mirage colors
    local colors = {
      bg = "#1F2430",
      fg = "#CBCCC6",
      yellow = "#FFD580",
      cyan = "#5CCFE6",
      darkblue = "#3E4B59",
      green = "#BAE67E",
      orange = "#FF9E64",
      violet = "#D4BFFF",
      magenta = "#F28779",
      blue = "#73D0FF",
      red = "#FF6666",
      statusline_bg = "#171B24",
      grey = "#707A8C",
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
      is_fullscreen = function()
        -- This is a simplistic check - you may need to adapt this for your OS/terminal
        local width = vim.api.nvim_get_option("columns")
        local height = vim.api.nvim_get_option("lines")
        return width > 160 and height > 40
      end,
    }

    -- Custom mode names
    local mode_map = {
      ["n"] = "NORMAL",
      ["no"] = "OPERATOR PENDING",
      ["nov"] = "OPERATOR PENDING",
      ["noV"] = "OPERATOR PENDING",
      ["no\22"] = "OPERATOR PENDING",
      ["niI"] = "NORMAL",
      ["niR"] = "NORMAL",
      ["niV"] = "NORMAL",
      ["v"] = "VISUAL",
      ["V"] = "V-LINE",
      ["\22"] = "V-BLOCK",
      ["s"] = "SELECT",
      ["S"] = "S-LINE",
      ["\19"] = "S-BLOCK",
      ["i"] = "INSERT",
      ["ic"] = "INSERT",
      ["ix"] = "INSERT",
      ["R"] = "REPLACE",
      ["Rc"] = "REPLACE",
      ["Rv"] = "V-REPLACE",
      ["Rx"] = "REPLACE",
      ["c"] = "COMMAND",
      ["cv"] = "EX",
      ["ce"] = "EX",
      ["r"] = "ENTER",
      ["rm"] = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERMINAL",
    }

    -- Configure mode colors
    local mode_colors = {
      n = colors.green,
      i = colors.blue,
      v = colors.magenta,
      [""] = colors.magenta,
      V = colors.magenta,
      c = colors.orange,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }

    -- Custom component functions
    local function mode_label()
      local mode = vim.fn.mode()
      return " " .. mode_map[mode] .. " "
    end

    local function diff_source()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end

    local function get_file_icon_color()
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon, iconhl = require("nvim-web-devicons").get_icon(filename, extension)
      if icon then
        local _, color = require("nvim-web-devicons").get_icon_color(filename, extension)
        return color or colors.fg
      end
      return colors.fg
    end

    -- Show current function/method name with navic
    local function get_current_context()
      if not navic.is_available() then
        return ""
      end
      local context = navic.get_location()
      return context ~= "" and " " .. context or ""
    end

    -- LSP clients attached to buffer
    local function get_lsp_clients()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if next(clients) == nil then
        return "No LSP"
      end

      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end
      return " " .. table.concat(client_names, ", ")
    end

    -- Add a simple spinner for LSP progress (no external dependency)
    local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local spinner_index = 1
    local spinner_timer = nil
    local spinner_client_id = nil
    local spinner_status = ""

    local function update_spinner()
      spinner_index = (spinner_index % #spinner_frames) + 1
      if spinner_client_id then
        spinner_status = spinner_frames[spinner_index] .. " LSP Working"
      else
        spinner_status = ""
      end
      vim.cmd("redrawstatus")
    end

    -- LSP progress indicator
    local function get_lsp_progress()
      if spinner_status ~= "" then
        return spinner_status
      end
      return ""
    end

    -- Set up LSP progress spinner
    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(args)
        local event = args.data
        if event.token then
          if not spinner_timer then
            spinner_timer = vim.loop.new_timer()
            spinner_timer:start(100, 100, vim.schedule_wrap(update_spinner))
          end
          spinner_client_id = event.client_id
        else
          -- Progress done, clear spinner
          if spinner_timer then
            spinner_timer:stop()
            spinner_timer = nil
          end
          spinner_client_id = nil
          spinner_status = ""
        end
      end,
    })

    -- NEW COMPONENTS

    -- Harpoon indicator
    local function harpoon_status()
      -- Check if harpoon is available
      local ok, harpoon = pcall(require, "harpoon.mark")
      if not ok then
        return ""
      end

      local current_file_path = vim.fn.expand("%:p")
      local marked = harpoon.status(current_file_path)
      if marked then
        return " ⚓" -- Harpoon icon
      end
      return ""
    end

    -- LSP references count
    local function lsp_references()
      if not vim.lsp.buf.server_ready() then
        return ""
      end

      local count = 0
      local params = vim.lsp.util.make_position_params()

      -- Try to get references count (asynchronously) - may not work perfectly in all cases
      vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, _, _)
        if not err and result then
          count = #result
        end
      end)

      if count > 0 then
        return " " .. count -- References symbol and count
      end
      return ""
    end

    -- Breakpoints count
    local function breakpoint_count()
      local ok, dap = pcall(require, "dap")
      if not ok then
        return ""
      end

      local breakpoints = dap.breakpoints()
      local count = 0
      for _, bps in pairs(breakpoints) do
        count = count + #bps
      end

      if count > 0 then
        return " " .. count -- Breakpoint symbol and count
      end
      return ""
    end

    -- Recording status
    local function recording_status()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        return " REC(" .. reg .. ")"
      end
      return ""
    end

    -- Clock (for fullscreen mode)
    local function clock()
      if conditions.is_fullscreen() then
        return os.date(" %H:%M")
      end
      return ""
    end

    -- Visual selection info
    local function visual_selection_info()
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then
        local line_start = vim.fn.line("v")
        local line_end = vim.fn.line(".")
        local lines_count = math.abs(line_end - line_start) + 1

        local visual_chars = ""
        if vim.fn.mode() == "v" then
          local col_start = vim.fn.col("v")
          local col_end = vim.fn.col(".")
          local chars_count = 0

          if line_start == line_end then
            chars_count = math.abs(col_end - col_start) + 1
          else
            -- This is a rough approximation for multiline visual selections
            chars_count = vim.fn.wordcount().visual_chars
          end

          visual_chars = chars_count .. "c "
        end

        return visual_chars .. lines_count .. "L"
      end
      return ""
    end

    -- Alternate file name
    local function alt_file_name()
      local alt_file = vim.fn.expand("#:t")
      if alt_file ~= "" then
        return "ﰌ " .. alt_file
      end
      return ""
    end

    -- Mixed indentation indicator
    local function mixed_indent()
      local space_pattern = vim.fn.search("^ ", "nw")
      local tab_pattern = vim.fn.search("^\t", "nw")

      if space_pattern > 0 and tab_pattern > 0 then
        return " mixed"
      end

      local mixed_line = vim.fn.search(" \t", "nw")
      if mixed_line > 0 then
        return " mixed"
      end

      return ""
    end

    local config = {
      options = {
        theme = {
          normal = {
            a = { fg = colors.bg, bg = colors.green, gui = "bold" },
            b = { fg = colors.fg, bg = colors.darkblue },
            c = { fg = colors.fg, bg = colors.statusline_bg },
          },
          insert = { a = { fg = colors.bg, bg = colors.blue, gui = "bold" } },
          visual = { a = { fg = colors.bg, bg = colors.magenta, gui = "bold" } },
          replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
          command = { a = { fg = colors.bg, bg = colors.orange, gui = "bold" } },
          inactive = {
            a = { fg = colors.fg, bg = colors.statusline_bg, gui = "bold" },
            b = { fg = colors.fg, bg = colors.statusline_bg },
            c = { fg = colors.fg, bg = colors.statusline_bg },
          },
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = { "dashboard", "alpha", "starter", "NvimTree", "Trouble", "mason" },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          {
            mode_label,
            color = function()
              return { bg = mode_colors[vim.fn.mode()], fg = colors.bg, gui = "bold" }
            end,
          },
          {
            recording_status,
            color = { fg = colors.bg, bg = colors.red, gui = "bold" },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { fg = colors.violet, gui = "bold" },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = diff_source,
            colored = true,
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.yellow },
              removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
          },
          {
            harpoon_status,
            color = { fg = colors.orange, gui = "bold" },
          },
        },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
            color = { fg = get_file_icon_color },
          },
          {
            "filename",
            path = 1, -- Show relative path
            symbols = {
              modified = "  ",
              readonly = "  ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
            color = { fg = colors.fg, gui = "bold" },
          },
          {
            get_current_context,
            cond = function()
              return navic.is_available()
            end,
            color = { fg = colors.violet },
          },
          {
            alt_file_name,
            color = { fg = colors.grey },
            cond = conditions.hide_in_width,
          },
          {
            function()
              return "%="
            end,
          },
          {
            get_lsp_progress,
            color = { fg = colors.cyan },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.cyan },
              hint = { fg = colors.green },
            },
            colored = true,
          },
          {
            lsp_references,
            color = { fg = colors.yellow },
            cond = conditions.hide_in_width,
          },
          {
            breakpoint_count,
            color = { fg = colors.red },
            cond = conditions.hide_in_width,
          },
          {
            get_lsp_clients,
            icon = "󰒍",
            color = { fg = colors.green, gui = "bold" },
            cond = conditions.hide_in_width,
          },
          {
            mixed_indent,
            color = { fg = colors.yellow },
          },
          {
            visual_selection_info,
            color = { fg = colors.magenta },
          },
          {
            "fileformat",
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
            color = { fg = colors.fg, gui = "bold" },
            cond = conditions.hide_in_width,
          },
          {
            "encoding",
            color = { fg = colors.fg, gui = "bold" },
            cond = conditions.hide_in_width,
          },
          {
            clock,
            color = { fg = colors.cyan },
          },
        },
        lualine_y = {
          {
            "filetype",
            colored = true,
            icon_only = false,
            color = { fg = colors.fg },
          },
        },
        lualine_z = {
          {
            "location",
            color = { fg = colors.bg, bg = colors.blue, gui = "bold" },
          },
          {
            "progress",
            color = { fg = colors.bg, bg = colors.blue, gui = "bold" },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
            color = { fg = get_file_icon_color },
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = "  ",
              readonly = "  ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
            color = { fg = colors.fg, gui = "bold" },
          },
          {
            get_current_context,
            cond = function()
              return navic.is_available()
            end,
            color = { fg = colors.violet },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "lazy",
        "man",
        "mason",
        "nvim-tree",
        "quickfix",
        "symbols-outline",
        "toggleterm",
        "trouble",
      },
    }

    -- Initialize lualine
    lualine.setup(config)
  end,
}
