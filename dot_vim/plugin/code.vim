if !exists("g:codeFileServerFifo")
    finish
endif

let g:codeFileServerRequest = $HOME.."/.sh/Request "..g:codeFileServerFifo

let g:codeMinimapChannel = ch_open("unix:"..g:codeMinimapServerSocket)
let g:codeMinimapRangeFrom = 0
let g:codeMinimapRangeTo = 0
call ch_sendraw(g:codeMinimapChannel, "init "..g:codeMinimapWidth.." "..g:codeMinimapHeight.."\n")

function! CodeOnFileOpened(newPath)
    if empty(a:newPath)
        return
    endif
    call system(g:codeFileServerRequest.." setPath "..shellescape(a:newPath))
    call system(g:codeFileServerRequest.." previewToStdout")
    call ch_sendraw(g:codeMinimapChannel, "setPath "..a:newPath.."\n")
    let g:codeMinimapRangeFrom = 0
    let g:codeMinimapRangeTo = 0
endfunction

function! CodeOnCursorMoved()
    let l:from = getpos("w0")[1]
    let l:to = getpos("w$")[1]
    if g:codeMinimapRangeFrom == l:from && g:codeMinimapRangeTo == l:to
        return
    endif
    let g:codeMinimapRangeFrom = l:from
    let g:codeMinimapRangeTo = l:to
    call ch_sendraw(g:codeMinimapChannel, "previewWithRange "..l:from.." "..l:to.."\n")
endfunction

function! CodeOnFileRefresh()
    call CodeOnFileOpened(expand("%"))
    call CodeOnCursorMoved()
endfunction

autocmd CursorMoved * call CodeOnCursorMoved()
autocmd BufWritePost * call CodeOnFileRefresh()
autocmd BufEnter * call CodeOnFileRefresh()
