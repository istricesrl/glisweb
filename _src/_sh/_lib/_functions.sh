#!/bin/bash

function check-root() {
    if [ ! $(id -u) = 0 ]; then
        echo "devi essere root per eseguire questo script"
        exit 1
    else
        echo "verifica utente root OK"
    fi
}

function check-args() {

    if [ $# -eq 0 ]; then
        PNOARGS=1
        return
    fi

    options=$(getopt -o bhr --long soft,hard,nolog,nobackup,major,minor,patch,increment:,test: -- "$@")

    echo "valuto: $options"

    eval set -- "$options"

    while true; do

        case "$1" in
            -b)
                PARGB=1
                ;;
            -h)
                PARGH=1
                ;;
            -r)
                PARGR=1
                ;;
            --soft)
                PARGSOFT=1
                ;;
            --hard)
                PARGHARD=1
                ;;
            --nolog)
                PARGNOLOG=1
                ;;
            --nobackup)
                PARGNOBACKUP=1
                ;;
            --major)
                PARGINCREMENT=1
                PVALINCREMENT="major"
                ;;
            --minor)
                PARGINCREMENT=1
                PVALINCREMENT="minor"
                ;;
            --patch)
                PARGINCREMENT=1
                PVALINCREMENT="patch"
                ;;
            --increment)
                shift;
                PARGINCREMENT=1
                PVALINCREMENT=$1
                ;;
            --test)
                shift;
                PARGTEST=1
                PVALTEST=$1
                ;;
            --)
                shift
                break
                ;;
        esac

        shift

    done

}

increment-version() {
  local delimiter=.
  local array=($(echo "$1" | tr $delimiter '\n'))
  array[$2]=$((array[$2]+1))
  echo $(local IFS=$delimiter ; echo "${array[*]}")
}