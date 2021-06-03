<?php

    /**
     * il riempitore che gira ad es. ogni minuto e crea fisicamente gli oggetti. Questo prende le pianificazioni
     * che hanno data_fine > data_ultimo_oggetto e vede se ci sono oggetti da creare, li crea, aggiorna data_ultimo_oggetto
     * e pareggia data_fine = data_ultimo_oggetto > nome del task: _pianificazioni.populate.php
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

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

    // debug
	// $status['token'] = 'TEST';

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

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
            'WHERE ( timestamp_popolazione < ? OR timestamp_popolazione IS NULL ) '.
            'AND data_fine > ? '.
            'AND token IS NULL '.
			'AND data_inizio_pulizia IS NULL '.		// non deve leggere quelle chiamate dalla check
            'ORDER BY timestamp_popolazione ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => strtotime( '-1 day' ) ),
                array( 's' => date( 'Y-m-d' ) )
            )
        );

    }

    // prelevo una riga dalla coda
    $current = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT pianificazioni.*, '.
        'coalesce( id_todo, id_turno, id_progetto ) AS ref_id '.
        'FROM pianificazioni '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );
	

    // se c'è almeno una riga da inviare
    if( ! empty( $current ) ) {
		
	#	appendToFile( date('d-m-Y H:i') . ' lavoro la pianificazione ' . $current['id'] . PHP_EOL, 'ver/log/pianificazioni.populate.log');

        // prelevo la data dell'oggetto master
        $current['data_ultimo_oggetto'] = 
                max(
                    pianificazioniGetLatestObjectDate(
                        $current['id'],
                        $current['entita'],
                        $current['ref_id']
                    ),
                    $current['data_ultimo_oggetto']
                );

        if(  empty( $current['data_ultimo_oggetto'] ) ){
            $current['data_ultimo_oggetto'] = date( 'Y-m-d' );
        }

        // status
        $status['info'][] = 'popolo la pianificazione ' . $current['id'];

        // array dei giorni della settimana
        $giorni = array();
        if( $current['se_lunedi']       == 1 ) { $giorni[] = 0; }
        if( $current['se_martedi']      == 1 ) { $giorni[] = 1; }
        if( $current['se_mercoledi']    == 1 ) { $giorni[] = 2; }
        if( $current['se_giovedi']      == 1 ) { $giorni[] = 3; }
        if( $current['se_venerdi']      == 1 ) { $giorni[] = 4; }
        if( $current['se_sabato']       == 1 ) { $giorni[] = 5; }
        if( $current['se_domenica']     == 1 ) { $giorni[] = 6; }

    #    var_dump( $current['data_ultimo_oggetto'] );

        // chiamo la funzione creazionePianificazione() 
        $date = creazionePianificazione(
            $cf['mysql']['connection'],
            $current['data_ultimo_oggetto'],            // data da cui iniziare a pianificare (?)
            $current['periodicita'],                    // TODO perché questa colonna non si chiama id_periodicita e non esiste tipologie_periodicita
            $current['cadenza'],
            $current['data_fine'],
            1,                                          // perché non esiste questa colonna nella tabella pianificazioni?
            implode( ',', $giorni ),
            $current['ripetizione_mese'],
            $current['ripetizione_anno']
        );

    #    print_r( $date );
    
        $date = array_diff( $date, array( $current['data_ultimo_oggetto'] ) );

        // estraggo le statiche coinvolte nella creazione
        $status['statiche'] = pianificazioniGetStatic( $current['id'] );
		
		if( !empty( $status['statiche'] ) && !empty( $date ) ){
			// disattivo i trigger per le entità coinvolte e aggiungo l'entità alle statiche da ripopolare
            foreach( $status['statiche'] as $s ){
                triggerOff( $s, 'pianificazioni.populate' );
				$cf['cron']['cache']['view']['static']['refresh'][] = $s;
            }
        }

        // per ogni data...
        foreach( $date as $data ) {

            // status
            $status['info'][ $data ][] = 'inizio duplicazione';

            // decodifico il workspace
            $wksp = json_decode( $current['workspace'], true );

            $a = 1;

            if( !empty( $wksp['metadati']['pause'] ) ){
                
                // vado nell'oggetto genitore della pianificazione ed estraggo il valore del campo di match per la tabella di pausa
                $val = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT ' . $wksp['metadati']['pause']['campo'] . ' FROM ' . $current['entita'] . ' WHERE id = ?',
                    array(
                        array( 's' => $current['ref_id'] )
                    )
                );

                $status['info'][ $data ][] = 'cerco pause su tabella ' . $wksp['metadati']['pause']['tabella'] .', campo di match ' . $wksp['metadati']['pause']['campo'] . ', valore ' . $val;

                $a = seDataAttiva( $data, $wksp['metadati']['pause']['tabella'], $wksp['metadati']['pause']['campo'], $val );
            }

            $status['info'][ $data ]['attiva'] = $a;


            // solo se non ci sono pause o la data corrente non è nel periodo di pausa procedo con la duplicazione
            if( $a == 1 ){
                // array di match
                $matches = array();

                // faccio le sostituzioni nel workspace
                foreach( $wksp['sostituzioni'] as $ent => &$wks ) {
                    foreach( $wks as $field => &$value ) {
                        if( $value == '%data%' || $value == '§data§' ) {
                            $value = $data;
                        } elseif( $value == '%id_pianificazione%' || $value == '§id_pianificazione§' ) {
                            $value = $current['id'];
                        } elseif( preg_match_all( '/%data\+([0-9]+)%/', $value, $matches ) ) {
                            $value = date( 'Y-m-d', strtotime( '+' . $matches[1][0] . ' days', strtotime( $data ) ) );
                        } elseif( $value == '§ref_id+data§'){
                            $value = $current['ref_id'] . '-' . date( 'Ymd', strtotime( $data ) );
                        } elseif( $value == '%null%'){
                            $value = NULL;
                        }
                    }
                }

                $status['info']['sostituzioni'] = $wksp['sostituzioni'];

                // chiamo la funzione mysqlDuplicateRowRecursive()
                mysqlDuplicateRowRecursive(
                    $cf['mysql']['connection'],
                    $current['entita'],
                    $current['ref_id'],
                    NULL,
                    $wksp['sostituzioni']
                );

                // status
                $status['info'][ $data ][] = 'chiamata duplicazione ricorsiva per '.$current['entita'].' #'.$current['ref_id'];

                // aggiorno la data dell'ultimo oggetto
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_ultimo_oggetto = ? WHERE token = ?',
                    array(
                        array( 's' => $data ),
                        array( 's' => $status['token'] )
                    )
                );

            }

        }

        // rilascio il token
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = NULL, timestamp_popolazione = ? WHERE token = ?',
            array(
                array( 's' => time() ),
                array( 's' => $status['token'] )
            )
        );       
		

    } else {

        // status
        $status['info'][] = 'nessuna pianificazione da popolare';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
