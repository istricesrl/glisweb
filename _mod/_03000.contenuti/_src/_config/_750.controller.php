<?php

    /**
     * gestione dei flussi dati del modulo contenuti
     * 
     * in questo file vengono gestiti i dati in ingresso e in uscita dal framework relativi al modulo contenuti
     * 
     * introduzione
     * ============
     * In questo file vengono gestiti i flussi dati del modulo contenuti; in particolare, vengono gestiti i flussi
     * di creazione, modifica e cancellazione dei file dei template (schemi, file CSS, file JS, file di configurazione
     * e così via). Oltre ad essere un modulo contenitore, il modulo contenuti supporta infatti anche l'editing
     * dei template.
     * 
     * Lo schema generale del file è molto semplice, e prevede la cancellazione o in alternativa la creazione o modifica
     * di un dato file:
     * 
     * ```
     * if( isset( $_REQUEST['__delete__'] ) && $_REQUEST['__delete__'] == 1 ) {
     * 
     *    // cancellazione del file
     * 
     * } elseif( isset( $_REQUEST['__templates__']['id'] ) && ! empty( $_REQUEST['__templates__']['id'] ) ) {
     * 
     *    if( isset( $_REQUEST['__template_files__']['id'] ) && ! empty( $_REQUEST['__template_files__']['id'] ) ) {
     * 
     *        // creazione o modifica del file
     * 
     *    }
     * 
     * }
     * ```
     * 
     * In particolare, se viene modificato un file standard, il sistema crea automaticamente la sua controparte custom
     * e vi salva la modifica (in questo modo il file standard non viene toccato). Se invece viene creato un file custom,
     * il sistema lo crea direttamente. In caso di cancellazione, solo i file custom possono essere cancellati, quindi
     * ad esempio in caso di cancellazione di un file standard viene semplicemente cancellata la sua controparte custom.
     * 
     * La logica di scrittura è molto semplice:
     * 
     * ```
     *  // scrittura
     *  if( isset( $_REQUEST['__template_files__']['contenuto'] ) && ! empty( trim( $_REQUEST['__template_files__']['contenuto'] ) ) ) {
     *  
     *      // scrivo in custom il contenuto della textarea
     *  
     *  } elseif( ! file_exists( getFullPath( $custom ) ) && file_exists( getFullPath( $base ) ) ) {
     *  
     *      // scrivo in custom il contenuto del file standard
     *  
     *  } elseif( ! file_exists( getFullPath( $custom ) ) ) {
     *  
     *      // creo il file custom vuoto
     *  
     *  }
     * ```
     * 
     * La lettura ragiona in maniera analoga, ossia se esiste il file custom viene letto quello, altrimenti il contenuto
     * viene prelevato dal file standard se esiste:
     * 
     * ```
     * // cerco il contenuto custom e se non esiste prendo lo standard
     * if( file_exists( getFullPath( $custom ) ) ) {
     * 
     *  // leggo il contenuto del file custom
     * 
     * }
     * 
     * if( file_exists( getFullPath( $base ) ) ) {
     * 
     *  // leggo il contenuto del file standard
     * 
     * }
     * 
     * if( empty( trim( $ct['etc']['reading']['custom'] ) ) ) {
     * 
     *  // uso il contenuto standard
     * 
     * } else {
     * 
     *  // uso il contenuto custom
     * 
     * }
     * ```
     * 
     * 
     */

    // debug
    // die( print_r( $_REQUEST, true ) );
    // die( print_r( $_REQUEST['__templates__'], true ) );
    // die( print_r( $_REQUEST['__template_files__'], true ) );

    // se è settata una richiesta di cancellazione...
    if( isset( $_REQUEST['__delete__'] ) && $_REQUEST['__delete__'] == 1 ) {

        // nome del file custom
        $custom = path2custom(
           DIR_SRC_TPL.
            '_' . $_REQUEST['__templates__']['id'] . '/' .
            ( ( isset( $_REQUEST['__template_files__']['folder'] ) && ! empty( $_REQUEST['__template_files__']['folder'] ) ) 
            ? trim( $_REQUEST['__template_files__']['folder'], './' ) . '/' 
            : NULL ) .
            $_REQUEST['__template_files__']['id']
        );

        // eliminazione del file
        $e = deleteFile( $custom );

        // debug
        // var_dump( $e );
        // die( 'devo cancellare il file: ' . $custom );

    } elseif( isset( $_REQUEST['__templates__']['id'] ) && ! empty( $_REQUEST['__templates__']['id'] ) ) {

        // se è specificato un file per il template
        if( isset( $_REQUEST['__template_files__']['id'] ) && ! empty( $_REQUEST['__template_files__']['id'] ) ) {

            // se è specificata una cartella per il template
            if( isset( $_REQUEST['__template_files__']['folder'] ) && ! empty( $_REQUEST['__template_files__']['folder'] ) ) {
                $_REQUEST['__template_files__']['folder'] = trim( $_REQUEST['__template_files__']['folder'], './' );
            }

            // se è specificato un modulo per il template
            if( isset( $_REQUEST['__template_files__']['modulo'] ) && ! empty( $_REQUEST['__template_files__']['modulo'] ) ) {
                $base = DIR_MOD . 
                    '_' . $_REQUEST['__template_files__']['modulo'] . 
                    '/_src/_tpl/_' . $_REQUEST['__templates__']['id'] . '/' . 
                    ( ( isset( $_REQUEST['__template_files__']['folder'] ) ) ? $_REQUEST['__template_files__']['folder'] : NULL ) .
                    '/' . $_REQUEST['__template_files__']['id'];
            } else {
                $base = '_src/_tpl/' . 
                    '_' . $_REQUEST['__templates__']['id'] . '/' . 
                    ( ( isset( $_REQUEST['__template_files__']['folder'] ) ) ? $_REQUEST['__template_files__']['folder'] : NULL ) .
                    '/' . $_REQUEST['__template_files__']['id'];
            }

            // debug
            // var_dump( $base );
            // var_dump( absolutePath( $base ) );

            // eliminazione doppi slash
            $base = str_replace( '//', '/', $base );

            // protezione dai tentativi di modifica di file esterni alla cartella template
            if( trim( absolutePath( $base ), '/' ) !== trim( $base , '/' ) ) {
                die( trim( absolutePath( $base ), '/' ) . ' !== ' . trim( $base , '/' ) );
            }

            // nome del file custom
            $custom = path2custom( $base );

            // debug
            // var_dump( $_REQUEST['__template_files__']['contenuto'] );
            // var_dump( $custom );
            // var_dump( file_exists( $custom ) );
            // die( 'custom: ' . $custom );

            // controllo cartella
            checkFolder( dirname($custom) );

            // scrittura
            if( isset( $_REQUEST['__template_files__']['contenuto'] ) && ! empty( trim( $_REQUEST['__template_files__']['contenuto'] ) ) ) {

                // debug
                // die( 'sul file: ' . $custom . ' scrivo: ' . $_REQUEST['__template_files__']['contenuto'] );

                // scrivo il contenuto della textarea nel file custom
                writeToFile( $_REQUEST['__template_files__']['contenuto'], $custom );

            } elseif( ! file_exists( getFullPath( $custom ) ) && file_exists( getFullPath( $base ) ) ) {

                // debug
                // die( 'creazione nuovo file da standard' );
                // die( $custom );

                // leggo il contenuto del file standard
                $standard = readFromFile( $base, FILE_READ_AS_STRING );

                // scrivo nel file custom il contenuto del file standard
                writeToFile( $standard, $custom );

            } elseif( ! file_exists( getFullPath( $custom ) ) ) {

                // debug
                // die( 'creazione nuovo file vuoto' );
                // die( $custom );

                // creo un nuovo file custom
                writeToFile( PHP_EOL, $custom );

            }

            // variabili per la lettura dei contenuti
            $ct['etc']['reading']['custom'] = '';
            $ct['etc']['reading']['base'] = '';
            $ct['etc']['fileread']['custom'] = '';
            $ct['etc']['fileread']['base'] = '';

            // cerco il contenuto custom e se non esiste prendo lo standard
            if( file_exists( getFullPath( $custom ) ) ) {

                // debug
                // die( $custom );
                // die( 'leggo dal file: ' . $custom );

                // leggo il contenuto del file custom
                $ct['etc']['reading']['custom'] = readFromFile( $custom, FILE_READ_AS_STRING );
                $ct['etc']['fileread']['custom'] = $custom;

            }

            if( file_exists( getFullPath( $base ) ) ) {

                // die( $base );
                // die( 'leggo dal file: ' . $base . ' perché ' . $custom . ' non esiste' );

                // leggo il contenuto del file standard
                $ct['etc']['reading']['base'] = readFromFile( $base, FILE_READ_AS_STRING );
                $ct['etc']['fileread']['base'] = $base;

            }

            // se il contenuto custom è vuoto uso lo standard
            if( empty( trim( $ct['etc']['reading']['custom'] ) ) ) {
                $ct['etc']['reading'] = $ct['etc']['reading']['base'];
                $ct['etc']['fileread'] = $ct['etc']['fileread']['base'];
            } else {
                $ct['etc']['reading'] = $ct['etc']['reading']['custom'];
                $ct['etc']['fileread'] = $ct['etc']['fileread']['custom'];
            }

            // imposto il contenuto per la textarea
            $_REQUEST['__template_files__']['contenuto'] = $ct['etc']['reading'];

        }

        // debug
        // die( 'ok' );

    }

    // debug
    // die( 'ok' );
