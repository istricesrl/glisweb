<?php

	function validateDate( $date, $format = 'Y-m-d' )	{
		$d = DateTime::createFromFormat($format, $date);
		return $d && $d->format($format) == $date;
	}

	if( isset( $_SESSION['account']['id_anagrafica'] ) ) {

		// attività
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'a\' AS entita, a2.telefoni, a2.mail, todo.id_progetto AS progetto_todo, todo.nome AS nome_todo, concat( todo.id_progetto, " " ,todo.nome ) AS label_todo, '.
			'todo.testo AS testo_todo, attivita.note_programmazione,  attivita.id, attivita.id_tipologia, tipologie_attivita.nome AS tipologia, '.
			'attivita.id_cliente, coalesce( a2.denominazione , concat( a2.cognome, \' \', a2.nome ), \'\' ) AS cliente, attivita.id_indirizzo, indirizzi.indirizzo AS indirizzo, '.
			'attivita.id_luogo, luoghi_path( attivita.id_luogo ) AS luogo, attivita.data_programmazione, attivita.ora_inizio_programmazione, '.
			'attivita.ora_fine_programmazione, attivita.id_anagrafica_programmazione, coalesce( a3.denominazione, '.
			'concat( a3.cognome, \' \', a3.nome ), \'\' ) AS anagrafica_programmazione, attivita.ore_programmazione, attivita.data_attivita, '.
			'day( data_attivita ) as giorno_attivita, month( data_attivita ) as mese_attivita, year( data_attivita ) as anno_attivita, attivita.ora_inizio, '.
			'attivita.ora_fine, attivita.id_anagrafica, coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) AS anagrafica, attivita.ore, attivita.nome, '.
			'attivita.id_progetto, progetti.nome AS progetto, attivita.id_todo, attivita.id_account_inserimento, attivita.id_account_aggiornamento, '.
			'a4.id AS id_anagrafica_assegnante, coalesce( a4.denominazione , concat( a4.cognome, \' \', a4.nome ), \'\' ) AS anagrafica_assegnante, '.
			'concat( attivita.nome, \' / \', attivita.ore, \' / \', coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) ) AS __label__ '.
			'FROM attivita LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica '.
			'LEFT JOIN anagrafica_view_static AS a2 ON a2.id = attivita.id_cliente LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione '.
			'LEFT JOIN account ON account.id = attivita.id_account_inserimento '.
			'LEFT JOIN anagrafica_view_static AS a4 ON a4.id = account.id_anagrafica '.
			'LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto '.
			'LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria '.
			'LEFT JOIN progetti ON progetti.id = attivita.id_progetto LEFT JOIN todo ON todo.id = attivita.id_todo '.
			'LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo '.
			'WHERE attivita.data_attivita IS NULL  AND  ( attivita.id_anagrafica_programmazione = ? OR attivita.id_anagrafica_programmazione IS NULL ) '.
			'ORDER BY attivita.data_programmazione, attivita.ora_inizio_programmazione',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		// print_r( $ct['etc']['attivita'] );
/*
		$ct['etc']['agenda_da_fissare']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT  todo_view.*, count( attivita.id ) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id '.
			'WHERE ( attivita.data_attivita IS NULL OR coalesce( todo_view.data_programmazione, todo_view.anno_programmazione ) IS NULL ) '.
			'AND todo_view.id_anagrafica = ? AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita = 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		if( ! empty($ct['etc']['attivita'] ) ) {
			$todo = array();
			foreach( $ct['etc']['attivita'] as $a ) {
				if( ! empty( $a['id_todo'] ) ) {
					$todo[] = $a['id_todo'];
				}	
			}		
		}
*/
		$ct['etc']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'t\' AS entita, todo.nome, todo.testo, todo.id,todo.id_tipologia,tipologie_todo.nome AS tipologia,todo.id_anagrafica,coalesce( a1.denominazione, '.
			'concat( a1.cognome, \' \', a1.nome ), \'\' ) AS anagrafica,todo.id_cliente,coalesce( a2.denominazione, concat( a2.cognome, \' \', a2.nome ), \'\' ) AS cliente, '.
			'todo.id_indirizzo,concat_ws(\'\',indirizzo,indirizzi.civico,indirizzi.cap,indirizzi.localita,comuni.nome,provincie.sigla) AS indirizzo,todo.id_luogo, '.
			'luoghi_path( todo.id_luogo ) AS luogo,todo.data_scadenza,todo.ora_scadenza,todo.data_programmazione,todo.ora_inizio_programmazione,todo.ora_fine_programmazione,'.
			'todo.anno_programmazione,todo.settimana_programmazione,todo.ore_programmazione,todo.data_chiusura,todo.nome,todo.note_programmazione,todo.id_contatto,'.
			'todo.id_progetto,todo.id_pianificazione,todo.data_archiviazione,todo.id_account_inserimento,todo.id_account_aggiornamento,'.
			'concat(todo.nome,\' per \',coalesce( a2.denominazione, concat( a2.cognome, \' \', a2.nome ), \'\' ),\' su \',todo.id_progetto) AS __label__,'.
			'count(distinct attivita.id) AS n_attivita, count(distinct attivita_chiuse.id) AS n_attivita_chiuse FROM todo LEFT JOIN attivita ON ( attivita.id_todo = todo.id AND attivita.data_attivita IS NULL ) '.
			'LEFT JOIN attivita AS attivita_chiuse ON ( attivita_chiuse.id_todo = todo.id AND attivita_chiuse.data_attivita IS NOT NULL ) LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica '.
			'LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo LEFT JOIN comuni ON comuni.id = indirizzi.id_comune '.
			'LEFT JOIN provincie ON provincie.id = comuni.id_provincia LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia '.
			'WHERE ( tipologie_todo.se_agenda IS NOT NULL OR ( todo.anno_programmazione IS NOT NULL AND todo.settimana_programmazione IS NOT NULL ) ) AND ( todo.id_anagrafica = ? ) AND todo.data_archiviazione IS NULL AND todo.data_chiusura IS NULL GROUP BY todo.id',
//			'WHERE tipologie_todo.se_agenda IS NOT NULL AND attivita.data_attivita IS NULL AND ( todo.id_anagrafica = ? AND ( attivita.id_anagrafica_programmazione != ? OR attivita.id_anagrafica_programmazione IS NULL ) ) ',
//			'WHERE tipologie_todo.se_agenda IS NOT NULL AND attivita.data_attivita IS NULL AND (todo.id_anagrafica = ? AND attivita.id_anagrafica_programmazione <> ?) '.
//			'AND todo.data_chiusura IS NULL '.( isset($todo) && count($todo)>0 ? ' AND todo.id NOT IN ('.implode(',',$todo).') ' : ' ' ).' GROUP BY todo.id',
//			array( array( 's' => $_SESSION['account']['id_anagrafica'] ),  array( 's' => $_SESSION['account']['id_anagrafica'] ) )
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		// print_r( $ct['etc']['todo'] );

/*
	} else {

		// elenco attivita
		$ct['etc']['attivita'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'a\' AS entita,a2.telefoni, a2.mail, todo.nome AS nome_todo, todo.testo AS testo_todo, attivita.note_programmazione, '.
			'concat( progetti.id, " ", progetti.nome ) AS progetto_todo, '.
			'attivita.id, attivita.id_tipologia, tipologie_attivita.nome AS tipologia, attivita.id_cliente, '.
			'coalesce( a2.denominazione , concat( a2.cognome, \' \', a2.nome ), \'\' ) AS cliente, attivita.id_indirizzo, '.
			'indirizzi.indirizzo AS indirizzo, attivita.id_luogo, luoghi_path( attivita.id_luogo ) AS luogo, '.
			'attivita.data_programmazione, attivita.ora_inizio_programmazione, attivita.ora_fine_programmazione, '.
			'attivita.id_anagrafica_programmazione, coalesce( a3.denominazione , concat( a3.cognome, \' \', a3.nome ), \'\' ) AS anagrafica_programmazione, '.
			'attivita.ore_programmazione, attivita.data_attivita, day( data_attivita ) as giorno_attivita, month( data_attivita ) as mese_attivita, '.
			'year( data_attivita ) as anno_attivita, attivita.ora_inizio, attivita.ora_fine, attivita.id_anagrafica, coalesce( a1.denominazione, '.
			'concat( a1.cognome, \' \', a1.nome ), \'\' ) AS anagrafica, attivita.ore, attivita.nome, attivita.id_progetto, progetti.nome AS progetto, '.
			'attivita.id_todo, attivita.id_account_inserimento, attivita.id_account_aggiornamento, concat( attivita.nome, \' / \', attivita.ore, \' / \', '.
			'coalesce( a1.denominazione , concat( a1.cognome, \' \', a1.nome ), \'\' ) ) AS __label__ FROM attivita '.
			'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica '.
			'LEFT JOIN anagrafica_view_static AS a2 ON a2.id = attivita.id_cliente LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione '.
			'LEFT JOIN todo ON todo.id = attivita.id_todo LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo '.
			'LEFT JOIN progetti ON progetti.id = todo.id_progetto '.
			'LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id '.
			'LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria '.
			'WHERE attivita.data_attivita IS NULL AND tipologie_attivita.se_agenda IS NOT NULL ORDER BY attivita.data_programmazione, attivita.ora_inizio_programmazione'
		);

		$ct['etc']['agenda_da_fissare']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT  todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia WHERE tipologie_todo.se_agenda IS NOT NULL AND attivita.data_attivita IS NULL  AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita = 0');

		$ct['etc']['todo'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT \'t\' AS entita, todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id WHERE todo_view.se_agenda IS NOT NULL AND attivita.data_attivita IS NULL AND todo_view.data_chiusura IS NULL GROUP BY todo_view.id HAVING n_attivita > 0');
*/
	}

	$todoGestite = array();

	if( ! empty( $ct['etc']['attivita'] ) ) {
		
		foreach( $ct['etc']['attivita']  as $evento ) {
			
			if( validateDate( $evento['data_programmazione'], 'Y-m-d' ) == 1 ) {
				$ct['etc']['agenda'][ date( 'Y', strtotime( $evento['data_programmazione'] ) ) ][ date( 'W', strtotime( $evento['data_programmazione'] ) ) ][ $evento['data_programmazione'] ][ $evento['ora_inizio_programmazione'] ][] = $evento;
			} else {
				$ct['etc']['agenda_da_fissare']['attivita'][] = $evento;
			}

			$todoGestite[] = $evento['id_todo'];

		}

	}

	if( ! empty( $ct['etc']['todo'] ) ) {

		foreach( $ct['etc']['todo']  as $evento ) {

			if( ! in_array( $evento['id'], $todoGestite ) ) {

/*		
			if( ! empty( $evento['data_programmazione'] ) ) {
				$ct['etc']['agenda'][ date( 'Y', strtotime( $evento['data_programmazione'] ) ) ][ date('W', strtotime( $evento['data_programmazione'] ) ) ][ $evento['data_programmazione']  ][  $evento['ora_inizio_programmazione'] ][] = $evento;
			} else {
				$ct['etc']['todo_todo'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = $evento;
				$ct['etc']['agenda'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = array();
			}
*/	
//			if( ! empty( $evento['data_programmazione'] ) && empty( $evento['n_attivita'] ) ) {
			if( ! empty( $evento['data_programmazione'] ) ) {
				$ct['etc']['agenda'][ date( 'Y', strtotime( $evento['data_programmazione'] ) ) ][ date('W', strtotime( $evento['data_programmazione'] ) ) ][ $evento['data_programmazione'] ][ $evento['ora_inizio_programmazione'] ][] = $evento;
//			} elseif( ! empty( $evento['anno_programmazione'] ) && empty( $evento['n_attivita'] ) ) {
			} elseif( ! empty( $evento['anno_programmazione'] ) ) {
				$ct['etc']['todo_da_monitorare'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = $evento;
				$ct['etc']['agenda'][ $evento['anno_programmazione'] ][ $evento['settimana_programmazione'] ][] = array();
			} else {
				$ct['etc']['agenda_da_fissare']['todo'][] = $evento;
			}

			}

		}

	}

	// print_r( $ct['etc']['todo_da_monitorare'] );

	foreach( $ct['etc']['agenda'] as $anno => $settimane ) {
		foreach( array_keys( $settimane ) as $settimana ) {
			$dto = new DateTime();
			$ct['etc']['intervalli'][ $anno ][ $settimana ] = array(
				'inizio' => $dto->setISODate($anno, $settimana)->format('d-m-Y'),
				'fine' => $dto->modify('+4 days')->format('d-m-Y')
			);
		}
	}

	// print_r( $ct['etc']['intervalli'] );

	// tendina tipologia attivita
	$ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );

	// integrazione metadati
	foreach( $ct['etc']['id_tipologia_attivita'] as &$row ) {
		$meta = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT * FROM metadati WHERE id_tipologia_attivita = ? AND nome LIKE ?',
			array(
				array( 's' => $row['id'] ),
				array( 's' => '%procedure|attivita|corrente|%' )
			)
		);
		$row = array_replace_recursive(
			$row,
			metadata2associativeArray( $meta )
		);
	}

	// debug
	// print_r( $ct['etc']['id_tipologia_attivita'] );

	// tendina tipologia attivita
	$ct['etc']['id_tipologia_todo'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view WHERE se_agenda IS NOT NULL' );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
