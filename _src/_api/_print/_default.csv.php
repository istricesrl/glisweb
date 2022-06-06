<?php

    // inclusione del framework
	require '../../_config.php';

    // inclusione di PHPExcel
	use PhpOffice\PhpSpreadsheet\Spreadsheet;
	use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

		    // debug
			// die( 'contenuto: '.print_r( $_REQUEST, true ) );


    // controllo autorizzazioni
	if( true ) {

		$data = array();

			controller(
				$cf['mysql']['connection'],
				$cf['memcache']['connection'],
				$data,
				$_REQUEST['t']
			);

			if(! empty( $data ) ) {

				$csv[0] = array_keys( $data[0] );

			// die(print_r($data ) );

			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename="'.$_REQUEST['t'].'.csv"');

				$csv = array_merge( $csv, $data );

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);


			} else { buildText( 'nessun risultato per la ricerca effettuata' ); }

		

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
