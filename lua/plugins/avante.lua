return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- Set the default provider to Gemini
    provider = "gemini",

    -- Configure the Gemini provider
    gemini = {
      -- Specify the Gemini 1.5 Pro model
      model = "gemini-1.5-pro-latest",

      -- Optional parameters temporarily commented out for testing:
      -- timeout = 30000,
      -- temperature = 0,
      -- max_output_tokens = 8192,

      -- If the error stops after commenting these out, it suggests
      -- avante.nvim might be incorrectly applying one of them (likely
      -- max_output_tokens) to an internal API call.
    },

    -- Removed or commented out the openai section
    -- openai = { ... },

    -- Other avante options...
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- Optional dependencies:
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
  config = function(_, opts)
    -- Standard setup call
    require("avante").setup(opts)
    -- Add any custom keymaps or post-setup logic here if needed
  end,
}
