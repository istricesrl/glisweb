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
            'AND ( ( ? BETWEEN data_avvio AND data_fine ) OR ( data_avvio <= ? AND data_fine IS NULL ) )'.
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
                $start = $last = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT max( data ) FROM documenti WHERE id_pianificazione = ?', array( array( 's' => $current['id'] ) ) );
            break;
        }

        // data di partenza di default
        if( ! isset( $start ) || empty( $start ) ) {
            $start = $current['data_inizio'];
            $status['info'][] = 'nessun oggetto trovato per questa pianificazione, inizio dal ' . $start;
        }

        // status
        $status['info'][] = 'elaboro per ' . $current['giorni_elaborazione'] . ' giorni ';

        // fine della finestra di lavoro
        $stop = date( 'Y-m-d', strtotime( ' +' . $current['giorni_elaborazione'] . ' days' ) );

        // aggiusto la finestra di lavoro
        if( ! empty( $current['data_fine'] ) ) {
            if( $stop > $current['data_fine'] ) {
                $status['info'][] = 'la data di fine lavoro ' . $stop . ' eccede la data di fine pianificazione ' . $current['data_fine'];
                if( ! empty( $current['giorni_estensione'] ) ) {
                    $status['info'][] = 'estendo la data di fine pianificazione ' . $current['data_fine'] . ' di ' . $current['giorni_estensione'] . ' giorni';
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
        } else {
            $status['info'][] = 'la pianificazione non ha una data di fine impostata';
        }

        // status
        if( isset( $last ) ) {
            $status['info'][] = 'data ultimo oggetto generato ' . $last;
            $status['info'][] = 'inizio dal ' . $last . ' e finisco il ' . $stop;
        } else {
            $status['info'][] = 'nessun oggetto già generato, inizio dal ' . $last . ' e finisco il ' . $stop;
        }

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
            $start,                          // data da cui iniziare a pianificare
            $current['id_periodicita'],     // tipo di pianificazione
            $current['cadenza'],            // ogni quante unità di tempo pianificare (ad es. mensile cadenza 2 = ogni due mesi)
            $stop,                          // data fino alla quale pianificare
            1,                              // ???
            implode( ',', $giorni )         // giorni nei quali pianificare
        );

        // elimino la data relativa all'ultimo oggetto creato
        $date = array_diff(
            $date,
            array( $last )
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

                    // creo il documento
                    $object = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia'              => $current['model_id_tipologia'],
                            'numero'                    => $numero,
                            'sezionale'                 => $sezionale,
                            'nome'                      => $nome,
                            'data'                      => $data,
                            'id_emittente'              => $current['model_id_emittente'],
                            'id_destinatario'           => $current['model_id_destinatario'],
                            'id_condizione_pagamento'   => $current['model_id_condizione_pagamento'],
                            'esigibilita'               => $current['model_esigibilita'],
                            'note_cliente'              => $current['model_note_cliente'],
                            'id_pianificazione'         => $current['id']
                        ),
                        $current['entita']
                    );

                    // status
                    $status['dettagli'][ $data ][] = 'ID: ' . $object;
                    $status['dettagli'][ $data ][] = 'numero: ' . $numero;
                    $status['dettagli'][ $data ][] = 'sezionale: ' . $sezionale;
                    $status['dettagli'][ $data ][] = 'nome: ' . $nome;

                break;
            }

            // trovo gli oggetti collegati di tipo documenti_articoli
            $rows = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM pianificazioni WHERE entita = ? AND id_genitore = ?',
                array(
                    array( 's' => 'documenti_articoli' ),
                    array( 's' => $current['id'] )
                )
            );

            // totale articoli
            $d['dt']['articoli']['totale'] = 0;

            // creo gli oggetti collegati di tipo documenti_articoli
            foreach( $rows as $row ) {

                $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $row ) );
                $nome = $twig->render( 'model_nome', $d );

                $row['model_importo_netto_totale'] = str_replace( ',', '.', $row['model_importo_netto_totale'] );

                $detail = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_documento'                  => $object,
                        'nome'                          => $nome,
                        'quantita'                      => $row['model_quantita'],
                        'id_udm'                        => $row['model_id_udm'],
                        'id_articolo'                   => $row['model_id_articolo'],
                        'importo_netto_totale'          => $row['model_importo_netto_totale'],
                        'id_reparto'                    => $row['model_id_reparto'],
                        'id_listino'                    => $row['model_id_listino'],
                        'id_pianificazione'             => $current['id']
                    ),
                    'documenti_articoli'
                );

                $aliquota = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT aliquota FROM iva INNER JOIN reparti ON reparti.id_iva = iva.id WHERE reparti.id = ?',
                    array(
                        array( 's' => $row['model_id_reparto'] )
                    )
                );

                $d['dt']['articoli']['totale'] += $row['model_importo_netto_totale'] * ( 1 + ( $aliquota / 100 ) );

            }

            // da virgola a punto
            $d['dt']['articoli']['totale'] = str_replace( ',', '.', $d['dt']['articoli']['totale'] );

            // status
            $status['dettagli'][ $data ][] = 'totale articoli: ' . $d['dt']['articoli']['totale'];

            // trovo gli oggetti collegati di tipo pagamenti
            $rows = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM pianificazioni WHERE entita = ? AND id_genitore = ?',
                array(
                    array( 's' => 'pagamenti' ),
                    array( 's' => $current['id'] )
                )
            );

            // creo gli oggetti collegati di tipo documenti_articoli
            foreach( $rows as $row ) {

                $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $row ) );
                $importo_lordo_totale = $twig->render( 'model_importo_lordo_totale', $d );
                $nome = $twig->render( 'model_nome', $d );
                $scadenza = $data . ' 00:00:00';

                if( ! empty( $row['offset_giorni'] ) ) {
                    $mesi = floor( $row['offset_giorni'] / 30 );
                    $giorni = $row['offset_giorni'] - ( $mesi * 30 );
                    $scadenza .= ' +' . $mesi . ' months +' . $giorni . ' days';
                    $status['dettagli'][ $data ][] = 'pagamento differito: '.$scadenza;
                }

                if( ! empty( $row['offset_fine_mese'] ) ) {
                    $scadenza = date( 'Y-m-t H:m:s', strtotime( $scadenza ) );
                    $status['dettagli'][ $data ][] = 'pagamento differito a fine mese: '.$scadenza;
                }

                $timestamp_scadenza = strtotime( $scadenza );

                $detail = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_documento'                  => $object,
                        'nome'                          => $nome,
                        'id_modalita_pagamento'         => $row['model_id_modalita_pagamento'],
                        'importo_lordo_totale'          => $importo_lordo_totale,
                        'id_listino'                    => $row['model_id_listino'],
                        'timestamp_scadenza'            => $timestamp_scadenza,
                        'id_pianificazione'             => $current['id']
                    ),
                    'pagamenti'
                );

                // status
                $status['dettagli'][ $data ][] = 'importo pagamento #'.$detail.': ' . $importo_lordo_totale;

            }

            // TODO includo le macro della pianificazione
            // ...

        }

        // log
        appendToFile( print_r( $status, true ), DIR_VAR_LOG_PIANIFICAZIONI . $current['id'] . '.log' );

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
