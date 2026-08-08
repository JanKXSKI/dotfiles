set noshelltemp shellquote= shellxquote=
set shell=~\.config\pwsh-nologo.bat
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
let &shellcmdflag .= '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
let &shellcmdflag .= '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
let &shellcmdflag .= '$PSStyle.OutputRendering=''PlainText'';'
let &shellpipe  = '> %s 2>&1'
" Workaround (may not be needed in future version of pwsh):
let $__SuppressAnsiEscapeSequences = 1
