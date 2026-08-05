nnoremap <Leader>o :lua require("fzf-lua").git_files() <CR>
nnoremap <Leader>i :lua require("fzf-lua").files() <CR>
nnoremap <Leader>s :vsplit <bar> :lua require("fzf-lua").git_files() <CR>
nnoremap <Leader>g :lua require("fzf-lua").grep_cword() <CR>
