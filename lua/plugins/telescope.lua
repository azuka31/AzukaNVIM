return {
  "nvim-telescope/telescope.nvim",
  requires = { { "nvim-lua/plenary.nvim" } },
  config = function()
    require("telescope").setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--glob",
          "!*.csv", -- Exclude CSV files
          "--glob",
          "!*.txt", -- Exclude TXT files
          "--glob",
          "!*.ipynb", -- Exclude IPYNB files
        },
      },
      pickers = {
        live_grep = {
          additional_args = function(opts)
            return {
              "--glob",
              "!*.csv", -- Exclude CSV files
              "--glob",
              "!*.txt", -- Exclude TXT files
            }
          end,
        },
      },
    })
  end,
}
