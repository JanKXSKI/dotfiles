parent=$(ps -o comm= $PPID)
exec {BASH_XTRACEFD}>$(dirname $0)/log-${0##*/}.$parent.log
set -x

