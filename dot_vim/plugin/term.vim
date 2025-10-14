function! ToggleCodeTerminal()
    if exists("b:codeBufferType") && b:codeBufferType == "terminal"
        call HideTerminal()
        return
    endif
    if (TrySwitchBackToTerminalFromTerminalMadeModifiable())
        return
    endif
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"codeBufferType\") == \"terminal\"")
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
        term
        let b:codeBufferType = "terminal"
    endif
    wincmd J
endfunction

function! TerminalNormalModeModifiableForEasymotion()
    if &buftype != "terminal"
        return
    endif
    let l:bufnr = bufnr()
    silent % yank
    hide ene
    silent normal! VpG
    setlocal nomodified
    setlocal nonumber
    setlocal nolist
    normal! z-
    let b:codeBufferHidingTerminalWithBufnr = l:bufnr
endfunction

function! TrySwitchBackToTerminalFromTerminalMadeModifiable()
    if exists("b:codeBufferHidingTerminalWithBufnr")
        let l:bufnr = bufnr()
        execute "hide buffer "..b:codeBufferHidingTerminalWithBufnr
        execute "bdelete! "..l:bufnr
        return 1
    endif
    return 0
endfunction

function! SwitchBackToTerminalOrInsertMode()
    if TrySwitchBackToTerminalFromTerminalMadeModifiable()
        return
    endif
    call feedkeys("i", "n")
endfunction

function! HideTerminal()
    if len(getbufinfo({'buflisted': 1})) == 1
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
