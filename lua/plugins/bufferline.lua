return {
    "akinsho/bufferline.nvim",
    version = "*", -- or a specific tag like "v4.*"
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- show buffers (not tabs)
                separator_style = "slant",
                diagnostics = "nvim_lsp", -- show LSP diagnostics on buffers
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
        })
    end,
}
