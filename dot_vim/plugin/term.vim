function! AddOrFocusTerminal()
    wincmd b
    if &buftype == "terminal"
        return
    endif
    if bufname() == ''
        bd
    endif
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"&buftype\") == \"terminal\"")
    hi normal ctermfg=lightgrey ctermbg=black guifg=lightgrey guibg=black
    if !empty(l:terminals)
        execute "sb" l:terminals[0].bufnr
    else
        term
    endif
    hi normal ctermfg=223 ctermbg=236 guifg=#ebdbb2 guibg=#32302f
    wincmd J
endfunction

function! HideTerminalAndReplaceWindowWithBuffer()
    if &buftype != "terminal"
        echom "Tried to yank terminal buffer, but not in a terminal."
        return
    endif
    silent % yank
    hide ene
    silent normal! VpG
    setlocal nomodified
endfunction

function! TerminalSensitiveWindowMove(dirKey)
    execute "wincmd" a:dirKey
endfunction
