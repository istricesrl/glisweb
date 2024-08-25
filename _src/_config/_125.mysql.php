<?php

    /**
     * connessioni MySQL
     *
     * In questo file vengono effettuate le connessioni ai server MySQL configurati.
     *
     *
     *
     *
     *
     *
     */

    // debug
    // die( $cf['site']['status'] );
    // die( print_r( $cf['mysql'], true ) );
    // ini_set('display_startup_errors', 1);
    // ini_set('display_errors', 1);
    // error_reporting(-1);

    // configurazione extra
    if( isset( $cx['mysql'] ) ) {
        $cf['mysql'] = array_replace_recursive( $cf['mysql'], $cx['mysql'] );
    }

    // collegamento all'array $ct
    $ct['mysql']                        = &$cf['mysql'];

    // link alla connessione corrente
    $cf['mysql']['connection']          = NULL;

    // link al profilo corrente
    $cf['mysql']['profile']             = &$cf['mysql']['profiles'][ SITE_STATUS ];

    /**
     * connessione ai server
     * 
     * il codice seguente si occupa specificamente di effettuare la connessione a tutti i server
     * impostati per il profilo corrente, riportati in $cf['mysql']['profile']['servers'].
     * 
     */

    // verifico che sia presente alemno un server
    if( isset( $cf['mysql']['profile']['servers'] ) ) {

        // verifico che l'elenco dei server sia un array
        if( is_array( $cf['mysql']['profile']['servers'] ) ) {

            // verifico che sia presente almeno un server
            if( count( $cf['mysql']['profile']['servers'] ) > 0 ) {

                // log
                logger( 'server trovati: ' . implode( ',', $cf['mysql']['profile']['servers'] ), 'mysql' );

                // timeout delle connessioni MySQL
                ini_set( 'mysql.connect_timeout', 6 );

                // ciclo sui server attivi per lo stato corrente
                foreach( $cf['mysql']['profile']['servers'] as $server ) {

                    // log
                    logger( 'tento la connessione a: ' . $server, 'mysql' );

                    // inizializzo la connessione
                    $cn = mysqli_init();

                    // riduco il tempo massimo di connessione per evitare rallentamenti
                    mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 3 );

                    // connessione
                    mysqli_real_connect(
                        $cn,
                        $cf['mysql']['servers'][ $server ]['address'],
                        $cf['mysql']['servers'][ $server ]['username'],
                        $cf['mysql']['servers'][ $server ]['password']
                    );

                    // character set
                    mysqli_set_charset( $cn, 'utf8' );

                    // controllo errori
                    if( mysqli_connect_errno() ) {

                        // log
                        logger( 'errore di connessione a ' . $server . ': ' . mysqli_connect_errno() . ' ' . mysqli_connect_error(), 'mysql', LOG_ERR );

                    } else {

                        // versione del server
                        $cf['mysql']['servers'][ $server ]['version'] = mysqli_get_server_info( $cn );

                        // selezione database
                        try{

                            // seleziono il database
                            mysqli_select_db( $cn, $cf['mysql']['servers'][ $server ]['db'] );

                            // log
                            logger( 'database selezionato: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql' );

                        } catch( \Exception $e ) {

                            // log
                            logger( 'impossibile selezionare il database: ' . $cf['mysql']['servers'][ $server ]['db'], 'mysql', LOG_CRIT );

                            // ...
                            die( 'Impossibile selezionare il database '. $e->getMessage() );

                        }

                        // collation
                        mysqlQuery( $cn, 'SET collation_connection = utf8_general_ci' );

                        // timezone
                        try {

                            // setto la timezone
                            mysqlQuery( $cn, 'SET time_zone = ?', array( array( 's' => $cf['localization']['timezone']['name'] ) ) );

                        } catch (mysqli_sql_exception $e) {

                            // ...
                            die( 'timezone MySQL non installate, usa il comando: mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql' );

                        }                    

                        // localizzazione
                        mysqlQuery( $cn, 'SET lc_time_names = ?', array( array( 's' => str_replace( '-', '_', $cf['localization']['language']['ietf'] ) ) ) );

                        // modalità SQL
                        // mysqlQuery( $cn, 'SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,"ONLY_FULL_GROUP_BY",""));' );

                        // log
                        logger( 'connessione stabilita: ' . $server, 'mysql' );
                        logger( 'dettagli: ' . mysqli_get_host_info( $cn ), 'mysql' );

                        // aggiungo la connessione all'array
                        $cf['mysql']['connections'][ $server ] = $cn;

                    }

                    // debug
                    // die();

                }

                // connessione di default
                if( count( $cf['mysql']['connections'] ) ) {
                    $keys = array_keys( $cf['mysql']['connections'] );
                    $key = array_shift( $keys );
                    $cf['mysql']['connection'] = &$cf['mysql']['connections'][ $key ];
                    $cf['mysql']['server'] = &$cf['mysql']['servers'][ $key ];
                }

                // log
                logger( 'connessione di default: ' . $key, 'mysql');

            } else {

                // log
                logger( 'nessun server MySQL impostato per ' . SITE_STATUS, 'mysql' );

            }

        } else {

            // log
            logger( 'array dei server non configurato', 'mysql' );

        }

    } else {

        // log
        logger( 'backend MySQL non configurato', 'mysql' );

    }

    // debug
    // print_r( $cf['mysql']['profile'] );
    // print_r( $cf['mysql']['connections'] );
    // print_r( $cf['mysql'] );
    // die();
