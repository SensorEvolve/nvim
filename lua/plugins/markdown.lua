return {
  {
    "ixru/nvim-markdown", -- Primarily for concealing markdown markers in buffer
    ft = { "markdown" },
    -- No config needed here if you're just using its default conceal features.
    -- Or, if it has specific options you want to set, add them here,
    -- but not a keymap for a preview command it doesn't own.
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
    keys = {
      {
        "<leader>mt",
        "<cmd>MarkdownPreviewToggle<CR>",
        desc = "Toggle Markdown Preview",
        ft = "markdown",
      },
    },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = "" -- Use system default browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },
  -- For syntax highlighting, ensure nvim-treesitter is set up for markdown
  -- Lazynvim usually handles this by default in its treesitter configuration.
  -- e.g., in your lua/plugins/treesitter.lua or similar:
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "markdown",
  --       "markdown_inline",
  --       -- other languages
  --     },
  --   },
  -- },
}
