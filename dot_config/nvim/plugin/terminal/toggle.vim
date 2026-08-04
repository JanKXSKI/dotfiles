function! ToggleTerminal()
    if exists("b:ToggleTerminal")
        call HideTerminal()
        return
    endif
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"ToggleTerminal\")")
    if !empty(l:terminals)
        if l:terminals[0].hidden
            execute "sb" l:terminals[0].bufnr
        else
            execute bufwinnr(l:terminals[0].bufnr).."wincmd w"
        endif
        if mode() == "n"
            normal! i
        endif
    else
        horizontal terminal
        let b:ToggleTerminal = v:true
    endif
    wincmd J
endfunction

function! HideTerminal()
    if len(getbufinfo({'buflisted': 1})) == 1
        hide ene
        return
    endif
    let l:termbufnr = bufnr()
    if winnr("$") == 1
        vertical ball
    else
        wincmd p
    endif
    exe bufwinnr(l:termbufnr).."hide"
endfunction
