<?php

    /**
     * il riempitore che gira ad es. ogni minuto e crea fisicamente gli oggetti
     *
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio evasione pianificazioni';

    // log
	logWrite( 'richiesta di elaborazione delle pianificazioni', 'pianificazioni' );

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

    // debug
	// $status['token'] = 'TEST';

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifica pianificazione';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ? '.
            'WHERE ( timestamp_elaborazione < ? OR timestamp_elaborazione IS NULL OR timestamp_aggiornamento > timestamp_elaborazione ) '.
            'AND ( ( ? BETWEEN data_inizio AND data_fine ) OR ( data_inizio <= ? AND data_fine IS NULL ) )'.
            'AND token IS NULL '.
            'AND id_genitore IS NULL '.
            'ORDER BY timestamp_elaborazione ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => strtotime( '-1 day' ) ),
                array( 's' => date( 'Y-m-d' ) ),
                array( 's' => date( 'Y-m-d' ) )
            )
        );

    }

    // prelevo una riga dalla coda
    $current = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT pianificazioni.* '.
//        'coalesce( id_todo, id_turno, id_progetto ) AS ref_id '.
        'FROM pianificazioni '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // TODO
    // $current['entita'] = pianificazioniGetMatchEntityName( $current['id'] );

    // se c'è almeno una riga da inviare
    if( ! empty( $current ) ) {

        // debug
        // die( print_r( $current, true ) );

        // se la data_fine è vuota, ricavo la data di fine dalla durata dell'oggetto collegato
        if( empty( $current['data_fine'] ) ) {
            if( ! empty( $current['id_contratto'] ) ) {

            } elseif( ! empty( $current['id_progetto'] ) ) {

            } elseif( ! empty( $current['id_todo'] ) ) {

            }
        }

        // status
        $status['info'][] = 'elaboro la pianificazione #' . $current['id'];
        $status['info'][] = 'tipo oggetto ' . $current['entita'];

        // trovo la data dell'ultimo oggetto creato per la pianificazione corrente
        switch( $current['entita'] ) {
            case 'documenti':
                $last = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT max( data ) FROM documenti WHERE id_pianificazione = ?', array( array( 's' => $status['token'] ) ) );
            break;
        }

        // data di partenza di default
        if( ! isset( $last ) || empty( $last ) ) {
            $last = date('Y-m-d');
        }

        // fine della finestra di lavoro
        $stop = date( 'Y-m-d', strtotime( $last . ' + ' . $current['giorni_elaborazione'] . ' days' ) );

        // aggiusto la finestra di lavoro
        if( $stop > $current['data_fine'] ) {
            if( ! empty( $current['giorni_estensione'] ) ) {
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_fine = ? WHERE token = ?',
                    array(
                        array( 's' => strtotime( $current['data_fine'].'+'.$current['giorni_estensione'].'days' ) ),
                        array( 's' => $status['token'] )
                    )
                );
            } else {
                $stop = $current['data_fine'];
            }
        }

        // status
        $status['info'][] = 'inizio dal ' . $last . ' e finisco il ' . $stop;

        // array dei giorni della settimana
        $giorni = array();

        // giorni di pianificazione
        if( $current['se_lunedi']       == 1 ) { $giorni[] = 0; }
        if( $current['se_martedi']      == 1 ) { $giorni[] = 1; }
        if( $current['se_mercoledi']    == 1 ) { $giorni[] = 2; }
        if( $current['se_giovedi']      == 1 ) { $giorni[] = 3; }
        if( $current['se_venerdi']      == 1 ) { $giorni[] = 4; }
        if( $current['se_sabato']       == 1 ) { $giorni[] = 5; }
        if( $current['se_domenica']     == 1 ) { $giorni[] = 6; }

        // debug
        // die( print_r( $giorni, true ) );
        // die( print_r( $status ) );

        // trovo le date in cui creare i prossimi oggetti 
        $date = creazionePianificazione(
            $last,                          // data da cui iniziare a pianificare
            $current['id_periodicita'],     // tipo di pianificazione
            $current['cadenza'],            // ogni quante unità di tempo pianificare (ad es. mensile cadenza 2 = ogni due mesi)
            $stop,                          // data fino alla quale pianificare
            1,                              // ???
            implode( ',', $giorni )         // giorni nei quali pianificare
        );

        // status
        $status['date'] = $date;

        // debug
        // die( print_r( $date, true ) );

        // TODO recupero le macro della pianificazione
        // ...

        // per ogni data individuata, creo un oggetto
        foreach( $date as $data ) {

            // dati per le sostituzioni
            $d = array(
                'dt' => array(
                    'now' => array(
                        'giorno' => date( 'd', strtotime( $data ) ),
                        'nome_giorno' => strftime( '%A', strtotime( $data ) ),
                        'mese' => date( 'm', strtotime( $data ) ),
                        'nome_mese' => strftime( '%B', strtotime( $data ) ),
                        'anno' => date( 'Y', strtotime( $data ) )
                    )
                )
            );

            // status
            $status['dettagli'][ $data ][] = 'inizio operazioni creazione oggetto';

            // considero il model come un template
			$twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $current ) );

            // creo l'oggetto
            switch( $current['entita'] ) {
                case 'documenti':
    
                    // render dei campi
                    $sezionale = $twig->render( 'model_sezionale', $d );
                    $nome = $twig->render( 'model_nome', $d );

                    // ricavo il numero del documento
                    $numero = generaProssimoNumeroDocumento(
                        $current['model_id_tipologia'],
                        $sezionale,
                        $current['model_id_emittente']
                    );

                    // status
                    $status['dettagli'][ $data ][] = 'numero: ' . $numero;
                    $status['dettagli'][ $data ][] = 'sezionale: ' . $sezionale;
                    $status['dettagli'][ $data ][] = 'nome: ' . $nome;

                break;
            }

            // TODO trovo gli oggetti collegati

            // TODO creo gli oggetti collegati

            // TODO includo le macro della pianificazione
            // ...

        }

        // rilascio il token
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = NULL, timestamp_elaborazione = ? WHERE token = ?',
            array(
                array( 's' => time() ),
                array( 's' => $status['token'] )
            )
        );       

    } else {

        // status
        $status['info'][] = 'nessuna pianificazione da elaborare';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
