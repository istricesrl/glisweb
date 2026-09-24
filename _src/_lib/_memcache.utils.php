<?php

    /**
     * libreria per l'invalidazione della cache memcache legata al framework
     *
     * Questa libreria contiene le funzioni per l'utilizzo di memcache che dipendono dalle strutture interne del
     * framework, in particolare dall'indice della cache in $cf['memcache']['index']; le funzioni di base per leggere,
     * scrivere e cancellare le chiavi stanno in _src/_lib/_memcache.tools.php.
     *
     * introduzione
     * ============
     * Le query eseguite tramite mysqlCachedIndexedQuery() salvano il loro risultato in memcache e registrano la
     * chiave usata nell'indice $cf['memcache']['index'], sotto il nome di ciascuna tabella coinvolta nella query:
     *
     * ```
     * $cf['memcache']['index'][ <tabella> ]['query'][ <chiave memcache con seed> ] = <timestamp di scrittura>
     * ```
     *
     * Quando una tabella viene modificata (ad esempio da mysqlInsertRow() o dal controller in
     * _src/_inc/_controllers/_default.finally.php) le query in cache che la riguardano non sono più valide, e
     * questa libreria fornisce la funzione che le cancella partendo dall'indice.
     *
     * NOTA l'indice viene letto dalla chiave CACHE_INDEX al runlevel _src/_config/_045.cache.php, ma la sua
     * scrittura in cache a fine richiesta (in _src/_api/_pages.php) è commentata; inoltre la chiave CACHE_INDEX
     * è la stessa che memcacheWrite() aggiorna con un indice piatto di tutte le chiavi scritte, nella forma
     * <chiave> => array( 'time' => ..., 'ttl' => ... ), che non ha la struttura per tabella descritta sopra. Ne
     * segue che, di fatto, l'indice per tabella contiene solo le query messe in cache durante la richiesta
     * corrente; si veda il TODO nel docblock di memcacheCleanFromIndex().
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni di invalidazione della cache
     * -------------------------------------
     * Le funzioni in questo gruppo servono per cancellare dalla cache i dati non più validi.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * memcacheCleanFromIndex()         | cancella dalla cache le query registrate nell'indice per una tabella
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _src/_lib/_log.utils.php
     * memcacheDelete()                 | _src/_lib/_memcache.tools.php
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI INVALIDAZIONE DELLA CACHE
     */

    /**
     * cancella dalla cache le query registrate nell'indice per una tabella
     *
     * Questa funzione scorre le chiavi registrate in $cf['memcache']['index'][ $k ] (per ogni tipo di voce, di
     * fatto solo 'query'), cancella ciascuna chiave da memcache tramite memcacheDelete() e la toglie dall'indice in
     * memoria, scrivendo nel log speed ogni passaggio. I chiamanti la invocano due volte, per la tabella e per la
     * sua vista statica (<tabella>_static). Se non c'è una connessione memcache attiva in
     * $cf['memcache']['connection'], oppure se l'indice non contiene voci per $k, la funzione non fa niente; l'esito
     * delle singole cancellazioni non viene controllato.
     *
     * La funzione modifica l'array globale $cf['memcache']['index'], ma solo in memoria: l'indice aggiornato non
     * viene riscritto in cache.
     *
     * TODO l'indice per tabella non viene mai salvato in cache (la scrittura in _src/_api/_pages.php è commentata)
     * e la chiave CACHE_INDEX da cui viene caricato ha un'altra struttura (quella piatta di memcacheWrite()), per cui
     * questa funzione invalida solo le query messe in cache nella richiesta corrente; le query in cache scritte da
     * richieste precedenti restano valide fino alla scadenza del TTL anche dopo la modifica della tabella
     *
     * @param       string      $k      il nome della tabella di cui invalidare le query in cache
     *
     * @return      void
     *
     */
    function memcacheCleanFromIndex( $k ) {

        global $cf;

        // echo 'pulizia di ' . $k;

        if( isset( $cf['memcache']['connection'] ) && ! empty( $cf['memcache']['connection'] ) ) {

            logWrite( 'richiesta pulizia cache da indice per ' . $k, 'speed' );

            if( isset( $cf['memcache']['index'][ $k ] ) && is_array( $cf['memcache']['index'][ $k ] ) ) {
                foreach( $cf['memcache']['index'][ $k ] as $t => $l ) {
                logWrite( 'pulizia cache da indice per ' . $k . '/' . $t, 'speed' );
                foreach( $l as $j => $v ) {
                    unset( $cf['memcache']['index'][ $k ][ $t ][ $j ] );
                    memcacheDelete( $cf['memcache']['connection'], $j );
                    logWrite( 'pulizia cache da indice per ' . $k . '/' . $t . '/' . $j, 'speed' );
                }
                }
            }

        }

    }
