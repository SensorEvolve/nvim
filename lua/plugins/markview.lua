return {
  "OXY2DEV/markview.nvim",
  ft = "markdown", -- Load only for Markdown files
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Required for syntax parsing
    "nvim-tree/nvim-web-devicons", -- Optional for icons
  },
  config = function()
    require("markview").setup()
  end,
}
