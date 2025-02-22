return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim", -- Ensure the colorscheme is installed
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = true, -- Catppuccin-specific transparency setting
      })
      vim.cmd.colorscheme("catppuccin") -- Apply the colorscheme
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function()
      -- Ensure transparency for Neo-tree areas
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
    end,
  },
  {
    -- Set transparency globally for other areas
    "nvim-lua/plenary.nvim",
    config = function()
      local highlight_groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "EndOfBuffer",
        "MsgArea",
        "NvimTreeNormal", -- If you use NvimTree
        "StatusLine",
        "StatusLineNC",
        "CursorLine",
        "CursorLineNR",
        "TelescopeNormal", -- For Telescope if needed
      }
      for _, group in ipairs(highlight_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end,
  },
}
