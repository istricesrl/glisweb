<?php

    /**
     * libreria per la cache chiave-valore del framework, indipendente dal motore
     *
     * Questa libreria mette davanti alle librerie di cache del framework ( _memcache.tools.php, _apcu.tools.php,
     * _disk.tools.php ) un'interfaccia sola, con la stessa forma delle loro, e sceglie a ogni richiesta il motore da usare:
     * chi scrive cacheRead() e cacheWrite() non deve sapere se sul deploy c'è memcache, se c'è l'APCU o se resta solo il disco.
     *
     * introduzione
     * ============
     * Fino al 2026-11-05 la cache dell'albero delle pagine ( _src/_config/_300.pages.php e _330.pages.php ) stava solo in
     * memcache, e dove memcache mancava l'albero si ricostruiva dal database a ogni richiesta: 1 + 6N query, sul deploy di
     * ebhcconference 93 pagine, circa 560 query e la home in 6-16 secondi invece che in meno di uno. Con questa libreria la
     * cache delle pagine scende a un motore di riserva invece di sparire.
     *
     * scelta del motore
     * -----------------
     * Il motore si sceglie in quest'ordine, e resta lo stesso per tutta la richiesta:
     *
     * motore       | quando
     * -------------|-------------------------------------------------------------------------------------
     * memcache     | se c'è la connessione $cf['memcache']['connection'] ( _src/_config/_045.cache.php )
     * apcu         | se l'estensione APCU è caricata e attiva ( apcu_enabled(), quindi non da riga di comando con apc.enable_cli a Off )
     * disk         | sempre, è l'ultima riserva ( DIR_VAR_SPOOL_CACHE, var/spool/cache/ )
     *
     * Redis resta fuori di proposito ( decisione di Fabio del 2026-11-05 ): lo usano le sessioni, non questa cache.
     *
     * Il motore si può forzare con la chiave di configurazione cache.engine ( memcache, apcu o disk ); se il motore forzato
     * non è disponibile si torna alla scelta automatica.
     *
     * APCU e disco
     * ------------
     * Con PHP in mod_php l'APCU è una sola per tutto il server, e una scrittura può fallire perché la memoria è piena; in quel
     * caso il dato va su disco, e la lettura con il motore apcu cerca la chiave prima nell'APCU e poi sul disco. Per non
     * leggere una copia vecchia, una chiave sta in uno solo dei due posti: la scrittura riuscita nell'APCU cancella la copia
     * su disco, quella fallita cancella la copia nell'APCU.
     *
     * NOTA cron e script da riga di comando non vedono l'APCU di Apache: lì il motore è il disco ( se manca memcache ), e
     * quello che scrivono non arriva alle pagine che leggono dall'APCU
     *
     * funzioni
     * ========
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * cacheEngine()                    | restituisce il motore di cache della richiesta corrente
     * cacheGetKeyAge()                 | legge l'età di una chiave in cache
     * cacheWrite()                     | scrive un dato in cache
     * cacheAdd()                       | scrive un dato in cache solo se la chiave non c'è ( per i lock )
     * cacheDelete()                    | cancella un dato dalla cache
     * cacheFlush()                     | cancella dalla cache i dati del sito corrente, in tutti i motori
     * cacheRead()                      | legge un dato dalla cache
     *
     * dipendenze
     * ==========
     * La libreria usa le funzioni di _memcache.tools.php, _apcu.tools.php e _disk.tools.php con le loro costanti, e la
     * connessione $cf['memcache']['connection'].
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-11-05       | Fabio Mosti          | prima versione, cache delle pagine con riserva quando manca memcache
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     * restituisce il motore di cache della richiesta corrente
     *
     * Questa funzione restituisce il motore con cui lavorano le altre funzioni della libreria: quello forzato con la chiave
     * cache.engine se è disponibile, altrimenti il primo disponibile fra memcache, apcu e disk.
     *
     * @return      string                  memcache, apcu o disk
     *
     */
    function cacheEngine() {

        global $cf;

        $disponibili = array(
            'memcache'  => ! empty( $cf['memcache']['connection'] ),
            'apcu'      => function_exists( 'apcu_enabled' ) && apcu_enabled(),
            'disk'      => true
        );

        if( ! empty( $cf['cache']['engine'] ) && ! empty( $disponibili[ $cf['cache']['engine'] ] ) ) {
            return $cf['cache']['engine'];
        }

        return array_search( true, $disponibili, true );

    }

    /**
     * legge l'età di una chiave in cache
     *
     * Questa funzione legge il timestamp di scrittura di una chiave, con il motore della richiesta corrente. Come
     * memcacheGetKeyAge(), se è definita la costante MEMCACHE_REFRESH ( la definisce _src/_api/_task/_cache.rebuild.php )
     * restituisce false, così che il refresh forzato rigeneri tutto.
     *
     * @param       string      $key        la chiave di cui leggere l'età, senza il seme
     *
     * @return      mixed                   il timestamp della scrittura, oppure false se la chiave non esiste o se è in corso un refresh
     *
     */
    function cacheGetKeyAge( $key ) {

        global $cf;

        if( defined( 'MEMCACHE_REFRESH' ) ) {
            return false;
        }

        switch( cacheEngine() ) {
            case 'memcache':
                return memcacheGetKeyAge( $cf['memcache']['connection'], $key );
            case 'apcu':
                $r = apcuGetKeyAge( $key );
                return ( $r !== false ) ? $r : diskGetKeyAge( $key );
            default:
                return diskGetKeyAge( $key );
        }

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     *
     * Questa funzione scrive un dato in cache con il motore della richiesta corrente; con il motore apcu, se la scrittura
     * fallisce ( p.es. perché la memoria è piena ) il dato va su disco.
     *
     * @param       string      $key        la chiave con cui scrivere il dato, senza il seme
     * @param       mixed       $data       il dato da scrivere
     * @param       int|null    $ttl        il tempo di vita della chiave in secondi ( default: quello del motore )
     *
     * @return      bool                    true se il dato è stato scritto correttamente, false altrimenti
     *
     */
    function cacheWrite( $key, $data, $ttl = null ) {

        global $cf;

        switch( cacheEngine() ) {

            case 'memcache':
                return memcacheWrite( $cf['memcache']['connection'], $key, $data, ( ( $ttl === null ) ? MEMCACHE_DEFAULT_TTL : $ttl ) );

            case 'apcu':
                if( apcuWrite( $key, $data, ( ( $ttl === null ) ? APCU_DEFAULT_TTL : $ttl ) ) ) {
                    diskDelete( $key );
                    return true;
                }
                apcuDelete( $key );
                logger( 'scrittura APCU fallita per la chiave ' . $key . ', scrivo su disco', 'cache', LOG_WARNING );
                return diskWrite( $key, $data, ( ( $ttl === null ) ? DISK_DEFAULT_TTL : $ttl ) );

            default:
                return diskWrite( $key, $data, ( ( $ttl === null ) ? DISK_DEFAULT_TTL : $ttl ) );

        }

    }

    /**
     * scrive un dato in cache solo se la chiave non c'è
     *
     * Questa funzione scrive un dato con il motore della richiesta corrente, in modo atomico, solo se la chiave non c'è già:
     * di due richieste che la chiamano insieme sulla stessa chiave, una sola riceve true. Serve per i lock, come
     * CONTENTS_PAGES_LOCK di _src/_config/_300.pages.php. Con il motore apcu, come cacheWrite(), se l'APCU non riesce a
     * scrivere la chiave va su disco, e una chiave che c'è già su disco conta come presente.
     *
     * @param       string      $key        la chiave con cui scrivere il dato, senza il seme
     * @param       mixed       $data       il dato da scrivere
     * @param       int         $ttl        il tempo di vita della chiave in secondi ( default quello del motore )
     *
     * @return      bool                    true se il dato è stato scritto, false se la chiave c'era già o se la scrittura non è riuscita
     *
     */
    function cacheAdd( $key, $data, $ttl = null ) {

        global $cf;

        switch( cacheEngine() ) {
            case 'memcache':
                return memcacheAdd( $cf['memcache']['connection'], $key, $data, ( ( $ttl === null ) ? MEMCACHE_DEFAULT_TTL : $ttl ) );
            case 'apcu':
                if( diskRead( $key ) !== false ) {
                    return false;
                }
                if( apcuAdd( $key, $data, ( ( $ttl === null ) ? APCU_DEFAULT_TTL : $ttl ) ) ) {
                    return true;
                }
                if( apcuRead( $key ) !== false ) {
                    return false;
                }
                logger( 'scrittura APCU fallita per la chiave ' . $key . ', scrivo su disco', 'cache', LOG_WARNING );
                return diskAdd( $key, $data, ( ( $ttl === null ) ? DISK_DEFAULT_TTL : $ttl ) );
            default:
                return diskAdd( $key, $data, ( ( $ttl === null ) ? DISK_DEFAULT_TTL : $ttl ) );
        }

    }

    /**
     * cancella un dato dalla cache
     *
     * Questa funzione cancella una chiave con il motore della richiesta corrente ( con il motore apcu anche dal disco ).
     *
     * @param       string      $key        la chiave da cancellare, senza il seme
     *
     * @return      bool                    true se la chiave è stata cancellata, false altrimenti
     *
     */
    function cacheDelete( $key ) {

        global $cf;

        switch( cacheEngine() ) {
            case 'memcache':
                return memcacheDelete( $cf['memcache']['connection'], $key );
            case 'apcu':
                $a = apcuDelete( $key );
                $d = diskDelete( $key );
                return $a || $d;
            default:
                return diskDelete( $key );
        }

    }

    /**
     * cancella dalla cache i dati del sito corrente, in tutti i motori
     *
     * Questa funzione svuota la cache del sito corrente in tutti i motori disponibili, non solo in quello della richiesta: un
     * deploy che oggi ha memcache può avere su disco o nell'APCU una copia scritta quando memcache mancava, e quella copia
     * tornerebbe buona alla prossima volta che memcache manca. Per la pulizia di tutti i siti del deploy si veda
     * _src/_api/_task/_memcache.clean.php.
     *
     * @return      array                   l'esito per motore, array( 'memcache' => ..., 'apcu' => ..., 'disk' => ... ), con
     *                                      null per un motore non disponibile
     *
     */
    function cacheFlush() {

        global $cf;

        return array(
            'memcache'  => ( ! empty( $cf['memcache']['connection'] ) ) ? memcacheFlush( $cf['memcache']['connection'] ) : null,
            'apcu'      => ( function_exists( 'apcu_enabled' ) && apcu_enabled() ) ? apcuFlush() : null,
            'disk'      => diskFlush()
        );

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * legge un dato dalla cache
     *
     * Questa funzione legge una chiave con il motore della richiesta corrente; con il motore apcu, se la chiave non è
     * nell'APCU la cerca su disco ( vedi cacheWrite() ).
     *
     * @param       string      $key        la chiave da leggere, senza il seme
     *
     * @return      mixed                   il dato letto, oppure false se la chiave non esiste
     *
     */
    function cacheRead( $key ) {

        global $cf;

        switch( cacheEngine() ) {
            case 'memcache':
                return memcacheRead( $cf['memcache']['connection'], $key );
            case 'apcu':
                $r = apcuRead( $key );
                return ( $r !== false ) ? $r : diskRead( $key );
            default:
                return diskRead( $key );
        }

    }
