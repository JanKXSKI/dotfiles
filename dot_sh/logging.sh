logdir=$1
parent=$(ps -o comm= $PPID)
exec {BASH_XTRACEFD}>$logdir/log-${0##*/}.$parent.log
set -x

