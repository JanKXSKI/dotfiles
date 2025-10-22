logdir="$1"
log="$logdir/log-${0##*/}.log"
export PS4='\[\033[0D\]$(printf "%-15.15s" "$(date "+%H:%M:%S %N")") '
exec 2>"$log"
exec {BASH_XTRACEFD}>>"$log"
set -x
