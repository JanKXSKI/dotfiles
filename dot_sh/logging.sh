if [[ -n $KLJA_LOGGING ]]; then
    logdir="$1"
    parentProcess=$(ps -o comm= $PPID)
    parent="$(basename "${parentProcess#-}")"
    exec {BASH_XTRACEFD}>"$logdir/log-${0##*/}.$parent.log"
    set -x
fi
