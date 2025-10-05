if !exists("g:codeFileServerFifo")
    finish
endif

let g:codeFileRequest = $HOME.."/.sh/Request "..g:codeFileServerFifo

function! CodeFileServerRefresh(newPath)
    call system(g:codeFileRequest.." setPath "..shellescape(a:newPath))
    call system(g:codeFileRequest.." previewToStdout")
endfunction

autocmd BufWritePost,BufEnter * call CodeFileServerRefresh(expand("%"))
