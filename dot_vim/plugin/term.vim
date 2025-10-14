function! AddOrFocusTerminal()
    let l:terminals = filter(getbufinfo(), "fnamemodify(v:val.name, \":t\")  == \"@codeTerm\"")
    if !empty(l:terminals)
        if l:terminals[0].hidden
            execute "sb" l:terminals[0].bufnr
        else
            execute l:terminals[0].bufnr.."wincmd w"
        endif
    else
        term
        keepalt file @codeTerm
    endif
    wincmd J
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
