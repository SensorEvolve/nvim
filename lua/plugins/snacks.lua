return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            layout = {
              width = 24,
            },
          },
        },
      },
    },
  },
  init = function()
    -- Ensure this runs after the plugin might have set up its own highlights
    -- or when colorscheme is loaded.
    vim.api.nvim_set_hl(0, "SnacksGitUntracked", { fg = "#A0A0A0" }) -- Example color
    -- Add any other highlight overrides here
  end,
}
