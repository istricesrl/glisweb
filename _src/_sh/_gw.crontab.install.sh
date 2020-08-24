#!/bin/bash

## azione
case "$1" in

    "install")
	echo "* *     * * *   root    curl -s '$2://$3/api/cron' > /dev/null" > /etc/cron.d/$( echo $3 | tr -d '.' | tr -d '-' )
	echo "crontab per $3 installato"
    ;;

    "remove")
	rm -f /etc/cron.d/$( echo $3 | tr -d '.' | tr -d '-' )
    ;;

    *)
	echo "$0 install|remove http|https url"
    ;;

esac
