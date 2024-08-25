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
     * 
     * 
     */

    /**
     * inclusione del framework
     * ========================
     * 
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../_config.php';
    }

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

        // ...
        header( 'Content-type: text/plain' );

        // creo la tabella di patch se non esiste
        mysqlQuery(
            $cf['mysql']['connection'],
            'CREATE TABLE IF NOT EXISTS `__patch__` ('.
            '    `id` char(12) NOT NULL PRIMARY KEY,'.
            '    `patch` text COLLATE utf8_unicode_ci,'.
            '    `timestamp_esecuzione` int(11) DEFAULT NULL,'.
            '    `token` char(128) DEFAULT NULL,'.
            '    `note_esecuzione` text'.
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8;'
        );

        // debug
        // die( 'creazione della tabella di patch' );

        // cerco l'ultima patch eseguita
        $patchLevel = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id AS patch_level FROM __patch__ ORDER BY id DESC LIMIT 1'
        );

        // patch level di default
        if( empty( $patchLevel ) ) {
            $patchLevel = '000000000000';
        }

        // cerco i patch file
        $pFiles = getFilteredFileList( DIR_USR_DATABASE_PATCH, '_*.*.sql', false, 'glob2custom' );

        // ordino i patch file per patch level
        sort( $pFiles );

        // debug
        // echo 'percorso di ricerca: ' . glob2custom( DIR_USR_DATABASE_PATCH . '_*.*.sql' ) . PHP_EOL;
        // echo 'patch level: ' . $patchLevel . PHP_EOL;
        // die( print_r( $pFiles, true ) );

        // processo un patch file alla volta
        foreach( $pFiles as $pFile ) {

            // ricavo il livello di patch del file dal nome
            // $pFilePatchLevel = substr( basename( $pFile ), 1, 12 );
            $pFilePatchLevel = substr( str_replace( '_', '', basename( $pFile ) ), 0, 12 );

            // debug
            // echo 'patch level del file ' . $pFilePatchLevel . PHP_EOL;
            // echo 'patch level del database ' . $patchLevel . PHP_EOL;
            // die( 'elaborazione file' );

            // se il livello di patch del file è maggiore di quello del database...
            if( $pFilePatchLevel > $patchLevel ) {

                // log
                logger( 'elaborazione file patch -> ' . $pFile, 'mysql', LOG_NOTICE );

                // debug
                // echo 'prelevo le patch dal file ' . $pFilePatchLevel . PHP_EOL;

                // leggo il file in un array (una riga per elemento)
                $rows = readFromFile( $pFile );

                // debug
                // echo 'righe trovate nel file ' . $pFile . ' -> ' . count( $rows ) . PHP_EOL;

                // id della patch
                $pId = '';

                // patch corrente
                $pQuery = '';
                $pComments = '';

                // processo le righe una alla volta
                foreach( $rows as $row ) {

                    // se la riga inizia con il marcatore, allora ho trovato una patch
                    if( substr( trim( $row ), 0, 4 ) == '-- |' ) {

                        // se la query che sto ricavando non è vuota...
                        if( ! empty( trim( $pQuery ) ) ) {

                            // debug
                            // echo 'eseguo la patch ' . $pId . PHP_EOL;

                            // se l'ID della patch che sto lavorando è maggiore del patch level del database
                            if( $pId > $patchLevel ) {

                                // log
                                logger( 'elaborazione patch -> ' . $pId, 'mysql', LOG_NOTICE );

                                // eseguo la patch corrente
                                $pEx = mysqlQuery(
                                    $cf['mysql']['connection'],
                                    $pQuery
                                );

                                // debug
                                // echo 'scrivo la patch ' . $pId . PHP_EOL;

                                // risultato dell'esecuzione della patch
                                $pStatus = mysqli_errno( $cf['mysql']['connection'] ) . ' ' . mysqli_error( $cf['mysql']['connection'] );

                                // debug
                                if( ! empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) {
                                    echo $pQuery . PHP_EOL;
                                    echo $pStatus . PHP_EOL;
                                    die( 'errore nella patch ' . $pQuery );
                                } else {
                                    echo 'patch ' . $pId . ' applicata correttamente' . PHP_EOL;
                                }

                                // registro l'esecuzione della patch nella tabella __patch__
                                $rEx = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id' => $pId,
                                        'patch' => trim( $pQuery ),
                                        'timestamp_esecuzione' => ( ( empty( $pEx ) ) ? NULL : time() ),
                                        'note_esecuzione' => ( ( empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) ? 'OK' : $pStatus )
                                    ),
                                    '__patch__',
                                    false
                                );

                                // risultato dell'esecuzione della patch
                                $pStatus = mysqli_errno( $cf['mysql']['connection'] ) . ' ' . mysqli_error( $cf['mysql']['connection'] );

                                // debug
                                if( ! empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) {
                                    die( 'errore nella scrittura di ' . $pId . ' sulla tabella delle patch' );
                                }

                                // aggiorno il patch level al livello (ID) della patch che ho appena inserito
                                $patchLevel = $pId;

                            } else {

                                // debug
                                echo 'patch ' . $pId . ' obsoleta rispetto a ' . $patchLevel. PHP_EOL;

                            }

                        } else {

                            // debug
                            if( empty( $pComments ) ) {
                                echo 'NON eseguo la patch ' . $pId . ' in quanto è vuota' . PHP_EOL;
                            }

                        }

                        // leggo l'ID della patch
                        $pId = substr( $row, 5, 12 );

                        // se l'ID della patch è '------------' allora lo imposto alla data corrente
                        if( $pId == '------------' ) { $pId = date( 'YmdHis' ); }

                        // svuoto la query per ricominciare ad aggiungere righe
                        $pQuery = '';
                        $pComments = '';

                        // echo 'inizio la lettura della patch ' . $pId . PHP_EOL;

                    } elseif( substr( trim( $row ), 0, 2 ) == '--' ) {

                        // aggiungo la riga corrente alla patch che sto leggendo
                        $pComments .= $row;

                    } elseif( substr( trim( $row ), 0, 2 ) !== '--' ) {

                        // aggiungo la riga corrente alla patch che sto leggendo
                        $pQuery .= $row . PHP_EOL;

                    }

                }

            }

        }

        // ...
        die( 'fine applicazione patch database' );

    } else {

        // ...
        die( 'connessione al database non disponibile' );

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
