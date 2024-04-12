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
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

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

    // TODO
    // $current['entita'] = pianificazioniGetMatchEntityName( $current['id'] );

    // se c'è almeno una riga da inviare
    if( ! empty( $current ) ) {

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
    
        $date = array_diff( $date, array( $current['data_ultimo_oggetto'] ) );

        // per ogni data...
        foreach( $date as $data ) {

            // status
            $status['info'][ $data ][] = 'inizio duplicazione';

            // decodifico il workspace
            $wksp = json_decode( $current['workspace'], true );

            $a = 1;

            /* NOTA
            L'array pause definisce il comportamento in caso di pause per l'oggetto da duplicare. 
            Ad esempio se un progetto è in pausa, presumibilmente non si dovranno duplicare le to-do e attività figlie.
            Sarà tuttavia possibile indicare di procedere con la duplicazione, eventualmente saltando alcune entità
            L'array pause potrebbe essere costituito come segue (esempio relativo alla duplicazione di una to-do figlia di un progetto con pause).

            'pause' => array(
                    'tabella' => 'pause_progetti',
                    'campo' => 'id_progetto',
                    'strategia' => array(
                        'duplica' => true,
                        'escludi' => array('attivita')
                    )
                )

            La chiave "strategia" contiene le due chiavi seguenti:
            - duplica: settato a "false" se non bisogna duplicare, altrimenti a "true"
            - escludi: contiene l'elenco delle tabelle da non duplicare, nell'esempio la populate duplicherà solo le to-do e non le attività figlie

            */

            // verifico se ci sono pause e se è necessario duplicare o meno
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

                $status['info'][ $data ]['attiva'] = $a;

                // se la data è attiva duplico l'oggetto
                if( $a == 1 ){
                    $duplica = true;
                }
                // se la data non è attiva ma la strategia indica di duplicare, verifico gli eventuali oggetti da escludere
                elseif( $a == 0 && $wksp['metadati']['pause']['strategia']['duplica'] === true ){
                    $status['info'][ $data ][] = 'data non attiva ma richiesta duplicazione';
                    $duplica = true;
                    if( isset( $wksp['metadati']['pause']['strategia']['escludi'] ) ){
                        // rimuovo le chiavi dell'array 'escludi' dalle tabelle da duplicare
                        foreach( $wksp['metadati']['pause']['strategia']['escludi'] as $e ){
                            unset( $wksp['sostituzioni'][ $e ] );
                        }
                    }
                }
                else{
                    $duplica = false;
                }
            }
            // se non ci sono pause da considerare, procedo con la duplicazione
            else{
                $duplica = true;
            }


            // procedo con la duplicazione
            if( $duplica === true ){
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

            #    $status['info'][$data]['sostituzioni'] = $wksp['sostituzioni'];

                // TODO
                // check se la data è 

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

        // estraggo le statiche coinvolte nella creazione
        $status['statiche'] = pianificazioniGetStatic( $current['id'] );
		
		if( !empty( $status['statiche'] ) && !empty( $date ) ){
            
			// inserisco una richiesta di ripopolamento delle statiche
            foreach( $status['statiche'] as $s ){
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
                    array(
                        array( 's' => $s ),
                        array( 's' => '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.populate.php'),
                        array( 's' => time() )
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
