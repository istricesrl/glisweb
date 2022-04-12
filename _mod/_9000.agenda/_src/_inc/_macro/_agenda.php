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
			'SELECT \'a\' AS entita, a2.telefoni, a2.mail,  concat( todo.id_progetto, " " ,todo.nome ) AS todo, todo.testo AS testo_todo, attivita.note_programmazione,  attivita.id, attivita.id_tipologia, tipologie_attivita.nome AS tipologia, attivita.id_cliente, coalesce( a2.denominazione , concat( a2.cognome, \' \', a2.nome ), \'\' ) AS cliente, attivita.id_indirizzo, indirizzi.indirizzo AS indirizzo, attivita.id_luogo, luoghi_path( attivita.id_luogo ) AS luogo, attivita.data_programmazione, attivita.ora_inizio_programmazione, attivita.ora_fine_programmazione, attivita.id_anagrafica_programmazione, coalesce( a3.denominazione , concat( a3.cognome, \' \', a3.nome ), \'\' ) AS anagrafica_programmazione, attivita.ore_programmazione, attivita.data_attivita, day( data_attivita ) as giorno_attivita, month( data_attivita ) as mese_attivita, year( data_attivita ) as anno_attivita, attivita.ora_inizio, attivita.ora_fine, attivita.id_anagrafica, coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) AS anagrafica, attivita.ore, attivita.nome, attivita.id_progetto, progetti.nome AS progetto, attivita.id_todo, attivita.id_account_inserimento, attivita.id_account_aggiornamento, concat( attivita.nome, \' / \', attivita.ore, \' / \', coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) ) AS __label__ FROM attivita LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica LEFT JOIN anagrafica_view_static AS a2 ON a2.id = attivita.id_cliente LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria LEFT JOIN progetti ON progetti.id = attivita.id_progetto LEFT JOIN todo ON todo.id = attivita.id_todo LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo '.
			'WHERE attivita.data_attivita IS NULL  AND  ( attivita.id_anagrafica_programmazione = ? OR attivita.id_anagrafica_programmazione IS NULL ) ORDER BY attivita.data_programmazione, attivita.ora_inizio_programmazione',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
	
		$ct['etc']['agenda_da_fissare']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT  todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id WHERE attivita.data_attivita IS NULL AND todo_view.id_anagrafica = ? AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita = 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) ) );

		$ct['etc']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'t\' AS entita, todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id WHERE attivita.data_attivita IS NULL AND (todo_view.id_anagrafica = ? AND attivita.id_anagrafica_programmazione <> ?) AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id  HAVING n_attivita > 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ),  array( 's' => $_SESSION['account']['id_anagrafica'] )  ) );
	} else {

		// elenco attivita
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'a\' AS entita,a2.telefoni, a2.mail,  concat( todo.id_progetto, \" \" ,todo.nome ) AS todo, todo.testo AS testo_todo, attivita.note_programmazione,  attivita.id, attivita.id_tipologia, tipologie_attivita.nome AS tipologia, attivita.id_cliente, coalesce( a2.denominazione , concat( a2.cognome, \' \', a2.nome ), \'\' ) AS cliente, attivita.id_indirizzo, indirizzi.indirizzo AS indirizzo, attivita.id_luogo, luoghi_path( attivita.id_luogo ) AS luogo, attivita.data_programmazione, attivita.ora_inizio_programmazione, attivita.ora_fine_programmazione, attivita.id_anagrafica_programmazione, coalesce( a3.denominazione , concat( a3.cognome, \' \', a3.nome ), \'\' ) AS anagrafica_programmazione, attivita.ore_programmazione, attivita.data_attivita, day( data_attivita ) as giorno_attivita, month( data_attivita ) as mese_attivita, year( data_attivita ) as anno_attivita, attivita.ora_inizio, attivita.ora_fine, attivita.id_anagrafica, coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) AS anagrafica, attivita.ore, attivita.nome, attivita.id_progetto, progetti.nome AS progetto, attivita.id_todo, attivita.id_account_inserimento, attivita.id_account_aggiornamento, concat( attivita.nome, \' / \', attivita.ore, \' / \', coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) ) AS __label__ FROM attivita LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica LEFT JOIN anagrafica_view_static AS a2 ON a2.id = attivita.id_cliente LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria LEFT JOIN progetti ON progetti.id = attivita.id_progetto LEFT JOIN todo ON todo.id = attivita.id_todo LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo '.
			'WHERE attivita.data_attivita IS NULL ORDER BY attivita.data_programmazione, attivita.ora_inizio_programmazione',
		);
	
		$ct['etc']['agenda_da_fissare']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT  todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id WHERE attivita.data_attivita IS NULL  AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita = 0');

		$ct['etc']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'t\' AS entita, todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id WHERE attivita.data_attivita IS NULL AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita > 0');
	}

	foreach( $ct['etc']['todo']  as $evento ) {
		
		if( !empty( $evento['data_programmazione']) ){
			$ct['etc']['agenda'][ date('Y', strtotime($evento['data_programmazione'])) ][ date('W', strtotime($evento['data_programmazione'])) ][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][] = $evento;
		} else {
			$ct['etc']['todo_todo'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = $evento;
			$ct['etc']['agenda'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = array();
		}

	}

	foreach( $ct['etc']['attivita']  as $evento ) {
		
		if(  validateDate($evento['data_programmazione'], 'Y-m-d') == 1 ){
			$ct['etc']['agenda'][ date('Y', strtotime($evento['data_programmazione'])) ][ date('W', strtotime($evento['data_programmazione'])) ][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][] = $evento;
		} else {
			$ct['etc']['agenda_da_fissare']['attivita'][] = $evento;
		}

	}



	// tendina tipologia attivita
	 $ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );

	// tendina tipologia attivita
	$ct['etc']['id_tipologia_todo'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view' );



	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


