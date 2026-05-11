#!/bin/bash

# TODO documentare
# questo script è un buon posto dove mettere la documentazione su come GlisWeb gestisce i permessi
#

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella di installazione!
RL="../../"
RP="../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## passo alla cartella del deploy
cd $RL

## ricaavo il nome del deploy
SUB=$( basename $( pwd ) )

## passo alla cartella principale
cd $RP

## informazioni
echo "lavoro su: $(pwd)"

## utente FTP
if [ -f "ftpuser.conf" ]; then
    FTPUSER=$( cat ftpuser.conf | tr -d '[:space:]' )
    echo "utente FTP rilevato: $FTPUSER"
else
    FTPUSER="www-data"
fi

## cambio proprietario
chown -R root:www-data ./$SUB/
#find ./$SUB/src/templates                                                           -exec chown -R $FTPUSER:www-data {} \;
#find ./$SUB/src/tpl                                                                 -exec chown -R $FTPUSER:www-data {} \;
#find ./$SUB/tmp                                                                     -exec chown -R www-data:www-data {} \;
#find ./$SUB/var                                                                     -exec chown -R $FTPUSER:www-data {} \;
#find ./$SUB/var/cache                                                               -exec chown -R www-data:www-data {} \;

chown -R $FTPUSER:www-data ./$SUB/src/templates
chown -R $FTPUSER:www-data ./$SUB/src/tpl
chown -R www-data:www-data ./$SUB/tmp
chown -R $FTPUSER:www-data ./$SUB/var
chown -R www-data:www-data ./$SUB/var/cache

## cartella .git
if [ -d ".git" ]; then
    chown -R root:root ./$SUB/.git
fi

## cartella .github
if [ -d ".github" ]; then
    chown -R root:root ./$SUB/.github
fi

## informazioni
echo "impostati proprietari e gruppi, modifico i permessi"

## cambio permessi (silenzioso)
#
# Note sulle ottimizzazioni rispetto alla versione storica:
#
# 1. `-exec ... +` invece di `-exec ... \;`
#    Con `\;` find lancia una fork+exec di chmod per ogni singolo file. Su un
#    deploy con decine di migliaia di file sono decine di migliaia di fork e lo
#    script impiega minuti. Con `+` find raggruppa gli argomenti come fa xargs e
#    invoca chmod una volta ogni ARG_MAX file: il numero di fork crolla di un
#    paio di ordini di grandezza e il tempo totale passa da minuti a secondi.
#
# 2. Prune di `.git` e `var/log`
#    - `.git` è già gestito sopra (chown -R root:root) e non deve essere toccato
#      dai find generici. La vecchia clausola `-not \( -path ".git" -prune \)`
#      NON pruneva nulla: `-path` confronta con il path completo prodotto da
#      find (es. `./dev/.git`), non con il singolo segmento `.git`.
#    - `var/log` contiene tipicamente ~90% dei file del deploy. È popolato a
#      runtime da Apache/PHP-FPM con permessi già corretti del processo
#      scrivente, quindi resettarlo ad ogni giro è lavoro inutile. In più i suoi
#      file venivano in precedenza chmoddati due volte (prima 640 dal find
#      generico, poi 660 dal find su `var/`).
#
# Pattern di prune usato:
#     find ROOT \( -path P1 -o -path P2 \) -prune -o <filtro> -exec ... +
# La sotto-espressione `\( ... \) -prune` matcha i path da escludere e ne
# impedisce la discesa; l'`-o` finale fa sì che `-exec` venga applicato solo
# agli elementi che NON hanno fatto match con la prune.

# permessi base sull'intero deploy (escludendo .git e var/log)
find ./$SUB/                    \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -type d                                  -exec chmod 550 {} +
find ./$SUB/                    \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -type f                                  -exec chmod 640 {} +
find ./$SUB/                    \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -name '*.sh'                             -exec chmod 550 {} +

# permessi aggiuntivi per le cartelle scrivibili dal framework
# (su `var/` si esclude di nuovo `var/log` per non descendervi)
find ./$SUB/.git/hooks          -type f                                                                                                 -exec chmod ug+x {} +
find ./$SUB/src/tpl             -type d                                                                                                 -exec chmod 770 {} +
find ./$SUB/tmp                 -type d                                                                                                 -exec chmod 770 {} +
find ./$SUB/var                 -path "./$SUB/var/log" -prune                               -o -type d                                  -exec chmod 770 {} +

find ./$SUB/src/tpl             -type f                                                                                                 -exec chmod 660 {} +
find ./$SUB/mod/*/src/tpl       -type f                                                                                                 -exec chmod 660 {} +
find ./$SUB/tmp                 -type f                                                                                                 -exec chmod 660 {} +
find ./$SUB/var                 -path "./$SUB/var/log" -prune                               -o -type f                                  -exec chmod 660 {} +

# informazioni
echo "permessi modificati"

## TODO
# fare una modalità "paranoia" in cui:
# - il server web può solo leggere a parte quelle due o tre cartelle dove deve scrivere
# - le cartelle .git .github e il file .gitignore sono di proprietà di root
# - valutare altre restrizioni
#
# NOTE
#
# file su cui il framework può scrivere
# 640 -> rw-r-----
#
# cartelle su cui il framework può scrivere
# 750 -> rwxr-x---
#
# file su cui il framework non può scrivere
# 440 -> r--r-----
#
# cartelle su cui il framework non può scrivere
# script che il framework può eseguire ma non scrivere
# 550 -> r-xr-x---
#
