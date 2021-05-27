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


		// controllo se esistono le righe nella tabella di report, altrimenti lo creo
			$dir = DIR_BASE . 'var/spool/print/ore_operatori/' . $anno;
			$file = glob( $dir . "/*.csv");
			
			foreach( $file as $f ){
				$ct['etc']['pdf']['operatori'][] = array('id' => str_replace('.pdf', '', basename( $f ) ), 'nome' => int2month( str_replace('.pdf', '', basename( $f ) ) ) );
			}


			// elenco dati
			$report = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT r.*, a.__label__ as operatore FROM __report_ore_operatori__ AS r LEFT JOIN anagrafica_view_static AS a '
				.'ON r.id_anagrafica = a.id ORDER BY a.__label__');

			if( !empty( $report ) ){
				$filename = "esportazione ore operatori " . int2month($mese) . " " . $anno . ".csv";
		
				header('Content-Type: text/csv');
				header('Content-Disposition: attachment; filename=' . $filename );
				
				// intestazioni
				$csv[0] = array('Operatore','Ore contratto', 'Ore lavorate', 'Differenza');

				foreach( $report as $r ){
					$csv[] = array( $r['operatore'], $r['ore_contratto'], $r['ore_fatte'] , $r['ore_fatte'] - $r['ore_contratto'] );
				}

				$fp = fopen('php://output', 'wb');
				foreach ($csv as $line) {fputcsv($fp, $line, ',');}
				fclose($fp);

			}else { buildText( 'nessun risultato per la ricerca effettuata' ); }

	} else { buildText( 'mese e anno non specificati' ); }

