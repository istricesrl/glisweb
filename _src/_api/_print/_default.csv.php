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

		$error = array();

		$view = ( isset( $_REQUEST['v'] ) ) ? json_decode( $_REQUEST['v'], true ) : array();

		$view['__pager__'] = NULL;

		$data = array();

		controller(
			$cf['mysql']['connection'],
			$cf['memcache']['connection'],
			$data,
			$_REQUEST['t'],
			METHOD_GET,
			NULL,
			$error,
			$view
		);

		// debug
		// die( print_r( $view ) );

		if( ! empty( $data ) ) {

			$csv[0] = array_keys( $data[0] );

			// die(print_r($data ) );

			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename="'.$_REQUEST['t'].'.csv"');

				$csv = array_merge( $csv, $data );

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);

		} else {
			
			buildText( 'nessun risultato per la ricerca effettuata' );
		
		}

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
