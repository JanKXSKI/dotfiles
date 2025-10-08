function! AddOrFocusTerminal()
    wincmd b
    if &buftype == "terminal"
        return
    endif
    if bufname() == ''
        bd
    endif
    let l:terminals = filter(getbufinfo(), "getbufvar(v:val.bufnr, \"&buftype\") == \"terminal\"")
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

function! TerminalSensitiveWindowMove(dirKey)
    execute "wincmd" a:dirKey
endfunction

function! TerminalToggleStatusLine()
    if &buftype == "terminal"
        set laststatus=0
    else
        set laststatus=2
    endif
endfunction

autocmd TerminalOpen * call TerminalToggleStatusLine()
autocmd WinEnter * call TerminalToggleStatusLine()
