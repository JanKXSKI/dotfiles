let s:source = "'find . -path ./.git -prune -or \"(\" -type f -or -type l \")\" -and ! -name *.swp -print | sed s#^\\./##'"
let s:preview = "'bat -n'"
let s:bindClearQuery = "'--bind', 'ctrl-l:clear-query'"
let s:options = "['--preview', "..s:preview..", "..s:bindClearQuery.."]"
exe "command OpFile call fzf#run(fzf#wrap({'source': " s:source ",'options':" s:options ", 'sink': 'edit'}))"

let s:source = "'git log --format=''%h %an %ar: %s'' -- '..expand('%')"
let s:previewGit = "'echo {} | awk ''{print $1}'' | xargs -I{} git show {}:'..expand('%')"
let s:preview = s:previewGit.."..' | bat -n --color=always -l='..split(expand('%:t'), '\\.')[-1]"
let s:previewWindow = "'+'..line('w0')"
let s:bindPreviewUpDown = "'--bind', 'ctrl-u:preview-half-page-up', '--bind', 'ctrl-d:preview-half-page-down'"
let s:options = "['--preview', "..s:preview..", '--preview-window', "..s:previewWindow..", "..s:bindPreviewUpDown.."]"
exe "command OpGitLog call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options "}))"

let s:opGrepFile = $HOME.."/.sh/run/"..getpid()..".vim.grep.file"
let s:opGrepSocket = $HOME.."/.sh/run/"..getpid()..".vim.grep.socket"
let g:opGrepServer = job_start([$HOME.."/.sh/OpGrepPreviewServer", s:opGrepFile, s:opGrepSocket])
let s:opGrepRequest = $HOME.."/.sh/RequestSend "..s:opGrepSocket
function! OpGrepSink(selected)
    let l:num = ch_evalraw(ch_open("unix:"..s:opGrepSocket), "get\n")
    let l:file = split(a:selected, ":")[0]
    exe "edit +"..l:num.." "..l:file
endfunction
let s:source = "'ag -cU <args>'"
let s:preview = "'tail -f "..s:opGrepFile.."'"
let s:bindInit = "'--bind', 'focus:execute-silent:"..s:opGrepRequest.." init {1} $FZF_PREVIEW_LINES <q-args>'"
let s:bindNext = "'--bind', 'ctrl-n:execute-silent("..s:opGrepRequest.." next)+refresh-preview'"
let s:options = "['-d', ':', '--nth', '1', '--preview', "..s:preview..", "..s:bindInit..", "..s:bindNext.."]"
exe "command -nargs=+ OpGrep call writefile([], '"..s:opGrepFile.."') | call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options ", 'sink': function('OpGrepSink')}))"

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
            call system("~/.sh/WriteLeastRecentlyUsed "..g:codeSessionsFile.." "..a:selected)
            let l:vimSessionsDir = fnamemodify(g:codeSessionsFile, ":p:h").."/vim-sessions"
            call mkdir(l:vimSessionsDir, "p")
            exe "mksession! "..l:vimSessionsDir.."/"..fnamemodify(getcwd(), ":gs#/#ESCAPED_SLASH#")..".vim"
            qa
        endtry
    endfunction
    let s:source = "'cat "..g:codeSessionsFile.."'"
    exe "command OpSession call fzf#run(fzf#wrap({'source': " s:source ", 'sink': function('OpenCodeSession')}))"
endif
