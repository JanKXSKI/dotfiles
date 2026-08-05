" modes
inoremap vv <Esc>
tnoremap vv <C-W>N
nnoremap <Enter> i
map <Leader>v <C-V>

" window
nnoremap <C-H> <C-W>h
nnoremap <C-S-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-S-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-S-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-S-L> <C-W>l

nnoremap <Leader>h <C-W>H
nnoremap <Leader>j <C-W>J
nnoremap <Leader>k <C-W>K
nnoremap <Leader>l <C-W>L

" opening
nnoremap gf :wincmd F <CR>
nnoremap <Leader><Backspace> :b # <CR>

" yanking
nnoremap <Leader>d :let @d=expand('%:p').':'.line('.')<CR>:let @j='com.'.substitute(split(expand('%:r'), '/com/')[-1].':'.line('.'), '/', '.', 'g')<CR>
