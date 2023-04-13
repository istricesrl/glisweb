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

	    $where = array();
	    $join = array();
	    $params = array();
	    $from = '';

	    // se è indicata la categoria
	    if ( isset( $_REQUEST['__categoria__'] ) ){
							if( ! empty( $_REQUEST['__categoria__'] )  ){
							$where[] = 'anagrafica_categorie.id_categoria = ?';
							$params[] = array( 's' => $_REQUEST['__categoria__'] );  
							$join[] = 'LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id ';}
							}

	    // controllo parametri
		if( ! empty( $where ) &&  ! empty( $join ) ) {  
			$where = implode(' AND ', $where);
			 $join = implode(' ', $join); 

		$ct['anagrafica'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT anagrafica.* '.
		    'FROM anagrafica '.
		    $join.' WHERE '.$where. ' ORDER BY denominazione, cognome, nome ',
		    $params
			);
		} else {
		$ct['anagrafica'] = mysqlQuery(
		    $cf['mysql']['connection'], 'SELECT anagrafica.* FROM anagrafica ORDER BY denominazione, cognome, nome ');}

		    // debug
//			 die( 'risultato: '.print_r( $ct['fatturati'], true ) );
//			 die( print_r( 'where: '.$where)  );
//			 die( print_r($params,true) );
//			 die( print_r($_REQUEST,true) );
//			 die( 'fatturati: '.print_r( $ct['fatturati'], true ) );
		    // se sono presenti dati

			if(! empty($ct['anagrafica'] ) ) {

			//die(print_r($ct['anagrafica'] ) );


			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename="esportazione contatti mail.csv"');

			$csv[0] = array('Email Address','First Name', 'Last Name');
			foreach($ct['anagrafica'] as $anagrafica ){

			$mail = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1',
				array( array('s' => $anagrafica['id'] ) ));

			if( empty( $mail ) ){ 	$mail = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? '.
			'AND timestamp_aggiornamento = (SELECT MAX(m.timestamp_aggiornamento) FROM mail AS m WHERE m.id_anagrafica = ? )',
				array( array('s' => $anagrafica['id'] ), array('s' => $anagrafica['id'] ) ) );  }
			if( empty( $mail ) ){ 	$mail = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? '.
			'AND timestamp_aggiornamento IS NULL ORDER BY mail.id DESC ',
				array( array('s' => $anagrafica['id'] ) ));  }

			// creo la riga
			if( !empty($mail ) )  {
			if( !empty($anagrafica['nome']) && ! empty($anagrafica['cognome']) ){
			    $csv[] = array( $mail, $anagrafica['nome'], $anagrafica['cognome'] ); 
			} else {
			$csv[] = array( $mail,'', $anagrafica['denominazione']);}}

			}

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ',');}
			fclose($fp);


			} else { buildText( 'nessun risultato per la ricerca effettuata' ); }

		

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
