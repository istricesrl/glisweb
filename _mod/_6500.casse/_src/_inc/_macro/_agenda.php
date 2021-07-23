<?php

	$ct['form']['table'] = '';
	
	if( isset( $_SESSION['account']['id'] ) ){

		// soluzioni
		$ct['etc']['soluzioni'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ? AND id_anagrafica = ? ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '2' ), array( 's' => $_SESSION['account']['id'] ) )
		);
	
		// collaudo
		$ct['etc']['collaudo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ? AND id_anagrafica = ? ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '3' ), array( 's' => $_SESSION['account']['id'] ) )
		);

		// feedback
		$ct['etc']['feedback'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ? AND id_anagrafica = ? ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '5' ), array( 's' => $_SESSION['account']['id'] ) )
		);

	} else {

		// soluzioni
		$ct['etc']['soluzioni'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ?  ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '2' ) )
		);
	
		// collaudo
		$ct['etc']['collaudo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ? ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '3' ) )
		);

		// feedback
		$ct['etc']['feedback'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM attivita_view_static WHERE data_attivita IS NULL AND id_tipologia = ? ORDER BY data_programmazione, ora_inizio_programmazione',
			array( array( 's' => '5' ) )
		);

	}


		foreach( $ct['etc']['soluzioni']  as $evento ) {
			$ct['etc']['agenda_soluzioni'][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][ $evento['id'] ] = $evento;
		}

		foreach( $ct['etc']['collaudo']  as $evento ) {
			$ct['etc']['agenda_collaudo'][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][ $evento['id'] ] = $evento;
		}

		foreach( $ct['etc']['feedback']  as $evento ) {
			$ct['etc']['agenda_feedback'][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][ $evento['id'] ] = $evento;
		}
	


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';