let s:source = 'git log --format="%h %an %ar: %s" -- '.expand('%:p')
let s:previewGit = 'echo {} | awk ''{print $1}'' | xargs -I{} git show {}:'.expand('%')
let s:preview = s:previewGit.' | bat -n --color=always --line-range '.line('w0').': -l='.expand('%:e')
command OpGitLog call fzf#run({'source': s:source, 'options': ['--preview', s:preview]})

