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
			'SELECT r.*, a.__label__ as cliente FROM __report_ore_clienti__ AS r LEFT JOIN anagrafica_view_static AS a '
			.'ON r.id_cliente = a.id ORDER BY a.__label__');

		if( !empty( $report ) ){
			$filename = "esportazione ore clienti " . int2month($mese) . " " . $anno . ".csv";
	
			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename=' . $filename );
			
			// intestazioni
			$csv[0] = array('ID cliente', 'Cliente','Ore previste', 'Ore lavorate', 'Differenza');

			foreach( $report as $r ){
				$csv[] = array( 
					$r['id_cliente'],
					$r['cliente'], 
					str_replace('.', ',', $r['ore_previste'] ), 
					str_replace( '.', ',', $r['ore_fatte'] ), 
					str_replace( '.', ',', $r['ore_fatte'] - $r['ore_previste'] ) 
				);
			}

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);

		}else { buildText( 'nessun risultato per la ricerca effettuata' ); }

	} else { buildText( 'mese e anno non specificati' ); }

