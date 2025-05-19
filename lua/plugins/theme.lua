return {
  "scottmckendry/cyberdream.nvim",
  lazy = false, -- Load the colorscheme at startup
  priority = 1000, -- Ensure it loads before other UI elements

  config = function()
    -- Call the setup function with your desired options
    -- Below are some examples, refer to the cyberdream.nvim documentation for all options
    require("cyberdream").setup({
      transparent = true, -- Set to true if you want a transparent background
      italic_comments = true, -- Enable italics for comments
      hide_fillchars = false, -- Set to true to replace fillchars with spaces
      borderless_pickers = false, -- Set to true for a modern borderless look in pickers
      terminal_colors = true, -- Apply theme to Neovim's :terminal
      -- variant = "default", -- or "light" or "auto"
      -- saturation = 1,      -- value between 0 and 1
      -- cache = false,       -- set to true after running :CyberdreamBuildCache

      -- Example of overriding specific highlights:
      -- highlights = {
      --   Comment = { fg = "#777777", italic = true },
      --   Normal = { bg = "#0A0E14" } -- if you wanted a slightly different default background
      -- },

      -- Example of overriding colors from the palette:
      -- colors = {
      --   bg = "#000000", -- make background pitch black
      --   green = "#33FF33", -- make green brighter
      -- },

      -- Manage extensions (see cyberdream docs for full list)
      -- extensions = {
      --   telescope = true,
      --   notify = true,
      --   mini = true,
      -- },
    })

    -- Set the colorscheme
    vim.cmd("colorscheme cyberdream")

    -- Optional: Keymap to toggle between light and dark mode
    -- vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true, desc = "Toggle Cyberdream Mode" })

    -- Optional: Autocommand to run custom code on mode toggle
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "CyberdreamToggleMode",
    --   callback = function(event)
    --     vim.notify("Switched to " .. event.data .. " mode!", vim.log.levels.INFO)
    --     -- if event.data == "light" then
    --     --   -- custom actions for light mode
    --     -- else
    --     --   -- custom actions for dark mode
    --     -- end
    --   end,
    -- })
  end,
}
