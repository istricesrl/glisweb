<?php

    /**
     * normalizzazione indirizzi manuali
     * 
     * questo task normalizza gli indirizzi inseriti manualmente nel formato
     * 
     * indirizzo | civico | localita | cap | comune | stato
     * 
     * oppure:
     * 
     * indirizzo | civico | localita | cap | comune | provincia | stato
     * 
     * ad esempio:
     * 
     * via Dalle Scatole | 231 | zona ind. Lavoro Sodo | 12345 | Chisslè | BO | IT
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array(
        'start' => date( 'Y-m-d H:i:s' )
    );

    // debug
    // die( print_r( $status, true ) );

    // ...
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE FROM anagrafica_indirizzi WHERE id_indirizzo IS NULL AND indirizzo IS NULL'
    );

    // trovo un indirizzo
    $status['row'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM anagrafica_indirizzi WHERE indirizzo IS NOT NULL AND id_anagrafica IS NOT NULL ORDER BY timestamp_elaborazione ASC LIMIT 1'
    );

    // scompongo l'indirizzo manuale
    $status['elementi'] = array_map( 'trim', explode( '|', $status['row']['indirizzo'] ) );

    // mappatura
    $status['valori']['indirizzo']      = $status['elementi'][0];
    $status['valori']['civico']         = $status['elementi'][1];
    $status['valori']['localita']       = $status['elementi'][2];
    $status['valori']['cap']            = $status['elementi'][3];
    $status['valori']['comune']         = $status['elementi'][4];

    // ...
    if( count( $status['elementi'] ) == 6 ) {

        $status['valori']['stato']      = $status['elementi'][5];

    } elseif( count( $status['elementi'] ) == 7 ) {

        $status['valori']['provincia']  = $status['elementi'][5];
        $status['valori']['stato']      = $status['elementi'][6];

    }

    // se lo stato è vuoto, metto default a IT
    if( empty( $status['valori']['stato'] ) ) {
        $status['valori']['stato'] = 'IT';
    }

    // cerco lo stato
    $status['trovati']['id_stato'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id FROM stati WHERE iso31661alpha2 = ? OR nome = ?',
        array( array( 's' => $status['valori']['stato'] ), array( 's' => $status['valori']['stato'] ) )
    );

    // cerco la provincia
    $status['trovati']['id_provincia'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id FROM provincie WHERE sigla = ? OR nome = ?',
        array( array( 's' => $status['valori']['provincia'] ), array( 's' => $status['valori']['provincia'] ) )
    );

    // ...
    $whr = 'SELECT regioni.id_stato, comuni.id_provincia, comuni.id, comuni.nome
        FROM comuni
            LEFT JOIN provincie ON provincie.id = comuni.id_provincia
            LEFT JOIN regioni ON regioni.id = provincie.id_regione
        WHERE comuni.nome = ? AND regioni.id_stato = ?';

    // ...
    $cnd = array( array( 's' => $status['valori']['comune'] ), array( 's' => $status['trovati']['id_stato'] ) );

    // ...
    if( ! empty( $status['trovati']['id_provincia'] ) ) {
        $whr .= ' AND comuni.id_provincia = ?';
        $cnd = array_merge(
            $cnd, array( 's' => $status['trovati']['id_provincia'] )
        );
    }

    // cerco i possibili comuni
    $status['trovati']['comuni'] = mysqlQuery( $cf['mysql']['connection'], $whr, $cnd );

	// disambigua comune
    if( count( $status['trovati']['comuni'] ) > 1 ) {

        $status['considerazioni'][ $indirizzo['id'] ][] = 'possibile ambiguità fra comuni';

        $status['trovati']['id_comune'] = $status['trovati']['comuni'][0]['id'];

    } else {

        $status['trovati']['id_comune'] = $status['trovati']['comuni'][0]['id'];

    }

    // ricerca indirizzi già esistenti
    $status['indirizzi'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT regioni.id_stato, comuni.id_provincia, indirizzi.*
        FROM anagrafica_indirizzi
            LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
            LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
            LEFT JOIN provincie ON provincie.id = comuni.id_provincia
            LEFT JOIN regioni ON regioni.id = provincie.id_regione
        WHERE anagrafica_indirizzi.id_anagrafica = ? 
            AND anagrafica_indirizzi.id_indirizzo IS NOT NULL ',
        array( array( 's' => $status['row']['id_anagrafica'] ) )
    );

    // ...
    $presente = false;

    // ...
    $sede = false;

    // controllo sovrapposizioni indirizzi
    foreach( $status['indirizzi'] as $indirizzo ) {

        if( $indirizzo['id_ruolo'] == 1 ) {
            $sede = true;
        }

        if( $indirizzo['id_stato'] == $status['trovati']['id_stato'] ) {
            $status['considerazioni'][ $indirizzo['id'] ][] = 'ID stato uguale';

            if( $indirizzo['id_comune'] == $status['trovati']['id_comune'] ) {
                $status['considerazioni'][ $indirizzo['id'] ][] = 'ID comune uguale';

                if( $indirizzo['localita'] == $status['valori']['localita'] ) {
                    $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo uguale';

                    if( $indirizzo['indirizzo'] == $status['valori']['indirizzo'] ) {
                        $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo uguale';

                        if( $indirizzo['civico'] == $status['valori']['civico'] ) {
                            $status['considerazioni'][ $indirizzo['id'] ][] = 'civico uguale';

                            $presente = true;

                        }

                    }

                }

            }

        }

    }

    // rimuovo l'indirizzo se è duplicato oppure lo inserisco se è nuovo
    if( $presente == true ) {

        $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo già presente in anagrafica, elimino il duplicato';

        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM anagrafica_indirizzi WHERE id = ?',
            array( array( 's' => $status['row']['id'] ) )
        );

    } elseif( ! empty( $status['trovati']['id_comune'] ) ) {

        $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo non presente in anagrafica, lo inserisco';

        $status['inserimenti']['id_indirizzo'] = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id_comune' => $status['trovati']['id_comune'],
                'indirizzo' => $status['valori']['indirizzo'],
                'civico' => $status['valori']['civico'],
                'localita' => $status['valori']['localita'],
                'cap' => $status['valori']['cap']
            ),
            'indirizzi',
            true,
            false,
            array(
                'id_comune',
                'localita',
                'indirizzo',
                'civico',
                'cap'
            )
        );

        if( ! empty( $status['row']['id_anagrafica'] ) ) {

            $status['inserimenti']['id_anagrafica_indirizzi'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_anagrafica' => $status['row']['id_anagrafica'],
                    'id_indirizzo' => $status['inserimenti']['id_indirizzo'],
                    'indirizzo' => NULL,
                    'timestamp_elaborazione' => time(),
                    'id_ruolo' => ( ( $sede === false ) ? 1 : NULL )
                ),
                'anagrafica_indirizzi'
            );
    
        } else {

            $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo non associabile per mancanza di anagrafica';

        }

    } else {

        $status['considerazioni'][ $indirizzo['id'] ][] = 'indirizzo non presente in anagrafica';
        $status['considerazioni'][ $indirizzo['id'] ][] = 'inserimento impossibile per mancanza di comune';

    }

    // modifico la timestamp di elaborazione
    $status['check']['id'] = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE anagrafica_indirizzi SET timestamp_elaborazione = ? WHERE id = ?',
        array( array( 's' => time() ), array( 's' => $status['row']['id'] ) )
    );

    // debug
    // die( print_r( $status, true ) );

    // log
    logWrite( print_r( $status, true ), 'details/indirizzi/' . $status['row']['id'], LOG_ERR );

    // log
    logWrite( $status['row']['indirizzo'] . ' gestito: ' . print_r( $status['considerazioni'], true ), 'indirizzi', LOG_ERR );

    // aggiornamento anagrafica_view_static
    updateAnagraficaViewStaticIndirizzi( $status['row']['id_anagrafica'] );

    // debug
    // die( print_r( $status, true ) );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
