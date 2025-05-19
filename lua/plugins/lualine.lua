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

    -- Check if we're in a git repo
    local function is_git_repo()
      local filepath = vim.fn.expand("%:p:h")
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir ~= ""
    end

    -- Get the current git branch
    local function get_git_branch()
      if not is_git_repo() then
        return ""
      end
      local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
      if branch ~= "" then
        return " " .. branch
      else
        return ""
      end
    end

    -- File info component showing icon + filename
    local function file_info()
      local file_icon = ""
      local file_name = ""
      local extension = vim.fn.expand("%:e")
      local fname = vim.fn.expand("%:t")

      if extension ~= "" then
        local devicons = require("nvim-web-devicons")
        local icon, color = devicons.get_icon_color(fname, extension, { default = true })
        file_icon = icon .. " "
      end

      if fname ~= "" then
        file_name = fname
      else
        file_name = "[No Name]"
      end

      return file_icon .. file_name
    end

    -- LSP client names
    local function lsp_client_names()
      local clients = {}
      for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(clients, client.name)
      end

      if #clients == 0 then
        return "No LSP"
      else
        return "LSP: " .. table.concat(clients, ", ")
      end
    end

    -- Setup lualine configuration
    lualine.setup({
      options = {
        theme = "cyberdream",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = { "dashboard", "alpha", "starter", "NvimTree", "Trouble", "mason", "toggleterm" },
        },
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          { "mode", padding = { left = 1, right = 1 } },
        },
        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
        },
        lualine_c = {
          { file_info },
          {
            navic.get_location,
            cond = function()
              return navic.is_available()
            end,
          },
        },
        lualine_x = {
          { lsp_client_names },
          { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          { "encoding", padding = { left = 1, right = 0 } },
          {
            "fileformat",
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
            padding = { left = 1, right = 0 },
          },
        },
        lualine_y = {
          { "progress", padding = { left = 1, right = 0 } },
        },
        lualine_z = {
          { "location", padding = { left = 1, right = 1 } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { file_info } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { file_info },
          {
            navic.get_location,
            cond = function()
              return navic.is_available()
            end,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { file_info },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "oil",
        "trouble",
        "lazy",
        "mason",
        "toggleterm",
      },
    })

    -- Initialize navic for showing code context in winbar
    require("nvim-navic").setup({
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
      highlight = true,
      separator = " › ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    })
  end,
}
