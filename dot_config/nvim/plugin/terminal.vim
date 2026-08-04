autocmd TermOpen * startinsert
nnoremap <Leader>p :split ene <BAR> :call TerminalAtDirectory(expand("#:p:h")) <CR>
nnoremap <Leader>; :call ToggleTerminal() <CR>
inoremap <Leader>; <Esc> :call ToggleTerminal() <CR>
tnoremap <Leader>; <C-\><C-N>: call ToggleTerminal() <CR>
tnoremap vv <C-\><C-N>
