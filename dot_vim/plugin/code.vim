if !exists("g:codeSessionsFile")
    finish
endif

let g:codeExplorerChannel = ch_open("unix:"..g:codeExplorerServerSocket)
call ch_sendraw(g:codeExplorerChannel, "init "..g:codeExplorerWidth.. " "..g:codeExplorerHeight.."\n")

let g:codeMinimapChannel = ch_open("unix:"..g:codeMinimapServerSocket)
let g:codeMinimapRangeFrom = 0
let g:codeMinimapRangeTo = 0
let g:codeMinimapCurrentRelativePath = ""
call ch_sendraw(g:codeMinimapChannel, "init "..g:codeMinimapWidth.." "..g:codeMinimapHeight.."\n")

function! CodeOnFileOpened(newPath)
    if empty(a:newPath)
        return
    endif
    let l:relativePath = fnamemodify(a:newPath, ":.") 
    if l:relativePath[0] == "/" || !filereadable(l:relativePath)
        return
    endif
    call ch_sendraw(g:codeExplorerChannel, "previewWithPath "..l:relativePath.."\n")
    call ch_sendraw(g:codeMinimapChannel, "setPath "..l:relativePath.."\n")
    let g:codeMinimapRangeFrom = 0
    let g:codeMinimapRangeTo = 0
    let g:codeMinimapCurrentRelativePath = l:relativePath
endfunction

function! CodeOnAnyWindowScrolled()
    if fnamemodify(expand("%"), ":.") != g:codeMinimapCurrentRelativePath
        return
    endif
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
    call CodeOnAnyWindowScrolled()
endfunction

autocmd WinScrolled * call CodeOnAnyWindowScrolled()
autocmd BufWritePost * call CodeOnFileRefresh()
autocmd BufEnter * call CodeOnFileRefresh()
