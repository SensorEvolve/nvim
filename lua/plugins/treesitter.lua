-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Ensure the plugin is listed as a dependency
      -- Add other Treesitter plugins like nvim-treesitter-context if you use them
      -- "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
      -- Ensure languages are installed (add languages as needed)
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      -- Autoinstall parsers (optional, requires :TSUpdate command less often)
      auto_install = true,

      highlight = {
        enable = true,
        -- Use vim regex highlighting for languages without parsers
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        -- disable = { "python" }, -- Example: Disable indent for specific languages if needed
      },

      -- *** Add the textobjects configuration here ***
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward/backward and select node
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer", -- Added custom mapping for loops
            ["il"] = "@loop.inner", -- Added custom mapping for loops
            ["aa"] = "@parameter.outer", -- Added custom mapping for arguments/parameters
            ["ia"] = "@parameter.inner", -- Added custom mapping for arguments/parameters
            -- Add more mappings here based on captures found in queries/textobjects.scm
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]l"] = "@loop.outer", -- Custom mapping
            ["]a"] = "@parameter.outer", -- Custom mapping
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]L"] = "@loop.outer", -- Custom mapping
            ["]A"] = "@parameter.outer", -- Custom mapping
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[l"] = "@loop.outer", -- Custom mapping
            ["[a"] = "@parameter.outer", -- Custom mapping
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[L"] = "@loop.outer", -- Custom mapping
            ["[A"] = "@parameter.outer", -- Custom mapping
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner", -- Example: Swap parameters/arguments
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner", -- Example: Swap parameters/arguments
          },
        },
      },

      -- Other Treesitter modules can be configured here:
      -- incremental_selection = { enable = true, keymaps = { ... } },
      -- context_commentstring = { enable = true, enable_autocmd = false },
      -- matchup = { enable = true },
    },
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    -- Optional: You might need to require the textobjects extension explicitly
    -- Or maybe not, depends on version/setup - the opts table usually handles it
    -- require('nvim-treesitter.textobjects').setup({})
    -- end,
  },
}
