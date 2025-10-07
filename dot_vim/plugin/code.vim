if !exists("g:codeFileServerFifo")
    finish
endif

let g:codeFileServerRequest = $HOME.."/.sh/Request "..g:codeFileServerFifo
let g:codeMinimapServerRequest = $HOME.."/.sh/Request "..g:codeMinimapServerFifo

function! CodeOnFileOpened(newPath)
    if empty(a:newPath)
        return
    endif
    let l:path = shellescape(a:newPath)
    call system(g:codeFileServerRequest.." setPath "..l:path)
    call system(g:codeFileServerRequest.." previewToStdout")
    call system(g:codeMinimapServerRequest.." setPath "..l:path)
    call system(g:codeMinimapServerRequest.." previewToStdout")
endfunction

autocmd SessionLoadPost * call CodeOnFileOpened(expand("%"))
