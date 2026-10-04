<?php

    /**
     * applica le patch al database
     * 
     * questo task applica le patch al database; in fase di installazione questo significa creare
     * l'intero database da zero, poi durante il funzionamento normale del framework significa invece
     * applicare le patch rilasciate con le varie versioni per tenere il database allineato al codice
     * PHP del framework
     *
     * introduzione
     * ============
     * Tenere sincronizzati i database rispetto a un modello è una sfida estremamente impegnativa, dato
     * che la distribuzione delle modifiche deve avvenire tramite file SQL. Questo task si occupa per
     * l'appunto di applicare le patch al database, ovvero di eseguire i file SQL presenti nella cartella
     * _usr/_database/_patch/ in ordine di patch level.
     * 
     * La logica con cui sono costruiti i file di patch è molto semplice; si parte dal presupposto che
     * il database di partenza sia vuoto e a parte la tabella __patch__ che viene creata manualmente tutte
     * le altre tabelle, viste, relazioni, funzioni e procedure vengono create tramite patch; per poter
     * garantire che le patch vengano eseguite nell'ordine corretto, a ognuna di esse è associato un
     * numero progressivo che rappresenta poi anche il live di patch del database.
     * 
     * numerazione delle patch
     * -----------------------
     * Con ogni release maggiore del framework vengono rilasciate le patch dalla 000000000000 alla
     * 120000999999, che contengono i comandi SQL necessari a creare il database da zero. Queste patch
     * vengono quindi eseguite una volta sola, a database vuoto, e si concludono con una patch speciale
     * contenuta nel file _usr/_database/_patch/_120000999999.patch.sql che prende automaticamente il
     * numero dalla timestamp corrente, nel formato YYYYMMDDHHII. In questo modo, una volta inizializzato
     * il database da zero, il livello di patch sarà sempre superiore a qualsiasi patch aggiuntiva
     * rilasciata fino a quel momento. Non avrebbe infatti senso eseguire patch aggiuntive su un database
     * appena inizializzato, perché i file di patch base vengono mantenuti sincroni con la struttura
     * del database aggiornata.
     * 
     * Con qualunque altro rilascio del framework che non sia una major release vengono rilasciate le
     * cosiddette patch aggiuntive, che sono numerate secondo la logica YYYYMMDDHHII. Queste patch hanno
     * lo scopo di mantenere il database allineato con il codice PHP del framework, e vengono applicate
     * chiamando questo task manualmente o tramite cron di sistema. I file delle patch aggiuntive vengono
     * creati con il nome che riporta il livello di patch del giorno e le ultime quattro cifre impostate
     * a nove. In questo modo il framework può evitare di leggere i file di patch aggiuntivi obsoleti
     * rispetto al livello di patch corrente. Un esempio chiarirà ulteriormente il concetto.
     * 
     * Supponiamo che sia il 2024-02-11 e che Mario installi il framework per la prima volta, e per
     * semplicità immaginiamo che con il framework a quella data siano distribuiti oltre ai file di patch
     * base anche due file di patch aggiuntivi, numerati rispettivamente 202401229999 e 202402069999.
     * Quando Mario installerà il framework e inizializzerà il database, l'ultima delle patch base setterà
     * il livello di patch a 202402112506; questo indurrà il task a saltare i due file di patch aggiuntivi
     * 202401229999 e 202402069999 in quanto li vedrà come obsoleti rispetto al livello di patch corrente.
     * 
     * Proseguendo l'esempio supponiamo che a marzo 2024 venga pubblicato un nuovo file di patch aggiuntivo,
     * numerato 202403189999; quando Mario aggiornerà il framework e chiamerà il task per applicare le patch,
     * questo file verrà eseguito in quanto successivo al livello corrente 202402112506.
     * 
     * lettura ed esecuzione
     * ---------------------
     * Il task non contiene le regole delle patch: le chiama da _src/_lib/_mysql.tools.php, dove stanno una volta sola
     * per lui e per gli script _src/_sh/_mysql.upgrade.sh e _src/_sh/_database.rebuild.check.sh. mysqlPatchLevel()
     * legge il livello da __patch__, mysqlPatchFiles() trova i file, mysqlPatchRead() ne ricava le patch da applicare
     * ( un blocco per marcatore `-- |`, commenti scartati, id crescenti, l'id `------------` vale la data corrente in
     * formato YmdHi ) e mysqlPatchApply() le esegue con mysqli, una query per blocco, registrandole in __patch__ e
     * fermandosi al primo errore. Le regole sono descritte nei docblock di quelle funzioni.
     * 
     * Fino al 29/09/2026 il task leggeva ed eseguiva da sé, passando da mysqlQuery(): un blocco che cominciava con un
     * comando che mysqlQuery() non conosceva ( PREPARE, EXECUTE, DEALLOCATE ) non veniva eseguito, senza errore, e il
     * task lo registrava come fatto; l'id `------------` diventava date( 'YmdHis' ), quattordici caratteri in una
     * colonna char(12); e l'SQL dopo l'ultimo marcatore di un file si perdeva senza segnalazione.
     * 
     */

    // debug
    // ini_set( 'display_errors', 1 );
    // ini_set( 'display_startup_errors', 1 );
    // error_reporting( E_ALL );
    // die( 'debug attivo' );

    /**
     * inclusione del framework
     * ========================
     * 
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    /**
     * configurazioni iniziali
     * =======================
     * 
     */

    // inizializzo l'array del risultato
    $status = array();

    // data e ora di inizio del lavoro
    $status['start'] = date( 'Y-m-d H:i:s' );

    /**
     * codice principale di applicazione delle patch
     * =============================================
     * 
     */

    // verifico la connessione
    if( ! empty( $cf['mysql']['connection'] ) ) {

        // l'uscita si trattiene fino alla fine, cosi' in caso di errore si puo' ancora rispondere 500 dopo aver
        // scritto le patch applicate: un cron o un monitor che guardano solo il codice HTTP se ne accorgono
        ob_start();

        // ...
        header( 'Content-type: text/plain' );

        // livello di patch del database
        $patchLevel = mysqlPatchLevel( $cf['mysql']['connection'] );

        // senza livello non si applica niente: rieseguire tutto su un database in esercizio sarebbe il danno peggiore
        if( $patchLevel === false ) {
            logger( 'impossibile leggere il livello di patch: ' . mysqli_error( $cf['mysql']['connection'] ), 'mysql', LOG_ERR );
            http_response_code( 500 );
            die( 'impossibile leggere il livello di patch del database' );
        }

        // log
        logger( 'livello di patch del database -> ' . $patchLevel, 'mysql', LOG_NOTICE );

        // le patch da applicare
        $pWarnings = array();
        $pToApply = mysqlPatchRead( mysqlPatchFiles( DIR_BASE ), $patchLevel, $pWarnings );

        // segnalazioni della lettura ( SQL fuori dalle patch, id non crescenti )
        foreach( $pWarnings as $pWarning ) {
            logger( 'lettura delle patch -> ' . $pWarning, 'mysql', LOG_WARNING );
            echo 'ATTENZIONE ' . $pWarning . PHP_EOL;
        }

        // applico le patch
        $pError = array();
        $pDone = mysqlPatchApply( $cf['mysql']['connection'], $pToApply, $pError );

        // patch applicate
        foreach( $pDone as $pPatch ) {
            logger( 'patch applicata -> ' . $pPatch['id'] . ' ( ' . basename( $pPatch['file'] ) . ' )', 'mysql', LOG_NOTICE );
            echo 'patch ' . $pPatch['id'] . ' applicata correttamente' . PHP_EOL;
        }

        // le query in cache possono avere i dati di prima delle patch, e nessun controller le ha invalidate: si
        // cancellano quelle di tutto il deploy, anche se l'ultima patch e' fallita ( vedi memcacheCleanQueries() )
        if( ! empty( $pDone ) ) {
            $pCache = memcacheCleanQueries( true );
            if( is_array( $pCache ) ) {
                echo 'cache delle query svuotata: ' . array_sum( $pCache ) . ' chiavi cancellate' . PHP_EOL;
            } elseif( isset( $cf['memcache']['connection'] ) && is_object( $cf['memcache']['connection'] ) ) {
                logger( 'patch applicate ma cache delle query non svuotata, chiamare /task/memcache.clean?deploy=1', 'mysql', LOG_WARNING );
                echo 'ATTENZIONE cache delle query non svuotata, chiamare /task/memcache.clean?deploy=1' . PHP_EOL;
            }
        }

        // errore
        if( ! empty( $pError ) ) {
            $pStatus = 'errore nella patch ' . $pError['id'] . ( ( empty( $pError['file'] ) ) ? '' : ' di ' . basename( $pError['file'] ) ) . ': ' . $pError['errno'] . ' ' . $pError['error'];
            logger( $pStatus . '§query -> ' . $pError['query'], 'mysql', LOG_ERR );
            echo $pError['query'] . PHP_EOL;
            http_response_code( 500 );
            die( $pStatus . PHP_EOL . 'le patch successive non sono state applicate' );
        }

        // ...
        die( 'fine applicazione patch database' );

    } else {

        // ...
        http_response_code( 500 );
        die( 'connessione al database non disponibile' );

    }
