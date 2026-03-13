return {
  {
    "SensorEvolve/macrovault.nvim",
    dir = vim.fn.expand("~/Developer/macrovault.nvim"),
    lazy = false,
    config = function()
      require("macrovault").setup({
        macros = {
          [1] = "!pandoc % --pdf-engine=xelatex -o %:r.pdf",
          [2] = "%s/^w/U&/",
          [3] = "g/^s*$/d",
          [4] = "%s//g",
          [5] = "%s/<foo>//gc",
          [6] = "%s/\\([^;]\\)$/\\1;/",
          [7] = "%!column -t -s ','",
          [8] = "%s/^\\(.*\\)\\(\\n\\1\\)\\+$/\\1/",
          [9] = "g/^$/d",
          [10] = 'echo "Hello from MacroVault!"',
          [100] = "echo 'Hello from MacroVault slot 100!'",
        },
      })
    end,
  },
}
