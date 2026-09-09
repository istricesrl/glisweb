<?php

    /**
     * svuotamento della cache memcache
     *
     * Si chiama con l'URL /task/memcache.clean e vuole il privilegio GESTIONE_CACHE
     * ( il task non e' piu' raggiungibile da anonimo dal 2026-09-05 ).
     *
     * DUE PORTATE
     * ===========
     *
     * - senza parametri svuota la cache del **sito corrente**, cioe' del sito a cui appartiene
     *   l'host con cui e' stato chiamato;
     * - con **?deploy=1** svuota la cache di **tutti i siti del deploy**.
     *
     * Perche' serve la seconda. Ogni chiave di cache viene prefissata da MEMCACHE_UNIQUE_SEED
     * ( _src/_config/_040.cache.php ), che si costruisce dal FQDN del sito piu' il dominio del
     * sito 1: siti diversi dello stesso deploy hanno seed diversi. Fin qui e' voluto. Il punto
     * e' che **anche l'indice delle chiavi e' seedato**: memcacheFlush() legge CACHE_INDEX
     * passando per memcacheUniqueKey(), quindi vede solo l'indice del sito corrente e puo'
     * cancellare solo le chiavi che ci stanno dentro. Il suo parametro $allSites, che questo
     * task valorizza da sempre con un valore vero, non cambia niente: filtra un elenco che e'
     * gia' ristretto a un sito solo.
     *
     * L'effetto pratico si vede quando si cambia qualcosa che vale per tutti i siti — una
     * pagina di configurazione, un template condiviso, un dizionario: la modifica compare sul
     * sito su cui si e' chiamato il task e resta invisibile su tutti gli altri, che continuano
     * a servire la copia in cache. Il 05/09/2026, dopo aver pubblicato due pagine legali nuove
     * su gimbe.istricesrl.it, in produzione rispondevano 200 solo su www.gimbeducation.it e 404
     * sugli altri sedici siti: non era il carico, era questo.
     *
     * Il giro su tutti i siti non passa da memcacheRead()/memcacheDelete()/memcacheWrite(),
     * che seedano la chiave con quella del sito corrente e quindi andrebbero a leggere e a
     * scrivere nel posto sbagliato: si lavora sulla connessione, con le chiavi gia' complete.
     *
     * Il default resta il sito corrente, per non cambiare il significato delle chiamate che
     * esistono gia' ( il cron, gli script di carico, le abitudini di chi lo chiama a mano ).
     */

    // NOTA potete chiamare questa API con l'URL /task/memcache.clean

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        define( 'MEMCACHE_REFRESH', 1 );
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    /**
     * Fix 2026-09-09: rimesso il controllo dei privilegi.
     *
     * Questo file e' stato ricostruito unendo due versioni che si erano sovrascritte a vicenda
     * upstream il 06/09/2026 alle 21:29, a trentatre' secondi l'una dall'altra: il riallineamento
     * da GIMBE portava le due portate ( sito / deploy ) documentate qui sopra ma partiva da una
     * copia precedente al 05/09, quindi si portava dietro la versione SENZA controllo dei
     * privilegi; il riallineamento da Masi, subito dopo, rimetteva il controllo ma riportava il
     * file a 55 righe, cancellando le due portate.
     *
     * Nessuna delle due versioni era quella giusta: questa le tiene insieme.
     */
    checkTaskPrivilege( 'GESTIONE_CACHE' );

    // inizializzo l'array del risultato
    $status = array();

    // nome dell'indice delle chiavi.
    //
    // ATTENZIONE: memcacheUniqueKey() prende la chiave PER RIFERIMENTO e la modifica, quindi
    // dopo la riga di controllo qui sotto $key non vale piu' 'CACHE_INDEX' ma la versione gia'
    // seedata col sito corrente. Il giro sui siti deve usare il nome nudo, che percio' viene
    // tenuto a parte: concatenare $key a un altro seed produce una chiave che non esiste.
    $nomeIndice = 'CACHE_INDEX';
    $key = $nomeIndice;

    // portata della pulizia
    $status['portata'] = ( ! empty( $_REQUEST['deploy'] ) ) ? 'deploy' : 'sito';

    // controllo
    $status['controllo']['chiavi'] = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) );

    if( $status['portata'] === 'sito' ) {

        // faccio il flush della cache del solo sito corrente
        $status['esito'] = memcacheFlush( $cf['memcache']['connection'], $cf['sites']['1']['domains'][ SITE_STATUS ] );

    } else {

        $conn = $cf['memcache']['connection'];

        if( ! is_object( $conn ) ) {

            logWrite( 'connessione al server assente per il flush di deploy', 'memcache', LOG_ERR );

            $status['esito'] = false;

        } else {

            $status['esito'] = true;

            // il suffisso del seed e' lo stesso per tutti i siti del deploy
            $coda = $cf['sites']['1']['domains'][ SITE_STATUS ];

            foreach( $cf['sites'] as $id => $sito ) {

                // un sito senza dominio per lo stato corrente non ha cache da svuotare
                if( empty( $sito['domains'][ SITE_STATUS ] ) ) {
                    continue;
                }

                // il seed si ricostruisce come in _src/_config/_040.cache.php, a partire dal
                // FQDN del sito: host di configurazione piu' dominio. Gli alias non contano,
                // perche' il FQDN lo danno hosts[] e domains[], non l'host della richiesta
                $fqdn = trim(
                    ( ( ! empty( $sito['hosts'][ SITE_STATUS ] ) ) ? $sito['hosts'][ SITE_STATUS ] . '.' : NULL )
                    . $sito['domains'][ SITE_STATUS ],
                    ". \t\n\r\0\x0B"
                );

                $seed = strtoupper( str_replace( '.', '_', $fqdn . '_' . $coda . '_' ) );

                // indice delle chiavi di QUESTO sito, letto con la chiave gia' completa.
                // memcacheWrite() salva sempre serialize( $dato ), e memcacheRead() lo scioglie
                // in lettura: leggendo dalla connessione quel passaggio va rifatto a mano,
                // altrimenti qui arriva la stringa serializzata e l'indice sembra vuoto
                $grezzo = $conn->get( $seed . $nomeIndice );
                $indice = ( is_string( $grezzo ) && $grezzo !== '' ) ? @unserialize( $grezzo ) : $grezzo;

                if( ! is_array( $indice ) || empty( $indice ) ) {
                    $status['siti'][ $id ] = array( 'fqdn' => $fqdn, 'chiavi' => 0 );
                    continue;
                }

                $eliminate = 0;
                $errori    = 0;

                foreach( array_keys( $indice ) as $chiave ) {

                    if( $conn->delete( $chiave ) === false ) {

                        $codice = $conn->getResultCode();

                        // una chiave gia' scaduta non e' un errore
                        if( ( defined( 'Memcached::RES_NOTFOUND' ) && $codice === Memcached::RES_NOTFOUND ) || $codice === 16 ) {
                            logWrite( 'chiave gia\' assente (' . $codice . '): ' . $chiave, 'memcache' );
                        } else {
                            logWrite( 'impossibile (' . $codice . ') eliminare la chiave: ' . $chiave, 'memcache', LOG_ERR );
                            $errori++;
                        }

                    } else {
                        logWrite( 'chiave eliminata: ' . $chiave, 'memcache' );
                        $eliminate++;
                    }

                }

                // l'indice del sito resta, ma vuoto, e serializzato come lo scrive il framework
                $conn->set( $seed . $nomeIndice, serialize( array() ) );

                $status['siti'][ $id ] = array(
                    'fqdn'      => $fqdn,
                    'chiavi'    => count( $indice ),
                    'eliminate' => $eliminate,
                    'errori'    => $errori
                );

                if( $errori > 0 ) {
                    $status['esito'] = false;
                }

            }

            logWrite(
                'flush di deploy: ' . count( $status['siti'] ) . ' siti passati',
                'memcache',
                ( $status['esito'] ) ? LOG_INFO : LOG_ERR
            );

        }

    }

    // controllo
    $status['controllo']['residue'] = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) );

    // headers
    header( 'Access-Control-Allow-Origin: *' );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
