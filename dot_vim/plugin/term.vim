function! ReplaceOrAddTerminal()
    if &buftype == "terminal"
        term ++curwin ++noclose
    else
        term ++rows=20 ++noclose
    endif
endfunction

