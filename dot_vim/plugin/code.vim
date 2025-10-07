if !exists("g:codeFileServerFifo")
    finish
endif

let g:codeFileServerRequest = $HOME.."/.sh/Request "..g:codeFileServerFifo

let g:codeMinimapChannel = ch_open("unix:"..g:codeMinimapServerSocket)
call ch_sendraw(g:codeMinimapChannel, "init "..g:codeMinimapWidth.." "..g:codeMinimapHeight.."\n")

function! CodeOnFileOpened(newPath)
    if empty(a:newPath)
        return
    endif
    let l:path = shellescape(a:newPath)
    call system(g:codeFileServerRequest.." setPath "..l:path)
    call system(g:codeFileServerRequest.." previewToStdout")
    call ch_sendraw(g:codeMinimapChannel, "setPath "..l:path.."\n")
endfunction

autocmd SessionLoadPost * call CodeOnFileOpened(expand("%"))
