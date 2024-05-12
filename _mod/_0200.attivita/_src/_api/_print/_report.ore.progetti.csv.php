<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // inclusione di PHPExcel
	use PhpOffice\PhpSpreadsheet\Spreadsheet;
	use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

	// se sono indicati mese e anno
	if ( isset( $_REQUEST['mese'] ) && isset( $_REQUEST['anno'] ) ){
		$mese = $_REQUEST['mese'];
		$anno = $_REQUEST['anno'];

		// elenco dati
		$report = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT r.*, p.nome as progetto FROM __report_ore_progetti__ AS r LEFT JOIN progetti AS p '
			.'ON r.id_progetto = p.id WHERE r.mese = ? AND r.anno = ? ORDER BY p.nome',
			array(
				array( 's' => $mese ),
				array( 's' => $anno )
			)
		);

		if( !empty( $report ) ){
			$filename = "esportazione ore progetti " . int2month($mese) . " " . $anno . ".csv";
	
			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename=' . $filename );
			
			// intestazioni
			$csv[0] = array('ID progetto', 'Progetto','Ore previste', 'Ore lavorate', 'Differenza');

			foreach( $report as $r ){
				$csv[] = array( 
					$r['id_progetto'],
					$r['progetto'], 
					str_replace('.', ',', $r['ore_previste'] ), 
					str_replace( '.', ',', $r['ore_fatte'] ), 
					str_replace( '.', ',', $r['ore_fatte'] - $r['ore_previste'] ) 
				);
			}

			$fp = fopen( DIR_TMP . microtime( true ) . '.csv', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);

		}else { buildText( 'nessun risultato per la ricerca effettuata' ); }

	} else { buildText( 'mese e anno non specificati' ); }

