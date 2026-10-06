<?php

    /**
     * geolocalizzazione della tabella anagrafica_indirizzi
     *
     * Questo task geolocalizza una riga di `anagrafica_indirizzi` a ogni chiamata, con lo stesso schema a token del
     * gemello `_indirizzi.geocode.php`: la riga porta in linea i suoi campi e il suo blocco di geolocalizzazione, e
     * `id_indirizzo` è solo il ponte facoltativo verso la geografia ( decisione del 06/10/2026 sullo schema canonico ).
     * Il CAP restituito dal servizio si scrive solo se la riga non ne ha uno: il dato inserito dall'utente prevale.
     * Con `id=<id>` geolocalizza la riga indicata. Senza un servizio configurato non fa nulla.
     *
     * NOTA richiede le colonne `token`, `timestamp_geolocalizzazione` e `note_geolocalizzazione` su
     * `anagrafica_indirizzi`, introdotte dalla revisione canonica dello schema.
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ANAGRAFICA' );

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio operazioni di geocode';

    // chiave di lock
	if( ! isset( $status['token'] ) ) {
	    $status['token'] = getToken( __FILE__ );
	}

    // senza un servizio configurato non c'è niente da fare
    if( empty( $cf['mapquest']['server']['key'] ) ) {

        // status
        $status['info'][] = 'nessun servizio di geolocalizzazione configurato';

    } elseif( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica_indirizzi SET token = ? WHERE id = ?',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica_indirizzi SET token = ? WHERE ( latitudine IS NULL OR longitudine IS NULL OR cap IS NULL ) '.
            'AND ( timestamp_geolocalizzazione IS NULL OR timestamp_aggiornamento IS NULL OR timestamp_aggiornamento > timestamp_geolocalizzazione ) '.
            'AND token IS NULL '.
            'ORDER BY timestamp_geolocalizzazione ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

    }

    // prelevo un indirizzo dalla coda
    $geocode = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT anagrafica_indirizzi.*, '.
        'comuni.id_provincia, '.
        'provincie.sigla, '.
        'comuni.nome AS comune, '.
        'stati.iso31661alpha2 AS sigla_stato, '.
        'stati.nome AS stato '.
        'FROM anagrafica_indirizzi '.
        'LEFT JOIN comuni ON comuni.id = anagrafica_indirizzi.id_comune '.
        'LEFT JOIN provincie ON provincie.id = comuni.id_provincia '.
        'LEFT JOIN regioni ON regioni.id = provincie.id_regione '.
        'LEFT JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE anagrafica_indirizzi.token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // debug
    // echo 'indirizzo: ' . print_r( $geocode, true );
    // die( print_r( $geocode ) );

    // se c'è almeno una geocode da inviare
    if( ! empty( $geocode ) ) {

        // status
        $status['indirizzo'] = $geocode;

        // TODO analizzo il campo località per stringhe tipo "- NOMESTATO"

        // geolocalizzazione
        $gc = mapquestGetCachedCoords(
            $cf['memcache']['connection'],
            $cf['mapquest']['server']['key'],
            $geocode['civico'],
            $geocode['indirizzo'],
            $geocode['comune'],
            $geocode['cap'],
            $geocode['stato']
        );

        // debug
        // print_r( $gc );

        // controllo l'esito dell'invio
        // TODO gestire il caso in cui l'API non restituisca risultati utili
        // NOTA il meccanismo deve essere in grado di ritardare i tentativi successivi in modo da non bloccare la coda
        if( ! empty( $gc ) ) {

            // log
            appendToFile(
                '-- ' . date( 'Y-m-d H:i' ) . PHP_EOL . print_r( $geocode, true ) . PHP_EOL . print_r( $gc, true ),
                'var/log/geocode/' . string2rewrite( implode( ' ', array(
                    $geocode['stato'],
                    $geocode['comune'],
                    $geocode['indirizzo'],
                    $geocode['civico']
                ) ) ) . '.log'
            );

            // aggiornamento database
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE anagrafica_indirizzi '.
                'SET latitudine = ?, longitudine = ?, cap = coalesce( cap, ? ), timestamp_geolocalizzazione = unix_timestamp(), '.
                'timestamp_aggiornamento = unix_timestamp(), token = NULL '.
                'WHERE token = ?',
                array(
                array( 'd' => $gc['lat'] ),
                array( 'd' => $gc['lng'] ),
                array( 's' => $gc['cap'] ),
                array( 's' => $status['token'] )
                )
            );

            // die( print_r( $gc, true ) );

            // output
            $status['result'] = $gc;

/*
            // se l'indirizzo non ha zona
            if( empty( $geocode['id_zona'] ) ) {

                $idZona = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_zona FROM zone_cap WHERE cap = ?', array( array( 's' => $gc['cap'] ) ) );

                if( ! empty( $idZona ) ) {
                mysqlQuery( $cf['mysql']['connection'], 'UPDATE anagrafica_indirizzi SET id_zona = ? WHERE token = ?', array( array( 's' => $idZona ), array( 's' => $status['token'] ) ) );
                }

            }
*/
            // log
            logWrite( 'salvataggio della geolocalizzazione completato', 'geocode' );

        } else {

            // aggiornamento database
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE anagrafica_indirizzi SET timestamp_geolocalizzazione = unix_timestamp() WHERE token = ?',
                array(
                    array( 's' => $status['token'] )
                )
            );

        }

    } else {

        // status
        $status['info'][] = 'nessun indirizzo da geolocalizzare';

        // log
        logWrite( 'nessun indirizzo in coda da geolocalizzare', 'geocode' );

    }

    // TODO
    // qui fare l'invio con geocode_send()
    // NOTA la variabile $geocode è ancora valorizzata

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
