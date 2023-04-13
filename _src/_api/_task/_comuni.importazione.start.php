<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
    $status['link'] = 'https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-italiani.xls';
    $status['file'] = 'tmp/comuni.xls';
    $status['key'] = 'JOB'.time().'DATA';

    // elimino eventuali vecchie versioni del file
    deleteFile( $status['file'] );

    // scarico l'XLS
    copyFile( $status['link'], $status['file'] );

    // controllo che il file esista
    if( file_exists( DIR_BASE . $status['file'] ) ) {

        // controllo che sia presente una connessione a memcache
        if( ! empty( $cf['memcache']['connection'] ) ) {

            //ridefinisco i nomi delle colonne, quindi il primo elemento dell'array di stringhe/righe
            $heads = array(
                'codice_istat_regione',			    // A
                'codice_istat_provincia',		    // B
                'codice_provincia_storico',		    // C
                'progressivo_comune',		    	// D
                'codice_istat_comune',			    // E
                'denominazione_ita_stra',		    // F
                'nome_comune',				        // G
                'denominazione_altra_lingua',		// H
                'codice_ripartizione_geografica',	// I
                'ripartizione_geografica',		    // J
                'nome_regione',				        // K
                'nome_provincia',			        // L
                'tipologia_territoriale',           // M
                'flag',					            // N
                'sigla_auto',				        // O
                'codice_comune_numerico',		    // P
                'codice_comune_2016',			    // Q
                'codice_comune_2009',			    // R
                'codice_comune_2005',			    // S
                'codice_catasto_comune',		    // T
                'nuts3_2010',				        // U
                'nuts1_2021',				        // V
                'nuts2_2021',				        // Z
                'nuts3_2021',                       // AA
                'nuts_1',                           // AB
                'nuts_2'                            // AC
            );

            // apro il documento per leggere il numero di righe
            $xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( DIR_BASE . $status['file'] );

            // converto il foglio attivo in un array
            $arr = $xls->getActiveSheet()->toArray();

            // scarto l'intestazione
            array_shift( $arr );

            // status
            $status['info'][] = count( $arr ) . ' righe scritte in cache';

            // assegno le etichette alla riga
            foreach( $arr as &$row ) {
                $row = array_combine( $heads, $row );
            }

            // memorizzo i dati
            memcacheWrite(
                $cf['memcache']['connection'],
                $status['key'],
                serialize( $arr )
            );

            // creo il job
            $status['inserimento'] = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
                array(
                    array( 's' => 'importazione automatica comuni' ),
                    array( 's' => '_src/_api/_job/_comuni.importazione.php' ),
                    array( 's' => 1 ),
                    array( 's' => 1 ),
                    array( 's' => json_encode(
                        array(
                            'key' => $status['key']
                        )
                    ) )
                )
            );

        } else {

            // debug
            logWrite( 'impossibile importare i comuni senza una connessione memcache', 'task', LOG_INFO );

        }

    } else {

        // debug
        logWrite( 'impossibile scaricare il file dei comuni da ' . $status['link'], 'task', LOG_CRIT );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
