export POSH_THEME=::CONFIG::

TIMER_START="/tmp/${USER}.start.$$"

function bash_setstarttime() {
  ::OMP:: --millis > $1
}

PS0="$(bash_setstarttime $TIMER_START)"

function _update_ps1() {
    omp_elapsed=-1
    if [[ -f $TIMER_START ]]; then
        omp_now=$(::OMP:: --millis)
        omp_start_time=$(cat "$TIMER_START")
        omp_elapsed=$(($omp_now-$omp_start_time))
    fi
    PS1="$(::OMP:: --config $POSH_THEME --error $? --execution-time $omp_elapsed)"
}

if [ "$TERM" != "linux" ] && [ -x "$(command -v ::OMP::)" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

function runonexit() {
  rm $TIMER_START
}

trap runonexit EXIT
