if [[ -n $KLJA_LOGGING ]]; then
    logdir="$1"
    parentProcess=$(ps -o comm= $PPID)
    parent="$(basename "${parentProcess#-}")"
    log="$logdir/log-${0##*/}.$parent.log"
    date >$log
    exec 2>>$log
    exec {BASH_XTRACEFD}>>$log
    set -x
fi
