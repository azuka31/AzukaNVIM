return {
  -- other plugins
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- Optional: Customize plugin options
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 1
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_preview_options = {
        hide_yaml_meta = 1,
        disable_filename = 0,
        syntax = "on",
      }
    end,
    ft = { "markdown" }, -- Load only for markdown files
  },
}
