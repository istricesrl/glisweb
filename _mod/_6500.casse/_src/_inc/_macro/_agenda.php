<?php

	$ct['form']['table'] = '';
	
	if( isset( $_SESSION['account']['id_anagrafica'] ) ){

		// soluzioni
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL AND  attivita_view_static.id_anagrafica = ? ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione',
			array(  array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
	


	} else {

		// elenco attivita
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT attivita_view_static.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo FROM attivita_view_static '.
			'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
			'WHERE attivita_view_static.data_attivita IS NULL  ORDER BY attivita_view_static.data_programmazione, attivita_view_static.ora_inizio_programmazione'
		);
	

	}


	foreach( $ct['etc']['attivita']  as $evento ) {
		$ct['etc']['agenda'][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][ $evento['id'] ] = $evento;
	}

	 // tendina tipologia attivita
	 $ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_dashboard_agenda = 1 ORDER BY nome' );



	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';