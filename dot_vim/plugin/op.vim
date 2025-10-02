let s:source = "'find . ! -readable -prune -or \"(\" -type f -or -type l \")\" -and ! -name *.swp | sed s#^\\./##'"
let s:preview = "'"..$HOME.."/.sh/lspath {} $FZF_PREVIEW_COLUMNS'"
let s:bindPreviewUpDown = "'--bind', 'ctrl-u:preview-half-page-up', '--bind', 'ctrl-d:preview-half-page-down'"
let s:bindClearQuery = "'--bind', 'ctrl-l:clear-query'"
let s:options = "['--preview', "..s:preview..", "..s:bindPreviewUpDown..", "..s:bindClearQuery.."]"
exe "command OpFile call fzf#run({'source': " s:source ",'options':" s:options ", 'sink': 'e'})"

let s:source = "'git log --format=''%h %an %ar: %s'' -- '..expand('%')"
let s:previewGit = "'echo {} | awk ''{print $1}'' | xargs -I{} git show {}:'..expand('%')"
let s:preview = s:previewGit.."..' | bat -n --color=always -l='..split(expand('%:t'), '\\.')[-1]"
let s:previewWindow = "'+'..line('w0')"
let s:options = "['--preview', "..s:preview..", '--preview-window', "..s:previewWindow..", "..s:bindPreviewUpDown.."]"
exe "command OpGitLog call fzf#run({'source': " s:source ", 'options':" s:options "})"

let g:opGrepServer = job_start([$HOME.."/.sh/OpGrepServer"])
let g:opGrepFifo = ch_readraw(g:opGrepServer)
let g:opGrepClient = job_start([$HOME.."/.sh/Client", g:opGrepFifo])
let g:opGrepRequest = $HOME.."/.sh/Request "..g:opGrepFifo
function! OpenFileFromOpGrepList(selected)
    let l:num = ch_evalraw(g:opGrepClient, "getSelectedLineNumber\n")
    let l:file = split(a:selected, ":")[0]
    exe ":e +"..l:num.." "..l:file
endfunction
let s:source = "'ag -cU <args>'"
let s:preview = "'"..g:opGrepRequest.." preview'"
let s:bindInit = "'--bind', 'focus:execute-silent("..g:opGrepRequest.." init {1} $FZF_PREVIEW_LINES <args>)+refresh-preview'"
let s:bindNext = "'--bind', 'ctrl-n:execute-silent("..g:opGrepRequest.." next)+refresh-preview'"
let s:options = "['-d', ':', '--nth', '1', '--preview', "..s:preview..", "..s:bindInit..", "..s:bindNext.."]"
exe "command -nargs=+ OpGrep call fzf#run({'source': " s:source ", 'options':" s:options ", 'sink': function('OpenFileFromOpGrepList')})"

function OpGrepWithWordUnderCursor()
    call feedkeys(":OpGrep "..expand("<cword>"))
endfunction
