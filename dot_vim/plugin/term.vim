function! AddOrFocusTerminal()
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"&buftype\") == \"terminal\"")
    if !empty(filter(copy(l:terminals), "!v:val.hidden"))
        return
    endif
    if bufname() == ''
        bd
    endif
    if !empty(l:terminals)
        execute "sb" l:terminals[0].bufnr
    else
        term
    endif
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

function! HideTerminal()
    if len(getbufinfo()) == 1
        hide ene
        return
    endif
    let l:termbufnr = bufnr()
    let g:codeAutocommandsEnabled=0
    if winnr("$") == 1
        vertical ball
    else
        wincmd p
    endif
    let g:codeAutocommandsEnabled=1
    exe bufwinnr(l:termbufnr).."hide"
endfunction

function! TerminalSensitiveWindowMove(dirKey)
    execute "wincmd" a:dirKey
endfunction
