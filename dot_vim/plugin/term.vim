function! ToggleCodeTerminal()
    if exists("b:codeBufferType") && b:codeBufferType == "terminal"
        call HideTerminal()
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

function! TerminalAwareEasymotionAction(easymotionBinding)
    if &buftype != "terminal"
        return "\<Plug>(easymotion-"..a:easymotionBinding..")"
    endif
    return ':call TerminalNormalModeAwareMotion("call feedkeys(''\<Plug>(easymotion-'..a:easymotionBinding..')'', ''x!'')")'.." \<CR>"
endfunction

function! TerminalAwareGotoWord()
    if &buftype != "terminal"
        return ":GotoWord \<CR>"
    endif
    return ':call TerminalNormalModeAwareMotion("GotoWord")'.." \<CR>"
endfunction

function! TerminalNormalModeAwareMotion(commandToExecute)
    let l:termbufnr = bufnr()
    let l:termline = getpos("w0")[1]
    silent % yank
    hide ene
    silent normal! VpG
    setlocal nolist nonumber nomodified
    execute l:termline.."normal! zt"
    let &g:undolevels = &g:undolevels
    execute a:commandToExecute
    let l:tempbufnr = bufnr()
    let l:temppos = getcurpos()
    execute "hide buffer "..l:termbufnr
    execute "bdelete! "..l:tempbufnr
    execute l:termline.."normal! zt"
    call setpos(".", l:temppos)
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

autocmd TerminalWinOpen * setlocal nonumber nolist
