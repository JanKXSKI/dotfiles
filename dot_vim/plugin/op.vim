let s:bindPreviewUpDown = "'--bind', 'ctrl-u:preview-half-page-up', '--bind', 'ctrl-d:preview-half-page-down'"
let s:bindClearQuery = "'--bind', 'ctrl-l:clear-query'"
let s:defaultBinds = s:bindPreviewUpDown..", "..s:bindClearQuery

let s:source = "'find . -path ./.git -prune -or \"(\" -type f -or -type l \")\" -and ! -name *.swp -print | sed s#^\\./##'"
let s:preview = "'bat -n --color=always {}'"
let s:options = "['--preview', "..s:preview..", "..s:defaultBinds.."]"
exe "command OpFile call fzf#run(fzf#wrap({'source': " s:source ",'options':" s:options ", 'sink': 'edit'}))"

let s:source = "'git log --format=''%h %an %ar: %s'' -- '..expand('%')"
let s:previewGit = "'echo {} | awk ''{print $1}'' | xargs -I{} git show {}:'..expand('%')"
let s:preview = s:previewGit.."..' | bat -n --color=always -l='..split(expand('%:t'), '\\.')[-1]"
let s:previewWindow = "'+'..line('w0')"
let s:options = "['--preview', "..s:preview..", '--preview-window', "..s:previewWindow..", "..s:defaultBinds.."]"
exe "command OpGitLog call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options "}))"

if exists("g:codeOpGrepServerSocket")
    function! OpGrepSink(selected)
        let l:ch = ch_open("unix:"..g:codeOpGrepServerSocket)
        let l:num = ch_evalraw(l:ch, "get\n")
        call ch_close(l:ch)
        let l:file = split(a:selected, ":")[0]
        exe "edit +"..l:num.." "..l:file
    endfunction
    let s:source = "'ag -cU <args>'"
    let s:preview = "'bat -n --color=always $("..$HOME.."/.sh/RequestEval "..g:codeOpGrepServerSocket.." preview {1} $FZF_PREVIEW_LINES <args>) {1}'"
    let s:bindNext = "'--bind', 'ctrl-n:refresh-preview'"
    let s:options = "['-d', ':', '--nth', '1', '--preview', "..s:preview..", "..s:bindNext..", "..s:bindClearQuery.."]"
    exe "command -nargs=+ OpGrep call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options ", 'sink': function('OpGrepSink')}))"
endif

function OpGrepWithWordUnderCursor()
    call feedkeys(":OpGrep "..expand("<cword>"))
endfunction

if exists("g:codeSessionsFile")
    function! OpenCodeSession(selected)
        try
            sbm
            wincmd J
            echoe "Cannot leave here, buffer has changes."
        catch /No modified buffer/
            call CodeCloseWithNext(a:selected)
            let g:codeAutocommandsEnabled = 0
            qa
        endtry
    endfunction
    let s:source = "'cat "..g:codeSessionsFile.."'"
    let s:options = "["..s:bindClearQuery.."]"
    exe "command OpSession call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options ", 'sink': function('OpenCodeSession')}))"
endif
