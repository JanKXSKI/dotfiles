logdir="$1"
parentProcess=$(ps -o comm= $PPID)
parent="$(basename "${parentProcess#-}")"
log="$logdir/log-${0##*/}.$parent.log"
export PS4='\033[0D$(printf "%-15.15s" "$(date "+%H:%M:%S %N")") '
exec 2>"$log"
exec {BASH_XTRACEFD}>>"$log"
set -x
