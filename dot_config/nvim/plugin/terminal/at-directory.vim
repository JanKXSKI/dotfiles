function! OnExitBdelete(id, type, event)
    bdelete
endfunction

function! TerminalAtDirectory(directory)
    call jobstart(&shell, #{
                \ term:v:true,
                \ cwd:a:directory,
                \ on_exit:"OnExitBdelete"
                \ })
endfunction
