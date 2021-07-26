<?php

	$ct['form']['table'] = '';
	
	if( isset( $_SESSION['account']['id_anagrafica'] ) ){

		// soluzioni
		$ct['etc']['soluzioni'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ? AND attivita_view_static.id_anagrafica = ? ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
			array( array( 's' => '2' ), array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
	
		// collaudo
		$ct['etc']['collaudo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ? AND attivita_view_static.id_anagrafica = ? ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
		array( array( 's' => '3' ), array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		// feedback
		$ct['etc']['feedback'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ? AND attivita_view_static.id_anagrafica = ? ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
			array( array( 's' => '5' ), array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

	} else {

		// soluzioni
		$ct['etc']['soluzioni'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ?  ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
			array( array( 's' => '2' ) )
		);
	
		// collaudo
		$ct['etc']['collaudo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ?  ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
			array( array( 's' => '3' ) )
		);

		// feedback
		$ct['etc']['feedback'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND attivita_view_static.id_tipologia = ?  ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
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