nnoremap <Leader>o :lua require("fzf-lua").files() <CR>
nnoremap <Leader>s :vsplit <bar> :lua require("fzf-lua").files() <CR>
nnoremap <Leader>g :lua require("fzf-lua").grep_cword() <CR>
