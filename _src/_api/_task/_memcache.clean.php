<?php

    /**
     * svuotamento della cache memcache
     *
     * Dal 2026-11-05 svuota anche l'APCU e la cache chiave-valore su disco ( var/spool/cache/ ): quando manca memcache
     * l'albero delle pagine finisce lì ( _src/_lib/_cache.utils.php ), e senza questo passaggio la modifica a un file di
     * definizione delle pagine non si vedrebbe. Il nome del task resta questo perché lo chiamano il cron, gli script di
     * deploy e chi lo usa a mano. Le due portate qui sotto valgono per tutti e tre i motori; l'APCU si svuota solo chiamando
     * il task via HTTP, perché da riga di comando ( cron ) l'APCU è un'altra da quella di Apache.
     *
     * Dal 2026-11-12 non ricostruisce più la cache da sé: dopo il controllo dei privilegi chiama, per ogni sito da pulire,
     * /task/cache.rebuild ( _src/_api/_task/_cache.rebuild.php ) sul suo host, che ricostruisce l'albero delle pagine, svuota
     * la cache del sito, riscrive l'albero e risponde con un report: i report stanno in siti.<id>.ricostruzione della risposta.
     * Così nessun visitatore paga la ricostruzione e un anonimo respinto non la innesca. Se la ricostruzione di un sito non
     * riesce, il task lo svuota da sé come prima ( siti.<id>.riserva ) e l'esito è negativo.
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

    // inclusione del framework; la ricostruzione forzata ( MEMCACHE_REFRESH ) non si chiede qui ma in _cache.rebuild.php,
    // dopo il controllo dei privilegi: fino al 2026-11-12 la chiedeva questo task, e la faceva anche per gli anonimi respinti
    if( ! defined( 'CRON_RUNNING' ) ) {
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

    // siti da pulire: quello corrente, o tutti quelli del deploy; un sito senza dominio per lo stato corrente non ha cache
    // da svuotare. Il suffisso del seed è lo stesso per tutti i siti del deploy, e il seed si ricostruisce come in
    // _src/_config/_040.cache.php, a partire dal FQDN del sito: host di configurazione più dominio ( vedi memcacheSiteSeed() )
    $coda = $cf['sites']['1']['domains'][ SITE_STATUS ];
    $siti = array();
    foreach( $cf['sites'] as $id => $sito ) {
        if( $status['portata'] === 'deploy' || $id == SITE_CURRENT ) {
            $seme = memcacheSiteSeed( $sito, SITE_STATUS, $coda );
            if( $seme !== false ) {
                $siti[ $id ] = $seme;
            }
        }
    }

    // la ricostruzione di un sito grande dura anche minuti, e non deve fermarsi se chi ha chiamato il task si stanca
    ignore_user_abort( true );
    set_time_limit( 0 );

    // ricostruzione: per ogni sito si chiama _cache.rebuild.php sul suo host, perché la cache di un sito si legge e si
    // scrive col seed del suo FQDN, e l'APCU giusta è quella di Apache; il gettone, un file con un nome casuale in
    // DIR_VAR_SPOOL_REBUILD, è quello che _cache.rebuild.php controlla prima di far partire il framework
    $status['esito'] = true;
    $schema = parse_url( $cf['site']['url'], PHP_URL_SCHEME );
    $radice = rtrim( (string) parse_url( $cf['site']['url'], PHP_URL_PATH ), '/' );
    $fallite = array();
    foreach( $siti as $id => $seme ) {

        $gettone = bin2hex( random_bytes( 16 ) );
        $report = false;
        $codice = NULL;
        $errore = NULL;
        $raw = NULL;
        $intestazioni = array();

        if( checkFolder( DIR_VAR_SPOOL_REBUILD ) && touch( DIR_VAR_SPOOL_REBUILD . $gettone ) ) {

            $report = restCall( $schema . '://' . $seme['fqdn'] . $radice . '/task/cache.rebuild?t=' . $gettone, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $codice, array(), NULL, NULL, $errore, NULL, CURLAUTH_BASIC, $raw, $intestazioni, 600 );

            // se la chiamata non è arrivata il gettone è ancora lì
            @unlink( DIR_VAR_SPOOL_REBUILD . $gettone );

        } else {

            $errore = 'impossibile scrivere il gettone in ' . DIR_VAR_SPOOL_REBUILD;

        }

        $status['siti'][ $id ] = array(
            'fqdn'          => $seme['fqdn'],
            'status'        => $codice,
            'ricostruzione' => $report
        );

        if( empty( $report['esito'] ) ) {

            $status['siti'][ $id ]['errore'] = $errore;
            $fallite[ $id ] = $seme;
            $status['esito'] = false;

            logWrite( 'ricostruzione della cache di ' . $seme['fqdn'] . ' fallita ( ' . $codice . ' ' . $errore . ' ), la svuoto da qui', 'memcache', LOG_ERR );

        }

    }

    // riserva: i siti la cui ricostruzione non è riuscita si svuotano da qui, come faceva il task fino al 2026-11-12, così
    // almeno la cache vecchia non resta. Il giro non passa da memcacheRead()/memcacheDelete()/memcacheWrite(), che seedano
    // la chiave con quella del sito corrente e quindi andrebbero a leggere e a scrivere nel posto sbagliato: si lavora sulla
    // connessione, con le chiavi già complete
    $conn = $cf['memcache']['connection'];
    foreach( $fallite as $id => $seme ) {

        $fqdn = $seme['fqdn'];
        $seed = $seme['seed'];

        if( is_object( $conn ) ) {

            // indice delle chiavi di QUESTO sito, letto con la chiave già completa.
            // memcacheWrite() salva sempre serialize( $dato ), e memcacheRead() lo scioglie
            // in lettura: leggendo dalla connessione quel passaggio va rifatto a mano,
            // altrimenti qui arriva la stringa serializzata e l'indice sembra vuoto
            $grezzo = $conn->get( $seed . $nomeIndice );
            $indice = ( is_string( $grezzo ) && $grezzo !== '' ) ? @unserialize( $grezzo ) : $grezzo;

            $eliminate = 0;
            $errori    = 0;

            foreach( array_keys( (array) $indice ) as $chiave ) {

                if( $conn->delete( $chiave ) === false ) {

                    $codice = $conn->getResultCode();

                    // una chiave già scaduta non è un errore
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

            $status['siti'][ $id ]['riserva']['memcache'] = array(
                'chiavi'    => count( (array) $indice ),
                'eliminate' => $eliminate,
                'errori'    => $errori
            );

        }

        // APCU e disco ( apcuFlush() e diskFlush() svuotano un sito alla volta: apcu_clear_cache() svuoterebbe l'APCU di
        // tutti i deploy del server )
        $status['siti'][ $id ]['riserva']['apcu'] = ( function_exists( 'apcu_enabled' ) && apcu_enabled() ) ? apcuFlush( $fqdn ) : null;
        $status['siti'][ $id ]['riserva']['disk'] = diskFlush( $fqdn );

    }

    // le query in cache che gli indici non elencano ( vedi memcacheCleanQueries() ): le chiavi MYSQL_ scritte
    // senza indice restavano in cache anche dopo questo task, e dopo la conversione degli id del 30/09/2026 le
    // tendine continuavano a mostrare gli id vecchi ( polmasi, 01/10/2026: 6.826 chiavi, circa 419 nell'indice )
    $status['query'] = memcacheCleanQueries( $status['portata'] === 'deploy' );
    // senza memcache non ci sono query in cache, e memcacheCleanQueries() risponde false senza che sia un errore
    if( $status['query'] === false && is_object( $cf['memcache']['connection'] ) ) {
        $status['esito'] = false;
    }

    // controllo
    $status['controllo']['residue'] = memcacheRead( $cf['memcache']['connection'], memcacheUniqueKey( $key ) );

    // headers
    header( 'Access-Control-Allow-Origin: *' );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
