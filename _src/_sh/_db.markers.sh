#!/bin/bash

## SCRIPT PER LA RIGENERAZIONE DEI MARCATORI DI STRUTTURA DELLO SCHEMA
#
# in testa a ogni tabella dello schema quattro campi ne dichiarano la natura: tipologia, rango,
# struttura, funzione. Tre sono decisioni di progetto; la STRUTTURA no, si legge dalla tabella
# stessa — ha `id_genitore` oppure non ce l'ha, ha un UNIQUE sui capi di una relazione oppure no.
# Questo script la deriva e riscrive il marcatore, cosi' marcatore e realta' non possono divergere.
#
#   _db.markers.sh              riscrive i marcatori sbagliati
#   _db.markers.sh --dry-run    elenca cosa cambierebbe, non scrive niente
#
# codice di uscita: 0 se non c'era niente da correggere, 1 se c'era, 2 in caso di errore
#
# PERCHE' ESISTE. Al 15/09/2026 i tre insiemi che dovrebbero coincidere non coincidevano: 43
# tabelle con `id_genitore`, 33 marcate ricorsive, 34 con la corte di funzioni. Un marcatore
# scritto a mano diverge dal codice appena qualcuno aggiunge una colonna e non aggiorna il
# commento, e nessuno se ne accorge perche' nessuno lo legge.
#
# COSA NON FA. Non aggiunge il marcatore alle tabelle che non ce l'hanno: inserirlo vorrebbe dire
# indovinare dove, dentro un blocco di commento che non ha una forma garantita. Quelle le elenca e
# le scrive una persona, una volta sola. E non decide i casi dubbi — un UNIQUE su piu' di tre
# chiavi non e' una relazione ma una chiave di business: li segnala e basta.
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## funzioni
. ./_lib/_functions.sh

## directory di lavoro
cd $RL || exit 1

## opzioni
SECCO=0
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) SECCO=1 ;;
        *)         echo "opzione non riconosciuta: $1" >&2; exit 2 ;;
    esac
    shift
done

## informazioni
echo "lavoro su: $(pwd)$( [ $SECCO -eq 1 ] && echo ' (prova, non scrivo)' )"

## sorgenti: standard e custom allo stesso percorso al netto degli underscore
php -d error_reporting=E_ALL -r '
    require "_src/_sh/_lib/_db.markers.php";

    // lo schema DI RIFERIMENTO sono i file il cui numero finisce per 999999: tables, indexes,
    // views e compagnia. I file datati ( _AAAAMMGGHHMM.*.sql ) sono migrazioni, e una CREATE TABLE
    // li dentro descrive un passaggio, non la forma attuale della tabella: scandirli farebbe
    // comparire la stessa tabella due volte, una con i marcatori e una senza.
    $tab = array_merge(
        glob( "_usr/_database/_patch/*999999*.sql" ) ?: array(),
        glob( "usr/database/patch/*999999*.sql" ) ?: array()
    );

    if( ! $tab ) {
        fwrite( STDERR, "nessun sorgente di schema trovato\n" );
        exit( 2 );
    }

    $voci = dbMarkersAnalizza( $tab, $tab );

    $e = dbMarkersRiscrivi( $voci, (bool) $argv[1] );

    printf(
        "\n  %d gia corretti, %d riscritti, %d senza marcatore, %d dubbi\n",
        $e["gia_giusti"], $e["corretti"], $e["senza_marcatore"], $e["dubbie"]
    );

    exit( ( $e["corretti"] + $e["senza_marcatore"] + $e["dubbie"] ) > 0 ? 1 : 0 );
' "$SECCO"

exit $?
