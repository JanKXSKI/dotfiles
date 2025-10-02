let s:source = "'find . \"(\" -type f -or -type l \")\" -and ! -name *.swp | sed s#^\\./##'"
let s:preview = "'~/.sh/lspath {} $FZF_PREVIEW_COLUMNS'"
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

let g:opGrepServer = job_start("~/.sh/OpGrepServer")
function! OpenFileFromOpGrepList()
    let l:fileAndLineNumber = split(ch_evalraw(g:opGrepServer, "getSelectedFileAndLineNumber\n"), ":")
    exe ":e +"..l:fileAndLineNumber[1].." "..l:fileAndLineNumber[0]
endfunction
let s:opGrepClient = "~/.sh/OpGrepClient "..job_info(g:opGrepServer).process
let s:source = "'ag -cU <args>'"
let s:preview = "'tail -f ~/.sh/OpGrepPreviewFile'"
let s:bindInit = "'--bind', 'focus:execute-silent(''"..s:opGrepClient.." init {1} $FZF_PREVIEW_LINES <args>'')'"
let s:bindNext = "'--bind', 'ctrl-n:execute-silent(''"..s:opGrepClient.." next'')'"
let s:options = "['-d', ':', '--nth', '1', '--preview', "..s:preview..", "..s:bindInit..", "..s:bindNext.."]"
exe "command -nargs=+ OpGrep call fzf#run({'source': " s:source ", 'options':" s:options ", 'sink': function('OpenFileFromOpGrepList')})"
