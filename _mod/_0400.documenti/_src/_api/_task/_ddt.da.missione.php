<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // se è passato un ID documento
    if( isset( $_REQUEST['missione'] ) ) {

        // status
        $status['info'][] = 'ID missione: ' . $_REQUEST['missione'];

        // seleziono le righe della missione
        $status['missione']['righe'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM documenti_articoli WHERE id_missione = ? AND id_documento IS NOT NULL',
            array(
                array( 's' => $_REQUEST['missione'] )
            )
        );

        // per ogni riga della missione...
        foreach( $status['missione']['righe'] as &$riga ) {

            // seleziono l'ordine originale della riga
            $riga['ordine'] = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM documenti WHERE id = ?',
                array(
                    array( 's' => $riga['id_documento'] )
                )
            );

            // verifico se c'è un DDT associato come evasione al documento di questa riga
            $riga['ddt'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM relazioni_documenti WHERE id_documento = ? AND id_ruolo = 3',
                array(
                    array( 's' => $riga['id_documento'] )
                )
            );

            // se non c'è un DDT associato, lo creo
            if( empty( $riga['ddt'] ) ) {

                // status
                $status['info'][] = 'creo DDT per il documento ' . $riga['id_documento'];

                // creo il DDT
                $idDocumento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'codice' => 'DDT-' . $riga['ordine']['codice'],
                        'id_tipologia' => 4,
                        'id_emittente' => trovaIdAziendaGestita(),
                        'id_destinatario' => $riga['ordine']['id_emittente'],
                        'data' => date('Y-m-d'),
                        'nome' => 'DDT generato automaticamente da missione ' . $riga['id_missione'] . ' per ordine ' . $riga['ordine']['codice'] . ' il ' . date('Y-m-d H:i:s'),
                    ),
                    'documenti'
                );

                // inserisco le relazioni per il DDT appena creato
                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_documento' => $idDocumento,
                        'id_documento_collegato' => $_REQUEST['missione'],
                        'id_ruolo' => 3
                    ),
                    'relazioni_documenti'
                );

                // TODO ma questa che relazione è?!?
                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_documento' => $idDocumento,
                        'id_documento_collegato' => $riga['id_documento'],
                        'id_ruolo' => 3
                    ),
                    'relazioni_documenti'
                );

            } else {

                // status
                $status['info'][] = 'trovato DDT #' . $riga['ddt'][0]['id_documento_collegato'] . ' per il documento ' . $riga['id_documento'];

                // ...
                $idDocumento = $riga['ddt'][0]['id_documento_collegato'];

            }

            // aggiungo la riga al DDT
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'codice' => 'DDT-R-'.$riga['codice'],
                    'id_documento' => $idDocumento,
                    'quantita' => $riga['quantita'],
                    'id_articolo' => $riga['id_articolo'],
                    'id_tipologia' => 4,
                    'note' => 'riga generata automaticamente da missione ' . $riga['id_missione'] . ' per ordine ' . $riga['ordine']['codice'] . ' il ' . date('Y-m-d H:i:s'),
                ),
                'documenti_articoli'
            );

        }

    } else {

        // status
        $status['err'][] = 'ID missione non passato';

    }

    // debug
    // die( print_r( $status, true ) );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
