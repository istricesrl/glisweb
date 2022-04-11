<?php

	function validateDate($date, $format = 'Y-m-d')
	{
		$d = DateTime::createFromFormat($format, $date);
		return $d && $d->format($format) == $date;
	}
	
	if( isset( $_SESSION['account']['id_anagrafica'] ) ){

		// soluzioni
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT anagrafica_view_static.telefoni, anagrafica_view_static.mail, attivita_view.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo, todo.testo AS testo_todo FROM attivita_view '.
			'LEFT JOIN todo ON todo.id = attivita_view.id_todo '.
			'LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = attivita_view.id_cliente '.
			'WHERE attivita_view.data_attivita IS NULL  AND  (attivita_view.id_anagrafica = ? OR attivita_view.id_anagrafica IS NULL ) ORDER BY attivita_view.data_programmazione, attivita_view.ora_inizio_programmazione',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
	


	} else {

		// elenco attivita
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT anagrafica_view_static.telefoni, anagrafica_view_static.mail, attivita_view.*, concat( todo.id_progetto, " " ,todo.nome ) AS todo, todo.testo AS testo_todo FROM attivita_view '.
			'LEFT JOIN todo ON todo.id = attivita_view.id_todo '.
			'LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = attivita_view.id_cliente '.
			'WHERE attivita_view.data_attivita IS NULL  ORDER BY attivita_view.data_programmazione, attivita_view.ora_inizio_programmazione'
	);
	

	}


	foreach( $ct['etc']['attivita']  as $evento ) {
		
		if(  validateDate($evento['data_programmazione'], 'Y-m-d') == 1 ){
			$ct['etc']['agenda'][ date('Y', strtotime($evento['data_programmazione'])) ][ date('W', strtotime($evento['data_programmazione'])) ][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][ $evento['id'] ] = $evento;
		} else {
			$ct['etc']['agenda_da_fissare'][ $evento['id'] ] = $evento;
		}

	}

	// tendina tipologia attivita
	 $ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );



