<?php

    /**
     * gestione inserimento dati batch
     * 
     * introduzione
     * ============
     * Il framework supporta l'inserimento di dati tramite processi batch, innescate dal caricamento di file
     * nella cartella VAR_SPOOL_IMPORT. Concedendo l'accesso a questa cartella per esempio tramite FTP, è possibile
     * realizzare un sistema di comunicazione tra applicazioni leggero e robusto.
     * 
     * esecuzione limitata al contesto CRON_RUNNING
     * --------------------------------------------
     * Dal momento che l'importazione dei dati tramite batch può rallentare l'esecuzione del framework,
     * essa viene eseguita solo se il sistema sta funzionando in modalità batch, ovvero se la costante
     * CRON_RUNNING è definita.
     * 
     * nota sull'esportazione dei dati
     * -------------------------------
     * Il framework può essere configurato anche per generare periodicamente dei file CSV contenenti i dati di
     * determinate tabelle. Questi lavori vengono di norma svolti da task custom appositamente preparati; la
     * cartella in cui di norma si trovano i file esportati è DIR_VAR_SPOOL_EXPORT.
     * 
     * come testare l'importazione dei dati
     * ------------------------------------
     * Per testare l'importazione dei dati, è possibile utilizzare lo script /_src/_sh/_test.import.sh che crea
     * dei file di test per la scrittura sulla tabella di test. Si vedano i commenti all'interno dello script per
     * ulteriori dettagli.
     * 
     * 
     */

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';

    /**
     * gestione blocchi dati programmati
     * =================================
     * Questo blocco si occupa di spostare i file programmati nella cartella di importazione
     * quando la data e ora corrente sono successive alla data di programmazione, espressa
     * dal nome stesso della cartella. Una volta spostati, i file vengono elaborati secondo
     * la logica di importazione del blocco successivo.
     * 
     * inserimento dei file programmati
     * --------------------------------
     * Questo meccanismo permette di pianificare l'importazione di file in un momento successivo,
     * evitando di sovraccaricare il sistema. Per sfruttare l'importazione programmata, è necessario
     * caricare i file non nella cartella DIR_VAR_SPOOL_IMPORT, ma nella sotto cartella
     * DIR_VAR_SPOOL_IMPORT_TODO, e all'interno di questa in una sotto cartella il cui nome
     * rispetti il formato YmdHis (ad esempio 20231025123000 per il 25 ottobre 2023 alle 12:30:00).
     * 
     * Per il naming dei file da caricare, si veda più avanti la sezione "gestione blocchi dati correnti".
     * 
     */

    // ...
    if( defined( 'CRON_RUNNING' ) ) {

        // trovo le sottocartelle della cartella di importazione
        $cf['import']['programmati'] = getDirList( DIR_VAR_SPOOL_IMPORT_TODO );

        // ...
        if( ! empty( $cf['import']['programmati'] ) ) {

            // log
            logWrite( 'cartelle programmate: ' . print_r( $cf['import']['programmati'], true ), 'import' );

            // cerco le cartelle programmate nel passato
            foreach( $cf['import']['programmati'] as $programmata ) {

                // se la cartella è programmata nel passato
                if( basename( $programmata ) <= date('YmdHis') ) {

                    // log
                    logWrite( 'cartella da elaborare (su '.date('YmdHis').'): ' . $programmata, 'import' );

                    // ottengo l'elenco dei file nella cartella
                    $cf['import']['programmati'] = getFileList( DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' );

                    // ...
                    if( ! empty( $cf['import']['programmati'] ) ) {

                        // log
                        logWrite( 'file da elaborare: ' . print_r( $cf['import']['programmati'], true ), 'import' );

                        // sposto i file nella cartella di importazione
                        foreach( $cf['import']['programmati'] as $programmato ) {

                            // log
                            logWrite( 'file da elaborare: ' . $programmato, 'import', LOG_ERR );

                            // sposto il file nella cartella di importazione
                            $r = moveFile( DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' . $programmato, DIR_VAR_SPOOL_IMPORT . $programmato );

                            // status
                            if( $r === true ) {
                                $cf['import']['info'][] = 'spostato file ' . $programmato . ' da ' . DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' . $programmato . ' a ' . DIR_VAR_SPOOL_IMPORT . $programmato;
                                logWrite( 'spostato file ' . $programmato . ' da ' . DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' . $programmato . ' a ' . DIR_VAR_SPOOL_IMPORT . $programmato, 'import', LOG_ERR );
                            } else {
                                $cf['import']['info'][] = 'impossibile spostare il file ' . $programmato . ' da ' . DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' . $programmato . ' a ' . DIR_VAR_SPOOL_IMPORT . $programmato;
                                logWrite( 'impossibile spostare il file ' . $programmato . ' da ' . DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' . $programmato . ' a ' . DIR_VAR_SPOOL_IMPORT . $programmato, 'import', LOG_ERR );
                            }

                        }

                        // elimino la cartella
                        deleteDir( DIR_VAR_SPOOL_IMPORT_TODO . $programmata . '/' );

                    }

                }

            }

        }

    }

    /**
     * gestione blocchi dati correnti
     * ==============================
     * In questo blocco vengono elaborati i file CSV presenti nella cartella di importazione. L'elaborazione
     * implica che il nome del file contenga le informazioni chiave della query da eseguire, come l'azione e l'entità.
     * 
     * Il formato per il nome del file comprende il nome dell'entità da alimentare, l'azione da eseguire e
     * opzionalmente un prefisso numerico per indicare l'ordine di importazione. Nomi validi pertanto possono essere:
     * 
     * - `azione.entita.csv`
     * - `NN.azione.entita.csv`
     * - `azione.entita.varie.csv`
     * - `NN.azione.entita.varie.csv`
     * 
     * Negli esempi sopra "varie" rappresenta una qualsiasi stringa che contenga ulteriori informazioni utili
     * all'essere umano, e viene ignorata dalla macchina.
     * 
     * elaborazione dei file CSV
     * -------------------------
     * Prima di tutto viene costruito l'elenco dei file CSV presenti nella cartella di importazione, dopodiché viene
     * ordinato con sort() in modo da considerare il prefisso NN come visto sopra; a questo punto, i file vengono elaborati
     * uno alla volta. Per ogni file, vengono estratte l'azione e l'entità dal nome, dopodiché viene verificato che
     * non esista una collisione con una tabella già presente in $_REQUEST.
     * 
     * L'importazione vera e propria viene fatta leggendo i dati tramite csvFile2array() e aggiungendo il campo
     * speciale __method__ che contiene l'azione da eseguire; dopodiché il pacchetto dati viene aggiunto alla $_REQUEST
     * per la successiva elaborazione da parte della controller (vedi _src/_config/_750.controller.php).
     * 
     * firma per l'autorizzazione
     * --------------------------
     * Per evitare che tramite il meccanismo di importazione si possano inserire dati arbitrari, il framework prevede
     * un meccanismo di controllo della firma dei dati importati; in pratica ad ogni riga importata viene aggiunto
     * il campo speciale __firma__ che contiene un hash della riga con la chiave $cf['auth']['import']['secret']; questo
     * valore viene poi verificato dalla controller per autorizzare l'importazione della riga.
     * 
     */

    // ...
    if( defined( 'CRON_RUNNING' ) ) {

        // ...

        // cerco file CSV da importare
        $cf['import']['csv'] = glob( DIR_VAR_SPOOL_IMPORT . '*.csv' );

        // debug
        // die( 'ricerca file di importazione' );
        // print_r( $cf['import']['csv'] );
        // die();

        // ordinamento
        sort( $cf['import']['csv'] );

        // elaboro i CSV
        foreach( $cf['import']['csv'] as $f ) {

            // ...
            // $f = array_shift( $cf['import']['csv'] );

            // ...
            // if( file_exists( $f ) ) {
        
            // ...
            logWrite( 'importo: ' . $f, 'import', LOG_ERR );

            // ...
            // if( filemtime( $f ) < strtotime( '-1 minutes' ) ) {
            // if( true ) {

            // ricavo l'azione e l'entità
            $req = explode( '.', basename( $f ) );

            // gestione del formato [NN.]azione.entita.[varie.]csv
            if( is_numeric( $req[0] ) ) {
                $action = $req[1];
                $table = $req[2];
            } else {
                $action = $req[0];
                $table = $req[1];
            }

            // status
            $cf['import']['info'][] = 'importazione file ' . basename( $f ) . ' come ' . strtoupper( $action ) . ' su tabella ' . $table;

            // debug
            // print_r( readFromFile( $f ) );
            // die();

            // elaboro i dati
            if( ! isset( $_REQUEST[ $table ] ) ) {

                // ...
                $fd = DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' . basename( $f );

                // archivio il file importato
                moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

                // status
                $cf['import']['info'][] = 'archiviato file ' . basename( $f ) . ' in ' . DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/';

                foreach( csvFile2array( $fd, NULL ) as $riga ) {

                    // TODO
                    // non c'è modo di far confluire questi dati nella controller della request
                    // popolando $_REQUEST[ tabella ][ n ]...
                    $riga['__method__'] = strtoupper( $action );
                    // $_REQUEST[ $table ]['__method__'] = strtoupper( $action );
                    // $_REQUEST['__info__'][ $k ]

                    // debug
                    // print_r( $riga );

                    // ...
                    // NOTA questo if METHOD_POST l'ho aggiunto perché sennò all'update creava una nuova riga...
                    // verificare che sia la soluzione migliore (vedere anche come funziona mysqlInsertRow()
                    if( $riga['__method__'] == METHOD_POST ) {
                        if( ! isset( $riga['id'] ) ) {
                            $riga['id'] = NULL;
                        }
                    }

                    // firma per l'autorizzazione della riga
                    if( isset( $cf['auth']['import']['secret'] ) ) {

                        // debug
                        // print_r( $riga );

                        // creazione firma
                        $riga['__firma__'] = hash(
                            getAvailableHashMethod(),
                            // serialize( $row ) . $cf['auth']['import']['secret']
                            $table . $cf['auth']['import']['secret']
                        );

                        // debug
                        // var_dump( $riga['__firma__'] );

                        // ...
                        $_REQUEST[ $table ][] = $riga;

                        // status
                        $cf['import']['rows'][ basename( $f ) ][] = $riga;

                    } else {

                        // log
                        logWrite( 'impossibile importare la riga: ' . print_r( $riga, true ) . ' per chiave di sicurezza mancante', 'import', LOG_ERR );

                        // status
                        $cf['import']['err'][] = 'impossibile importare la riga: ' . implode( ',', $riga ) . ' per chiave di sicurezza mancante';

                    }

                    // debug
                    // print_r( $riga );

                }

            } else {

                logWrite( 'collisione di tabelle: ' . $table, 'import', LOG_ERR );

            }

            // elimino il file importato
            // deleteFile( $f );

            // archivio il file importato
            // moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

            // debug
            // die( 'sposto' . $f . ' in ' . DIR_VAR_SPOOL_IMPORT_DONE );

        }

    }

    /**
     * gestione batch caricamento immagini
     * ===================================
     * Questo blocco si occupa di importare le immagini presenti nella cartella VAR_SPOOL_IMPORT,
     * gestendole in base alle informazioni contenute nel nome del file. Queste comprendono:
     * 
     * - un prefisso numerico opzionale per l'ordinae di importazione
     * - l'azione da eseguire
     * - l'entità a cui l'immagine è associata
     * - il codice dell'entità
     * - il ruolo dell'immagine
     * - un numero di ordine opzionale per le immagini multiple associate alla stessa entità
     * - eventuali informazioni aggiuntive, che vengono ignorate dall'importazione
     * 
     * Per esempio, sono nomi di file validi:
     * 
     * - NN.azione.entità.codice.ruolo.ordine.{jpg,png,jpeg}
     * - NN.azione.entità.codice.ruolo.{jpg,png,jpeg}
     * - NN.azione.entità.codice.ruolo.ordine.varie.{jpg,png,jpeg}
     * - azione.entità.codice.ruolo.ordine.{jpg,png,jpeg}
     * - azione.entità.codice.ruolo.{jpg,png,jpeg}
     * - azione.entità.codice.ruolo.ordine.varie.{jpg,png,jpeg}
     * 
     * Una volta ricavate le informazioni chiave dal nome del file, la procedura provvede a spostare
     * l'immagine dalla cartella di importazione a VAR_IMMAGINI e preparare il blocco dati per l'inserimento
     * nel database da parte della controller().
     * 
     * In caso di errore nel caricamento dell'immagine il blocco dati non viene creato per evitare che
     * si generino righe orfane nel database.
     * 
     */

    // ...
    if( defined( 'CRON_RUNNING' ) ) {

        // trovo le immagini presenti in var/spool/import/
        $cf['import']['img'] = glob( DIR_VAR_SPOOL_IMPORT . '*.{jpg,png,jpeg}', GLOB_BRACE );

        // debug
        // die( print_r( $cf['import']['img'], true ) );

        // se c'è almeno un'immagine da elaborare
        if( ! empty( $cf['import']['img'] ) ) {

            // prelevo un'immagine dalla lista
            $f = array_shift( $cf['import']['img'] );

            // debug
            // die( print_r( $cf['import']['img'], true ) );

            // log
            logger( 'trovata immagine da importare: ' . basename( $f ), 'image' );

            // ricavo l'azione e l'entità
            $req = explode( '#', basename( $f ) );

            // gestione del formato [NN#]azione#entita#codice#ruolo[#ordine][#varie].{jpg,png,jpeg}
            if( is_numeric( $req[0] ) ) {
                $action = $req[1];
                $table = $req[2];
                $codice = $req[3];
                $ruolo = $req[4];
                $ordine = ( isset( $req[5] ) ) ? $req[5] : NULL;
            } else {
                $action = $req[0];
                $table = $req[1];
                $codice = $req[2];
                $ruolo = $req[3];
                $ordine = ( isset( $req[4] ) ) ? $req[4] : NULL;
            }

            // ...
            if( ! is_numeric( $ordine ) ) {
                $ordine = NULL;
            }

            // debug
            // die( print_r( $req, true ) );

            // gestione del ruolo passato come ID numerico
            if( ! is_numeric( $ruolo ) ) {
                $ruolo = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT id FROM ruoli_immagini WHERE nome = ?',
                    array( array( 's' => $ruolo ) )
                );
            }

            // dati per l'inserimento
            switch( $table ) {
                case 'prodotti':
                    $field = 'id_prodotto';
                break;
                case 'articoli':
                    $field = 'id_articolo';
                break;
            }

            // verifico che l'oggetto collegato esista
            $check = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM ' . $table . ' WHERE id = ?',
                array( array( 's' => $codice ) )
            );

            // se l'oggetto esiste
            if( ! empty( $check ) ) {

                // log
                logger( 'check sulla tabella ' . $table . ': ' . $check, 'image' );

                // collante
                foreach( array( '#', '-', '.' ) as $g ) {
                    if( strpos( $codice, $g ) === false ) {
                        $gl = $g;
                    }
                }

                // percorso di destinazione
                $dst = DIR_VAR_IMMAGINI . implode( $gl, arrayTrim( array( $table, $codice, $ruolo, $ordine ) ) ) . '.' . strtolower( getFileExtension( $f ) );

                // debug
                // die( $dst );
                // die( $ruolo );

                // preparo l'oggetto
                $riga = array(
                    'id_ruolo' => $ruolo,
                    'path' => $dst,
                    'timestamp_inserimento' => time()
                );

                $riga[ $field ] = $codice;

                // debug
                // die( print_r( $riga, true ) );

                // inserisco la riga nella tabella immagini
                $idImmagine = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    $riga,
                    'immagini'
                );

                // debug
                // die( $idImmagine );

                // se l'immagine è stata inserita
                if( ! empty( $idImmagine ) ) {

                    // log
                    logger( 'ID immagine inserita: ' . $idImmagine, 'image' );

                    // sposto il file
                    moveFile( $f, $dst );

                    // se il file è stato spostato
                    if( file_exists( $dst ) ) {

                        // log
                        logger( 'importato file ' . $f . ' su ' . $dst, 'image' );

                    } else {

                        // log
                        logger( 'impossibile importare il file ' . $f . ' su ' . $dst, 'image' );

                        // pulizia databare
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'DELETE FROM immagini WHERE id = ?',
                            array( array( 's' => $idImmagine ) )
                        );

                    }

                } else {

                    // log
                    logger( 'ID immagine vuoto', 'image' );

                }

            } else {

                // log
                logger( 'impossibile associare il file: ' . $f, 'image' );

                // sposto il file fuori dalle scatole
                moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

            }

        }

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
    // if( isset( $cf['ws']['table'] ) ) {
    // die( print_r( $_REQUEST[ $cf['ws']['table'] ], true ) );
    // }
    // die();
