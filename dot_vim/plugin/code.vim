if !exists("g:codeSessionsFile")
    finish
endif

let g:codeCurrentRelativePath = ""
let g:codeAutocommandsEnabled = 1

let g:codeExplorerChannel = ch_open("unix:"..g:codeExplorerServerSocket)
call ch_sendraw(g:codeExplorerChannel, "init "..g:codeExplorerWidth.. " "..g:codeExplorerHeight.."\n")
call ch_sendraw(g:codeExplorerChannel, "previewWithPath .\n")

let g:codeMinimapChannel = ch_open("unix:"..g:codeMinimapServerSocket)
let g:codeMinimapRangeFrom = 0
let g:codeMinimapRangeTo = 0
call ch_sendraw(g:codeMinimapChannel, "init "..g:codeMinimapWidth.." "..g:codeMinimapHeight.."\n")

function! CodeOnFileOpened(newPath, reload)
    if !g:codeAutocommandsEnabled
        return
    endif
    if empty(a:newPath)
        return
    endif
    let l:relativePath = fnamemodify(a:newPath, ":.") 
    if l:relativePath[0] == "/" || !filereadable(l:relativePath) || (!a:reload && l:relativePath == g:codeCurrentRelativePath)
        return
    endif
    call ch_sendraw(g:codeExplorerChannel, "previewWithPath "..l:relativePath.."\n")
    let g:codeMinimapRangeFrom = getpos("w0")[1]
    let g:codeMinimapRangeTo = getpos("w$")[1]
    call ch_sendraw(g:codeMinimapChannel, "setPath "..l:relativePath.." "..g:codeMinimapRangeFrom.." "..g:codeMinimapRangeTo .."\n")
    let g:codeCurrentRelativePath = l:relativePath
endfunction

function! CodeOnAnyWindowScrolled()
    if !g:codeAutocommandsEnabled
        return
    endif
    if fnamemodify(expand("%"), ":.") != g:codeCurrentRelativePath
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
    call CodeOnFileOpened(expand("%"), 0)
    call CodeOnAnyWindowScrolled()
endfunction

if exists("g:codeSessionsFile")
    function! CodeCloseWithNext(nextSessionPath)
        if !g:codeAutocommandsEnabled
            return
        endif
        call system($HOME.."/.sh/WriteLeastRecentlyUsed "..g:codeSessionsFile.." "..a:nextSessionPath)
        let l:vimSessionsDir = fnamemodify(g:codeSessionsFile, ":p:h").."/vim-sessions"
        call mkdir(l:vimSessionsDir, "p")
        exe "mksession! "..l:vimSessionsDir.."/"..fnamemodify(getcwd(), ":gs#/#ESCAPED_SLASH#")..".vim"
    endfunction

    autocmd VimLeave * call CodeCloseWithNext(g:codeCurrentSession)
endif

autocmd WinScrolled * call CodeOnAnyWindowScrolled()
autocmd BufWritePost * call CodeOnFileOpened(expand("%"), 1)
autocmd BufEnter * call CodeOnFileRefresh()
