#!/bin/bash

## SCRIPT PER L'INSTALLAZIONE DEL CONTROLLO DI UPTIME
#
# installa o toglie il timer systemd che ogni minuto lancia _uptime.check.sh da questo deploy;
# e' l'analogo di _crontab.install.sh per il controllo di uptime
#
#   _uptime.install.sh install        scrive glisweb-uptime.service e .timer e li avvia
#   _uptime.install.sh remove         ferma il timer e toglie le due unita'
#
# il deploy da cui gira il timer lo sceglie chi amministra il server, e va scritto anche nel campo
# deploy: di /etc/glisweb/uptime.yaml, perche' /status/uptime legge la vista da li': conviene un
# deploy aggiornato e stabile, non quello in cui si sviluppa il framework
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## directory di lavoro
cd $RL || exit 1

## unita'
SERVICE=/etc/systemd/system/glisweb-uptime.service
TIMER=/etc/systemd/system/glisweb-uptime.timer

## azione
case "$1" in

    "install")
        if [ ! -f /etc/glisweb/uptime.yaml ]; then
            echo "manca /etc/glisweb/uptime.yaml: il formato e' nel capitolo 125.uptime del manuale"
            exit 1
        fi
        if ! grep -q "^deploy: *$(pwd)/\?$" /etc/glisweb/uptime.yaml; then
            echo "ATTENZIONE: il campo deploy: di /etc/glisweb/uptime.yaml non e' $(pwd)"
        fi
        printf '[Unit]\nDescription=controllo di uptime glisweb\n\n[Service]\nType=oneshot\nExecStart=%s/_src/_sh/_uptime.check.sh\n' "$(pwd)" > $SERVICE
        printf '[Unit]\nDescription=controllo di uptime glisweb, ogni minuto\n\n[Timer]\nOnCalendar=*-*-* *:*:00\nAccuracySec=1s\n\n[Install]\nWantedBy=timers.target\n' > $TIMER
        systemctl daemon-reload
        systemctl enable --now glisweb-uptime.timer
        echo "controllo di uptime installato da $(pwd)"
    ;;

    "remove")
        systemctl disable --now glisweb-uptime.timer
        rm -f $SERVICE $TIMER
        systemctl daemon-reload
        echo "controllo di uptime rimosso"
    ;;

    *)
        echo "$0 install|remove"
    ;;

esac
