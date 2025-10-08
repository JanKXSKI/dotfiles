let g:opFileServer = job_start([$HOME.."/.sh/OpFileServer"])
let g:opFileRequest = $HOME.."/.sh/Request "..ch_readraw(g:opFileServer)
let s:source = "'find . -path ./.git -prune -or \"(\" -type f -or -type l \")\" -and ! -name *.swp -print | sed s#^\\./##'"
let s:preview = "'"..g:opFileRequest.." preview'"
let s:bindFocus = "'--bind', 'focus:execute-silent("..g:opFileRequest.." init {} $FZF_PREVIEW_COLUMNS $FZF_PREVIEW_LINES)+refresh-preview'"
let s:bindClearQuery = "'--bind', 'ctrl-l:clear-query'"
let s:options = "['--preview', "..s:preview..", "..s:bindFocus..", "..s:bindClearQuery.."]"
exe "command OpFile call fzf#run(fzf#wrap({'source': " s:source ",'options':" s:options ", 'sink': 'edit'}))"

let s:source = "'git log --format=''%h %an %ar: %s'' -- '..expand('%')"
let s:previewGit = "'echo {} | awk ''{print $1}'' | xargs -I{} git show {}:'..expand('%')"
let s:preview = s:previewGit.."..' | bat -n --color=always -l='..split(expand('%:t'), '\\.')[-1]"
let s:previewWindow = "'+'..line('w0')"
let s:bindPreviewUpDown = "'--bind', 'ctrl-u:preview-half-page-up', '--bind', 'ctrl-d:preview-half-page-down'"
let s:options = "['--preview', "..s:preview..", '--preview-window', "..s:previewWindow..", "..s:bindPreviewUpDown.."]"
exe "command OpGitLog call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options "}))"

let g:opGrepServer = job_start([$HOME.."/.sh/OpGrepServer"])
let g:opGrepRequest = $HOME.."/.sh/Request "..ch_readraw(g:opGrepServer)
function! OpGrepSink(selected)
    let l:num = system(g:opGrepRequest.." getSelectedLineNumber")
    let l:file = split(a:selected, ":")[0]
    exe "edit +"..l:num.." "..l:file
endfunction
let s:source = "'ag -cU <args>'"
let s:preview = "'"..g:opGrepRequest.." preview'"
let s:bindInit = "'--bind', 'focus:execute-silent("..g:opGrepRequest.." init {1} $FZF_PREVIEW_LINES <args>)+refresh-preview'"
let s:bindNext = "'--bind', 'ctrl-n:execute-silent("..g:opGrepRequest.." next)+refresh-preview'"
let s:options = "['-d', ':', '--nth', '1', '--preview', "..s:preview..", "..s:bindInit..", "..s:bindNext.."]"
exe "command -nargs=+ OpGrep call fzf#run(fzf#wrap({'source': " s:source ", 'options':" s:options ", 'sink': function('OpGrepSink')}))"

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
