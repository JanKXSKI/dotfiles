vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

require('fff').setup({
    keymaps = {
        move_up = { '<Up>', '<C-k>' },
        move_down = { '<Down>', '<C-j>' },
        grep_jump_to_next_file = { '<C-n>' },
        grep_jump_to_prev_file = { '<C-p>' }
    }
})
