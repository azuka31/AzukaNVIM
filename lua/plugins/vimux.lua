return {
  "benmills/vimux",
  config = function()
    -- Custom function to send selected text to tmux pane
    vim.cmd([[ 
        function! SendSelectionToTmux()
          " Save the current register and clipboard values
          let l:save_reg = getreg('"')
          let l:save_regtype = getregtype('"')
          let l:save_clipboard = &clipboard

          " Set clipboard to unnamed to yank to system clipboard
          set clipboard=unnamed

          " Yank the visually selected text
          normal! gv"vy

          " Restore clipboard
          let &clipboard = l:save_clipboard

          " Get the yanked text
          let l:command = getreg('"')

          " Restore the register
          call setreg('"', l:save_reg, l:save_regtype)

          " Send the yanked text to tmux pane
          call VimuxRunCommand(l:command)
        endfunction
      ]])
    -- Key mappings for vimux
    vim.api.nvim_set_keymap("n", "<leader>vp", ":VimuxPromptCommand<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vl", ":VimuxRunLastCommand<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<leader>1", ":<C-U>call SendSelectionToTmux()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vi", ":VimuxInspectRunner<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vq", ":VimuxCloseRunner<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vx", ":VimuxInterruptRunner<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vz", ":VimuxZoomRunner<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>v<C-l>", ":VimuxClearTerminalScreen<CR>", { noremap = true, silent = true })
  end,
}
