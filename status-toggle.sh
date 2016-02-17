#!/usr/bin/env bash

# display usage
usage() {
    cat <<EOF
True-False-True-False toggle emulator.
Usage: 
    $APP_NAME [-a i|ri|run] [identifer_path]
Option:
    -a, action, default run without initial. i: initial, true first; ri, reverse initial, false first.
EOF
}


APP_NAME=$(basename $0)
TRUE=0
FALSE=1
default_identifer=/tmp/${APP_NAME}
action='run' # default action
# read the options
TEMP=$(getopt -o 'ha:' -l 'help' -n $APP_NAME -- "$@")
eval set -- "$TEMP"
while true; do
    case $1 in
        -a) 
            case $2 in
                i|ri|run) action=$2; shift 2
                    ;;
                *) echo "${APP_NAME}: '$2': invalid action" 2>&1; exit 1
                    ;;
            esac
            ;;
        -h|--help) usage&&exit 0
            ;;
        --) shift; break
            ;;
    esac
done
# rewrite indentifer, in case of deleting file
indentifer=${1:-$default_identifer}_status-toggle-marker_
if [[ $action = i ]]; then
    # try if we have permission to create file, and then delete it
    touch $indentifer
    rm -f $indentifer
elif [[ $action = ri ]]; then
    touch $indentifer
else
    # toggle start
    if [[ -e $indentifer ]]; then
        rm -f $indentifer
        exit $FALSE
    else
        touch $indentifer
        exit $TRUE
    fi
fi