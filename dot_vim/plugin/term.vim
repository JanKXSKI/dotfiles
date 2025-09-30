function! AddOrFocusTerminal()
    wincmd b
    if &buftype == "terminal"
        return
    endif
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"&buftype\") == \"terminal\"")
    if !empty(l:terminals)
        execute "sb" l:terminals[0].bufnr
    else
        term
    endif
    wincmd J
    resize 20
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
