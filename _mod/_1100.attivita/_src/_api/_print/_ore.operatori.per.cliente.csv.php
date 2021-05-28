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
			'SELECT r.*, a1.__label__ as operatore, a2.__label__ as cliente FROM __report_ore_operatori_per_cliente__ AS r '
			.'LEFT JOIN anagrafica_view_static AS a1 ON r.id_anagrafica = a1.id '
			.'LEFT JOIN anagrafica_view_static AS a2 ON r.id_cliente = a2.id '
			.'ORDER BY a1.__label__, a2.__label__');

		if( !empty( $report ) ){
			$filename = "esportazione ore operatori per cliente " . int2month($mese) . " " . $anno . ".csv";
	
			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename=' . $filename );
			
			// intestazioni
			$csv[0] = array('ID operatore', 'Operatore','ID cliente', 'Cliente', 'Ore lavorate');

			foreach( $report as $r ){
				$csv[] = array( 
					$r['id_anagrafica'],
					$r['operatore'],
					$r['id_cliente'],
					$r['cliente'], 
					str_replace('.', ',', $r['ore_fatte'] )
				);
			}

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);

		}else { buildText( 'nessun risultato per la ricerca effettuata' ); }

	} else { buildText( 'mese e anno non specificati' ); }

