-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

-- general keymap
keymap.set("i", "jk", "<ESC>") -- Changing insert to normal mode using jk
keymap.set("v", "jk", "<ESC>") -- Changing insert to normal mode using jk
keymap.set("n", "<leader>nh", ":nohl<CR>") --  nohighltihg
keymap.set("n", "x", '"_x') -- Changing insert to normal mode using jk

keymap.set("n", "+", "<C-a>", opts) -- increment
keymap.set("n", "-", "<C-x>") -- decrement

-- Splitting Windows
keymap.set("n", "<leader>sv", "<C-w>v", opts) -- Vertical
keymap.set("n", "<leader>sh", "<C-w>s", opts) -- Horizontal
keymap.set("n", "<leader>se", "<C-w>=", opts) -- increment
keymap.set("n", "<leader>sx", ":close<CR>", opts) -- increment

-- Setting go to next tab
keymap.set("n", "te", "tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- vim to system clipboard
keymap.set("n", "<leader>yy", [[:%y+<CR>]], opts) -- increment

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- increment
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- increment
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- increment
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- increment
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- increment

-- Diagnostic
keymap.set("n", "<C-j>", function()
    vim.diagnostic.goto_next()
end)

vim.g.tmux_navigator_no_mappings = 1

-- Map CTRL + H, J, K, L for window navigation in Neovim using Lua
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Custom keybindings for tmux navigation
vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", opts)
