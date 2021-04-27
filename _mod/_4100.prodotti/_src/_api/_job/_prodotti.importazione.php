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
	logWrite( 'importazione prodotti (job #' . $job['id'] . ') in corso', 'job' );

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
				logWrite( 'trovate ' . $totale . ' righe per importazione prodotti #' . $job['id'], 'job' );

			    // scrivo il totale delle righe da elaborare
				mysqlQuery( $cf['mysql']['connection'], 'UPDATE job SET totale = ? WHERE id = ?', array( array( 's' => $totale ), array( 's' => $job['id'] ) ) );

			    // elaborazione di n step
				for( $i = $corrente; $i < $limite; $i++ ) {

				    // assegno le etichette alla riga
					$row = array_combine( $heads, $data[ $i ] );


				    // cerco l'id della tipologia
					$idTipologia = mysqlSelectValue(
					    $cf['mysql']['connection'],
					    'SELECT id FROM tipologie_prodotti WHERE nome = ?',
					    array(
						array( 's' => $row['tipologia'] )
					    )
					);

				    // se la tipologia non esiste, la creo
					if( empty( $idTipologia ) && ! empty( $row['tipologia'] ) ) {
					    $idTipologia = mysqlQuery(
						$cf['mysql']['connection'],
						'INSERT INTO tipologie_prodotti ( nome ) VALUES ( ? )',
						array(
						    array( 's' => $row['tipologia'] )
						)
					    );
					}

				    // cerco l'id della categoria
					$idCategoria = mysqlSelectValue(
					    $cf['mysql']['connection'],
					    'SELECT id FROM categorie_prodotti WHERE nome = ?',
					    array(
						array( 's' => $row['categoria'] )
					    )
					);

				    // se la categoria non esiste, la creo
					if( empty( $idCategoria ) && ! empty( $row['categoria'] ) ) {
					    $idCategoria = mysqlQuery(
						$cf['mysql']['connection'],
						'INSERT INTO categorie_prodotti ( nome, id_tipologia_pubblicazione ) VALUES ( ?, 2 )',
						array(
						    array( 's' => $row['categoria'] )
						)
					    );
					}

				    // cerco l'id dell'unità di misura
					$idUdm = mysqlSelectValue(
					    $cf['mysql']['connection'],
					    'SELECT id FROM udm WHERE nome = ?',
					    array(
						array( 's' => $row['udm'] )
					    )
					);

				    if( !empty( $idTipologia ) && !empty( $idUdm )  ){

				    // log
					logWrite( 'inserisco in prodotti ' . $row['nome'] . ' (id ' . $id . ', riga #' . ( $i + 1 ) . ' su totali ' . $totale . ' limite ciclo da ' . $corrente . ' minore di ' . $limite . ')', 'job' );

				    // inserisco il prodotto di questa riga
					$id = mysqlQuery(
					    $cf['mysql']['connection'],
					    'INSERT INTO prodotti ( id, id_tipologia, nome, id_udm, descrizione, id_tipologia_pubblicazione ) VALUES ( ?, ?, ?, ?, ?, ? ) '.
					    'ON DUPLICATE KEY UPDATE id = VALUES( id ), '.
					    'nome = VALUES( nome ), id_tipologia = VALUES( id_tipologia ), id_udm = VALUES( id_udm ), descrizione = VALUES( descrizione ), id_tipologia_pubblicazione = VALUES ( id_tipologia_pubblicazione)  ',
					    array(
						array( 's' => $row['codice'] ),
						array( 's' => $idTipologia ),
						array( 's' => $row['nome'] ),
						array( 's' => $idUdm ),
						array( 's' => $row['descrizione'] ),
						array( 's' => '2' )
					    )
					);
					// log
					    logWrite( 'prodotto ' . $id .' categoria  '.$idCategoria . ' riga#' . ( $i + 1 ) . ')', 'job' );

					if( ! empty( $idCategoria ) ){
					    $catProd = mysqlQuery($cf['mysql']['connection'],
					    'INSERT INTO prodotti_categorie( id_prodotto, id_categoria ) VALUES ( ?, ? )',
					    array( array('s' => $row['codice'] ), array( 's' => $idCategoria ) ) ) ;
					}
				    }
				    else{
					// log
					    logWrite( 'impossibile inserire prodotto ' . $row['nome'] . ' (id ' . $row['id'] . ', riga #' . ( $i + 1 ) . ' su totali ' . $totale . ' limite ciclo da ' . $corrente . ' minore di ' . $limite . ')', 'job' );
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
	logWrite( 'fine script per importazione prodotti #' . $job['id'], 'job' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
