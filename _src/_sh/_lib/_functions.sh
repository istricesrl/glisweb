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

    options=$(getopt -o bhr --long hard,test: -- "$@")

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
            --hard)
                PARGHARD=1
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
