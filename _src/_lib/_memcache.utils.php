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
     * L'indice viene letto dalla chiave CACHE_QUERY_INDEX al runlevel _src/_config/_045.cache.php e riscritto a fine
     * richiesta in _src/_api/_pages.php, se è cambiato. Fino al 2026-09-24 stava nella chiave CACHE_INDEX, che dal
     * 2026-03-26 è anche quella dell'indice piatto di tutte le chiavi scritte da memcacheWrite() ( nella forma
     * <chiave> => array( 'time' => ..., 'ttl' => ... ), usato da memcacheFlush() ): per non far sovrascrivere le due
     * strutture a vicenda la scrittura in _pages.php era stata commentata, e l'indice per tabella conteneva solo le
     * query messe in cache durante la richiesta corrente. Ora le due strutture hanno ciascuna la sua chiave.
     *
     * NOTA l'indice viene salvato solo dalle richieste che passano per _src/_api/_pages.php: le query messe in cache
     * da un task o da un'API che non ci passa non entrano nell'indice e scadono solo per TTL; inoltre lettura e
     * riscrittura non sono atomiche, e di due richieste contemporanee che aggiungono voci vince l'ultima.
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
     * memcacheCleanQueries()           | cancella dalla cache tutte le query del sito o del deploy, anche fuori dagli indici
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
     * memcacheSiteSeed()               | _src/_lib/_memcache.tools.php
     * memcacheDeleteByPrefix()         | _src/_lib/_memcache.tools.php
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
     * La funzione modifica l'array globale $cf['memcache']['index'] in memoria; l'indice aggiornato viene riscritto
     * in cache, nella chiave CACHE_QUERY_INDEX, a fine richiesta da _src/_api/_pages.php.
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

    /**
     * cancella dalla cache tutte le query del sito o del deploy, anche fuori dagli indici
     *
     * Questa funzione cancella le chiavi MYSQL_ ( vedi mysqlCachedQuery() ) del sito corrente o, con $deploy a true, di tutti
     * i siti del deploy, chiedendo a ogni server della connessione l'elenco completo delle chiavi tramite
     * memcacheDeleteByPrefix(); non passa quindi né dall'indice CACHE_INDEX né da CACHE_QUERY_INDEX, che non elencano tutte le
     * query in cache ( vedi la NOTA in testa a questo file e la issue #605 ). Le chiavi degli altri deploy che condividono il
     * server non vengono toccate, perché si cancella solo per prefisso <seme del sito>MYSQL_.
     *
     * Serve dove i dati del database sono cambiati senza passare dal framework, per cui nessun controller ha invalidato le
     * query: l'applicazione delle patch ( _src/_api/_task/_mysql.patch.php ) e lo svuotamento a mano della cache
     * ( _src/_api/_task/_memcache.clean.php ). Il caso che l'ha resa necessaria è la conversione degli id del 30/09/2026
     * ( _202609301900.id.numerici.sql ): dopo la patch le tendine di gestionale.polmasi.it mostravano ancora gli id vecchi.
     *
     * @param       bool        $deploy     true per tutti i siti del deploy, false ( default ) per il solo sito corrente
     *
     * @return      mixed                   array( <server> => <chiavi cancellate> ), oppure false se manca la connessione o se
     *                                      almeno un server non ha restituito l'elenco delle chiavi
     *
     */
    function memcacheCleanQueries( $deploy = false ) {

        global $cf;

        if( ! isset( $cf['memcache']['connection'] ) || ! is_object( $cf['memcache']['connection'] ) ) {
            return false;
        }

        // prefissi delle chiavi da cancellare
        $prefissi = array();
        if( $deploy ) {
            foreach( $cf['sites'] as $sito ) {
                $seme = memcacheSiteSeed( $sito, SITE_STATUS, $cf['sites']['1']['domains'][ SITE_STATUS ] );
                if( $seme !== false ) {
                    $prefissi[] = $seme['seed'] . 'MYSQL_';
                }
            }
        } else {
            $prefissi[] = MEMCACHE_UNIQUE_SEED . 'MYSQL_';
        }

        // un giro per ogni server della connessione
        $esito = array();
        $ok = true;
        foreach( $cf['memcache']['connection']->getServerList() as $server ) {
            $errori = array();
            $nome = $server['host'] . ':' . $server['port'];
            $esito[ $nome ] = memcacheDeleteByPrefix( $server['host'], $server['port'], $prefissi, $errori );
            foreach( $errori as $errore ) {
                logWrite( 'pulizia delle query su ' . $nome . ': ' . $errore, 'memcache', LOG_ERR );
            }
            if( $esito[ $nome ] === false ) {
                $ok = false;
            } else {
                logWrite( 'pulizia delle query su ' . $nome . ': ' . $esito[ $nome ] . ' chiavi cancellate', 'memcache', LOG_INFO );
            }
        }

        return ( $ok ) ? $esito : false;

    }
