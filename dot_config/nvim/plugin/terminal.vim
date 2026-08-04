autocmd TermOpen * startinsert
nnoremap <Leader>p :split ene <BAR> :call TerminalAtDirectory(expand("#:p:h")) <CR>
