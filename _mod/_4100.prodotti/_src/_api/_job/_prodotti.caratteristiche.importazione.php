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
	    require '../../../../../_src/_config.php';
	}

    // inclusione di PHPExcel
	use PhpOffice\PhpSpreadsheet\Spreadsheet;
	use PhpOffice\PhpSpreadsheet\Reader\Xlsx;
    // log
	logWrite( 'importazione caratteristiche prodotti (job #' . $job['id'] . ') in corso', 'job' );

    // inizializzo l'array del risultato
	$status = $wksp = array();

    // lettura del workspace
	if( ! empty( $job['workspace'] ) ) {
	    $wksp = unserialize( $job['workspace'] );
	}

	    // se è presente almeno un documento
		if( isset( $wksp['document'] ) ) {

		    // apro il documento per leggere il numero di righe
			$xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( DIR_BASE . $wksp['document'] );

		    // converto il foglio attivo in un array
			$data = $xls->getActiveSheet()->toArray();

		    // controllo se sono presenti dati
			if( is_array( $data ) && count( $data ) ) {

			    // prelevo l'intestazione
				$heads = array_shift( $data );

			    // TODO qui fare un if per controllare se heads contiene le etichette giuste

			    // valori di riferimento
				$totale = count( $data );

				$corrente = ( ( empty( $job['corrente'] ) ) ? 0 : ( $job['corrente'] ) );
				$limite = min( array( $corrente + $job['iterazioni'], $totale ) );

			    // log
				logWrite( 'trovate ' . $totale . ' righe per importazione caratteristiche prodotti #' . $job['id'], 'job' );

			    // scrivo il totale delle righe da elaborare
				mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET totale = ? WHERE id = ?', array( array( 's' => $totale ), array( 's' => $job['id'] ) ) );


			    // prelevo le caratteristiche
				for( $i = 1; $i < sizeof( $heads ) && ! empty( $heads[$i] ); $i++ ){
				   // cerco l'id della caratteristica
					$caratteristiche[$i] = mysqlSelectValue(
					    $cf['mysql']['connection'],
					    'SELECT id FROM caratteristiche_prodotti WHERE nome = ?',
					    array(
						array( 's' => $heads[$i] )
					    )
					);

				    // se non esiste la creo
					if( empty($caratteristiche[$i] ) ){
						$caratteristiche[$i] = mysqlQuery(
						$cf['mysql']['connection'],
						'INSERT INTO caratteristiche_prodotti ( nome ) VALUES ( ? )',
						array(
						    array( 's' => $heads[$i] )
						)
					    );}
				    
				$elenco[$i] = array('id' => $caratteristiche[$i],'nome' => $heads[$i] );
				}
			    $heads[0] = 'prodotto';

                for( $i = $corrente; $i < $limite; $i++ ) {
				    
				    // assegno le etichette alla riga
					$row = array_combine( $heads, $data[ $i ] );

				logWrite( 'trovato prodotto ' . $row['prodotto'] . ' job #' . $job['id'], 'job' );

				    $values = array();
				    $params = array();

#				    $query = 'INSERT INTO prodotti_caratteristiche (id_prodotto, id_caratteristica, testo, se_non_presente ) VALUES ';
				    // se l'ho trovato inserisco ogni categoria
				    for( $j = 1; $j <= sizeof( $elenco ); $j++ ){
#					logWrite( 'caratteristica j:'.$j . ' ha id  '. $elenco[$j]['id'].' nome ' . $elenco[$j]['nome']  . ' job #' . $job['id'], 'job', LOG_NOTICE );
					if( ! strcmp($row[ $elenco[$j]['nome'] ], '0' ) == '0' ){
					$values[] = ' ( ?, ?, ?, ? )';
					// id prodotto
					$params[] = array('s' => $row['prodotto'] );
					// id_caratteristica
					$params[] = array('s' => $elenco[$j]['id']  );
					// se presente
					if( ! empty( $row[ $elenco[$j]['nome'] ]  ) ){
					    // testo
					    if( strtolower($row[ $elenco[$j]['nome'] ]) == 'x' ) {
						$params[] = array('s' => NULL );
					    } else { $params[] = array('s' => $row[ $elenco[$j]['nome'] ] );}
					    // se non presente    
					    $params[] = array('s' => NULL );
					} else {
					    // nome
					    $params[] = array('s' => NULL );
					    // se_non_presente
					    $params[] = array('s' => '1' );
					}
					}

				}
				    $valori = implode(',', $values );

				    // inserisco nel db
				    $inserimento = mysqlQuery( $cf['mysql']['connection'],
				    'INSERT INTO prodotti_caratteristiche (id_prodotto, id_caratteristica, testo, se_non_presente ) VALUES '.$valori,
				    $params);

				    // aggiorno il valore corrente
					mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET corrente = ?, timestamp_esecuzione = ? WHERE id = ?', array( array( 's' => ( $i + 1 ) ), array( 's' => time() ), array( 's' => $job['id'] ) ) );
				}

			    // status
				$wksp['status'] = 'OK';

			} else {

			    // status
				$wksp['status'] = 'impossibile leggere dati dal file';
			        logWrite( 'impossibile leggere dati dal file', 'job' );
			
			    // forzo la conclusione del job
				$limite = $totale = false;

			}

		    // conclusione del job
			if( $limite == $totale ) {
			    logWrite( 'fine job (elaborate ' . $limite . ' righe su ' . $totale . ')', 'job' );
			    mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET timestamp_completamento = ? WHERE id = ?', array( array( 's' => time() ), array( 's' => $job['id'] ) ) );
			}

		} else {

		    // status
			$wksp['status'] = 'document non impostato';

		}

    // aggiornamento job
	mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET workspace = ? WHERE id = ?', array( array( 's' => serialize( $wksp ) ), array( 's' => $job['id'] ) ) );

    // log
	logWrite( 'fine script per importazione prodotti #' . $job['id'], 'job' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}