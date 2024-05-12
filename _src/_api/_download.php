<?php

    /**
     * API di download standard
     * 
     * questo script ha il compito di gestire il download dei file
     * 
     * introduzione
     * ============
     * È conoscenza comune il fatto che di per sé il download dei file è sempre possibile tramite un server web posto che i file che si desidera
     * scaricare siano nella document root del server stesso e che l'utente con cui gira il server web abbia i permessi di lettura su tali file.
     * Ovviamente è possibile impedire il download di file specifici modificandone i permessi o creando delle regole apposite nel file .htaccess;
     * tuttavia questo approccio è insufficiente quando si tratta di file caricati tramite il CMS in quanto non è sempre possibile conoscerne
     * il nome e il percorso a priori. Inoltre, un approccio totalmente basato sulla configurazione del server web non terrebbe conto del fatto che
     * i download potrebbero essere gestiti anche in base a criteri interni all'applicazione.
     * 
     * Per ovviare a questo problema, tramite una regola del file .htaccess tutte le richieste di accesso ai file che si trovano nella cartella
     * var/ vengono reindirizzate a questo script che si occupa di verificare se l'utente è autorizzato a scaricare il file richiesto. La regola in
     * questione è la seguente:
     * 
     * ```
     * RewriteRule ^var/(.+)$ _src/_api/_download.php?__download__=var/$1 [B,L,QSA]
     * ```
     * 
     * Anche se attualmente il compito principale di questa API è quello di verificare l'autorizzazione al download, la sua peculiare posizione la
     * rende una candidata ottimale per il rilevamento di statistiche e altre attività di monitoraggio e controllo; ad esempio potrebbe essere
     * possibile in futuro contare il numero di download di file, eccetera.
     * 
     * integrazione con il modulo mailing
     * ----------------------------------
     * Attualmente l'integrazione più importante con questa API è quella con il modulo di mailing; tramite questa integrazione è possibile rilevare
     * la lettura delle mail inviate. In questo caso, il modulo di mailing inserisce un parametro __mailing__ nell'URL del file da scaricare e questo
     * script si occupa di riportare il dato rilevato nel database. Le regole specifiche per il mailing sono:
     * 
     * ```
     * RewriteRule ^mailing/([0-9]+)/var/(.+)$ _src/_api/_download.php?__download__=var/$2&__mailing__=$1 [B,L,QSA]
     * RewriteRule ^mailing/([0-9]+)/([0-9]+)/var/(.+)$ _src/_api/_download.php?__download__=var/$3&__mailing__=$1&__mailing_dst__=$2 [B,L,QSA]
     * ```
     * 
     */

    /**
     * inclusione del framework
     * ========================
     * 
     */

    // inclusione del framework
	require '../_config.php';

    // debug
    // print_r( $_REQUEST );

    // variabile generale per il comportamento
    $authorized = false;

    /**
     * integrazione con il modulo mailing
     * ==================================
     * 
     */

    // se il file .htaccess ha popolato il parametro __mailing__
    if( isset( $_REQUEST['__mailing__'] ) ) {

        // se il file .htaccess ha popolato il parametro __mailing_dst__
        if( isset( $_REQUEST['__mailing_dst__'] ) ) {

            // log
            logger( 'rilevata lettura mailing #' . $_REQUEST['__mailing__'] . ' per mail #' . $_REQUEST['__mailing_dst__'], 'mailing' );

            // attività di lettura
            $read = array(
                'id_tipologia' => 35,
                'id_mailing' => $_REQUEST['__mailing__'],
                'data_attivita' => date( 'Y-m-d' ),
                'ora_fine' => date( 'H:i' ),
                'id_mail' => $_REQUEST['__mailing_dst__']
            );

            // recupero l'id_cliente
            $read['id_cliente'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id_anagrafica 
                FROM mail WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['__mailing_dst__'] )
                )
            );

        } else {

            // log
            logger( 'rilevata lettura mailing #' . $_REQUEST['__mailing__'], 'mailing' );

            // attività di lettura
            $read = array(
                'id_tipologia' => 35,
                'id_mailing' => $_REQUEST['__mailing__'],
                'data_attivita' => date( 'Y-m-d' ),
                'ora_fine' => date( 'H:i' )
            );

        }

        // inserimento attività di lettura
        mysqlInsertRow(
            $cf['mysql']['connection'],
            $read,
            'attivita'
        );

    }

    /**
     * pulizia e normalizzazione del nome del file
     * ===========================================
     * 
     */

    // ipotesi
    if( ! file_exists( DIR_BASE . $_REQUEST['__download__'] ) && strpos( $_REQUEST['__download__'], '+' ) !== false ) {
        $_REQUEST['__download__'] = str_replace( '+', ' ', $_REQUEST['__download__'] );
    }

    /**
     * logiche standard di protezione dei file
     * =======================================
     * 
     */

    // verifico se il file esiste
    if( ! file_exists( DIR_BASE . $_REQUEST['__download__'] ) ) {

        // header
        http_response_code( 404 );
        header( 'content-type: text/plain' );

        // messaggio di errore
        die( DIR_BASE . $_REQUEST['__download__'] . ' non esiste' );

    }

    // determino il mime type
    $finfo = finfo_open( FILEINFO_MIME );
    $mimetype = finfo_file( $finfo, DIR_BASE . $_REQUEST['__download__'] );
    finfo_close( $finfo );

    // verifico se il file è associato a oggetti del database
    $check = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT id FROM ( 
            SELECT id, path FROM file
            UNION
            SELECT id, path FROM immagini
        ) AS var
        WHERE var.path = ?',
        array(
            array( 's' => $_REQUEST['__download__'] )
        )
    );

    // autorizzo il download se il file non è associato a oggetti del database
    if( empty( $check ) ) {

        // autorizzazione
        $authorized = true;

    } else {

        // TODO qui anziché mettere semplicemente true vanno implementate le logiche
        // di protezione dei file associati a oggetti del database
        $authorized = true;

    }

    /**
     * logiche custom di protezione dei file
     * =====================================
     * 
     */

    // ricerca delle macro di download
	$arrayMacroBase             = glob( glob2custom( DIR_SRC_INC_MACRO . '_download.php' ), GLOB_BRACE );
	$arrayMacroModuli           = glob( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '_download.php' ), GLOB_BRACE );
	$arrayMacro                 = array_unique( array_merge( $arrayMacroBase , $arrayMacroModuli ) );

    // inclusione delle macro
    foreach( $arrayMacro as $fileMacro ) {
        require $fileMacro;
    }

    /**
     * download del file
     * =================
     * 
     */

    // restituzione contenuto
    if( $authorized === true ) {

        // header
        header( 'content-type: ' . $mimetype );

        // download
        echo file_get_contents( DIR_BASE . $_REQUEST['__download__'] );
    
    } else {

        // header
	    http_response_code( 403 );
        header( 'content-type: text/plain' );

        // messaggio di errore
        echo 'accesso negato per ' . $_REQUEST['__download__'];

    }
