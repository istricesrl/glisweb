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
	logWrite( 'importazione prezzi articoli (job #' . $job['id'] . ') in corso', 'job' );

    // inizializzo l'array del risultato
	$status = $wksp = array();

    // lettura del workspace
	if( ! empty( $job['workspace'] ) ) {
	    $wksp = $job['workspace'] ;
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
				logWrite( 'trovate ' . $totale . ' righe per importazione prezzi articoli #' . $job['id'], 'job' );

			    // scrivo il totale delle righe da elaborare
				mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET totale = ? WHERE id = ?', array( array( 's' => $totale ), array( 's' => $job['id'] ) ) );

			    // elaborazione di n step
				for( $i = $corrente; $i < $limite; $i++ ) {

				    // assegno le etichette alla riga
					$row = array_combine( $heads, $data[ $i ] );

					$idArticolo = mysqlSelectValue(
						$cf['mysql']['connection'], 'SELECT id FROM articoli WHERE id = ? ',
						array( array( 's' => $row['articolo'] ) )
					);


					if( $idArticolo ){
				    // inserisco l'articolo di questa riga
					$id = mysqlQuery(
					    $cf['mysql']['connection'],
					    'INSERT INTO prezzi ( id_articolo, prezzo, id_listino, id_udm, id_iva, id_valuta ) VALUES ( ?, ?, ?, ?, ?, ? ) ',
					    array(
						array( 's' => $row['articolo'] ),
						array( 's' => str_replace (',', '.', $row['prezzo'] )  ),
						array( 's' => $row['listino'] ),
                        array( 's' => $row['udm'] ),
                        array( 's' => $row['iva'] ),
                        array( 's' => $row['valuta'] )
					    )
					);
					
					// log
					logWrite( 'inserisco il prezzo dell\' articolo ' . $row['articolo'] . ' (id ' . $id . ', riga #' . ( $i + 1 ) . ' su totali ' . $totale . ' limite ciclo da ' . $corrente . ' minore di ' . $limite . ')', 'job' );




					} else {
						logWrite( 'impossibile inserire il prezzo dell\' articolo ' . $row['articolo'] . ': articolo di riferimento assente (id ' . $id . ', riga #' . ( $i + 1 ) . ' su totali ' . $totale . ' limite ciclo da ' . $corrente . ' minore di ' . $limite . ')', 'job' );
					}

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
	logWrite( 'fine script per importazione prezzi articoli #' . $job['id'], 'job' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
