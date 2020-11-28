<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio operazioni di geocode';

    // chiave di lock
	$status['token'] = getToken();

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE indirizzi SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE indirizzi SET token = ? WHERE ( latitudine IS NULL OR longitudine IS NULL OR cap IS NULL ) '.
            'AND ( timestamp_geocode IS NULL OR timestamp_geocode < ? OR timestamp_aggiornamento > timestamp_geocode ) '.
            'AND token IS NULL '.
            'ORDER BY timestamp_geocode ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => strtotime( '-3 months' ) )
            )
        );

    }

    // prelevo un indirizzo dalla coda
    $geocode = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT indirizzi.*, '.
        'comuni.id_provincia, '.
        'provincie.sigla, '.
        'comuni.nome AS comune, '.
        'stati.iso31661alpha2 AS sigla_stato, '.
        'stati.nome AS stato '.
        'FROM indirizzi '.
        'LEFT JOIN comuni ON comuni.id = indirizzi.id_comune '.
        'LEFT JOIN provincie ON provincie.id = comuni.id_provincia '.
        'LEFT JOIN regioni ON regioni.id = provincie.id_regione '.
        'LEFT JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // debug
    // echo 'indirizzo: ' . print_r( $geocode, true );

    // se c'è almeno una geocode da inviare
    if( ! empty( $geocode ) ) {

        // status
        $status['indirizzo'] = $geocode;

        // geolocalizzazione
        $gc = mapquestGetCachedCoords(
            $cf['memcache']['connection'],
            $cf['mapquest']['server']['key'],
            $geocode['civico'],
            $geocode['indirizzo'],
            $geocode['comune'],
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
                print_r( $geocode, true ) . PHP_EOL . print_r( $gc, true ),
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
                'UPDATE indirizzi '.
                'SET latitudine = ?, longitudine = ?, cap = ?, timestamp_geocode = unix_timestamp() token = NULL '.
                'WHERE token = ?',
                array(
                array( 'd' => $gc['lat'] ),
                array( 'd' => $gc['lng'] ),
                array( 's' => $gc['cap'] ),
                array( 's' => $status['token'] )
                )
            );

            // output
            $status['result'] = $gc;

/*
            // se l'indirizzo non ha zona
            if( empty( $geocode['id_zona'] ) ) {

                $idZona = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_zona FROM zone_cap WHERE cap = ?', array( array( 's' => $gc['cap'] ) ) );

                if( ! empty( $idZona ) ) {
                mysqlQuery( $cf['mysql']['connection'], 'UPDATE indirizzi SET id_zona = ? WHERE id = ?', array( array( 's' => $idZona ), array( 's' => $geocode['id'] ) ) );
                }

            }
*/
            // log
            logWrite( 'salvataggio della geolocalizzazione completato', 'geocode' );

        } else {

            // aggiornamento database
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE indirizzi SET timestamp_geocode = unix_timestamp() WHERE token = ?',
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
