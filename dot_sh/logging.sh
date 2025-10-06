logdir=$1
parent=$(basename "$(ps -o comm= $PPID)")
exec {BASH_XTRACEFD}>$logdir/log-${0##*/}.$parent.log
set -x

