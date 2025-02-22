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

        function! SendSelectionToTmuxBackground()
        " Determine the active tmux session, window, and target pane
        let l:session = substitute(system('tmux display-message -p "#{session_name}"'), '\n', '', 'g')
        let l:window = substitute(system('tmux display-message -p "#{window_index}"'), '\n', '', 'g')
        let l:target_pane = l:session . ":" . l:window . ".2" " Send to pane 2 in active window

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
        let l:text = getreg('"')

        " Restore the register
        call setreg('"', l:save_reg, l:save_regtype)

        " Generate a filename based on current date and time
        let l:datetime = strftime("%Y%m%d_%H%M%S")
        let l:filename = l:datetime . ".sql"

        " Create the command text
        let l:command = "echo \"\n" . l:text . "\n\" > " . l:filename . " && mybeeline " . l:filename . " & \n"

        " Send the command to tmux pane
        call system('tmux send-keys -t ' . l:target_pane . ' ' . shellescape(l:command))
        endfunction

        function! SendSelectionToTmuxBackground3()
        " Determine the active tmux session, window, and target pane
        let l:session = substitute(system('tmux display-message -p "#{session_name}"'), '\n', '', 'g')
        let l:window = substitute(system('tmux display-message -p "#{window_index}"'), '\n', '', 'g')
        let l:target_pane = l:session . ":" . l:window . ".2" " Send to pane 2 in active window

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
        let l:text = getreg('"')

        " Restore the register
        call setreg('"', l:save_reg, l:save_regtype)

        " Generate a filename based on current date and time
        let l:datetime = strftime("%Y%m%d_%H%M%S")
        let l:filename = l:datetime . ".sql"

        " Create the command text
        let l:command = "echo \"\n" . l:text . "\n\" > " . l:filename . " \n"

        " Send the command to tmux pane
        call system('tmux send-keys -t ' . l:target_pane . ' ' . shellescape(l:command))
        endfunction
        ]])
        -- Key mappings for vimux
        vim.api.nvim_set_keymap("n", "<leader>vp", ":VimuxPromptCommand<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>vl", ":VimuxRunLastCommand<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
            "v",
            "<leader>1",
            ":<C-U>call SendSelectionToTmux()<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "v",
            "<leader>2",
            ":<C-U>call SendSelectionToTmuxBackground()<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "v",
            "<leader>3",
            ":<C-U>call SendSelectionToTmuxBackground3()<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap("n", "<leader>vi", ":VimuxInspectRunner<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>vq", ":VimuxCloseRunner<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>vx", ":VimuxInterruptRunner<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>vz", ":VimuxZoomRunner<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
            "n",
            "<leader>v<C-l>",
            ":VimuxClearTerminalScreen<CR>",
            { noremap = true, silent = true }
        )
    end,
}
