-- ~/.config/nvim/lua/config/lazy.lua (or wherever you have this file)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  -- Use stable branch for stability
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- The 'spec' determines where lazy.nvim looks for plugin specifications.
  spec = {
    -- 1. Load LazyVim itself and import its default plugin specifications.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 2. Dynamically import all files found in lua/plugins/ and its subdirectories.
    --    This automatically loads any configurations you place there (e.g., theme, lsp, languages).
    { import = "plugins" },

    -- NOTE: All the previous lines like { import = "plugins.lsp.core" },
    -- { import = "plugins.lang.lua" }, { import = "plugins.theme" } etc.
    -- are now covered by the single { import = "plugins" } line above.
  },

  -- Default options for plugins
  defaults = {
    -- Should plugins be lazy-loaded? Set to true if startup time is an issue.
    lazy = false,
    -- Use latest git commits (recommended over version = "*" or specific versions)
    version = false,
  },

  -- Configure installation behavior
  install = {
    -- Ensure these colorschemes are installed (doesn't apply them, just installs)
    -- You might add "vague" here too if your theme plugin needs explicit installation handling,
    -- though usually just defining it in lua/plugins/ is enough.
    colorscheme = { "tokyonight", "habamax" },
  },

  -- Configure plugin update checking
  checker = {
    enabled = true, -- Periodically check for updates
    notify = false, -- Don't automatically notify, use :Lazy update manually
  },

  -- Performance tuning options
  performance = {
    rtp = {
      -- Disable certain standard Vim plugins for potentially faster startup
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        -- "netrwPlugin", -- Keep netrw unless you use nvim-tree or similar
      },
    },
  },
})

-- Optional: You might still want the explicit colorscheme command here
-- as a final guarantee, although the { import = "plugins" } should load
-- your theme config which sets opts.colorscheme = "vague" for LazyVim.
-- If the theme doesn't apply correctly with just the above, uncomment this:
-- vim.cmd.colorscheme("vague")
