<?php

	$ct['form']['table'] = '';
	
	if( isset( $_SESSION['account']['id_anagrafica'] ) ){

		// todo per cui l'utente ha attività da fare
		$ct['etc']['todo_da_fare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_view.* FROM todo_view INNER JOIN attivita ON attivita.id_todo = todo_view.id ANd attivita.data_attivita IS NULL and attivita.id_anagrafica = ? GROUP BY todo_view.id',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		foreach( $ct['etc']['todo_da_fare'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE id_todo = ?', array( array( 's' => $todo['id']) ) );

		}
		//print_r($ct['etc']['todo_da_fare']);
		// todo per cui l'utente non ha attività pianificate ma altri sì e lui ne è responsabile
		$ct['etc']['todo_responsabile'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id ANd attivita.data_attivita IS NULL AND attivita.id_anagrafica <> ? WHERE todo_view.id_responsabile = ? AND todo_view.timestamp_completamento IS NULL GROUP BY todo_view.id HAVING n_attivita > 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ), array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		foreach( $ct['etc']['todo_responsabile'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE id_todo = ?', array( array( 's' => $todo['id']) ) );

		}


		// todo per cui l'utente non sono presenti attività pianificate  e lui ne è responsabile
		$ct['etc']['todo_da_pianificare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id ANd attivita.data_attivita IS NULL WHERE todo_view.id_responsabile = ? AND todo_view.timestamp_completamento IS NULL GROUP BY todo_view.id HAVING n_attivita = 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
//print_r($ct['etc']['todo_da_pianificare']);
	} else {

		// todo con attività ancora da fare
		$ct['etc']['todo_da_fare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_view.* FROM todo_view INNER JOIN attivita ON attivita.id_todo = todo_view.id ANd attivita.data_attivita IS NULL GROUP BY todo_view.id'
		);
	
		foreach( $ct['etc']['todo_da_fare'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE id_todo = ?', array( array( 's' => $todo['id']) ) );

		}

		// todo per cui non sono presenti attività pianificate 
		$ct['etc']['todo_da_pianificare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_view.*, count(attivita.id) AS n_attivita FROM todo_view LEFT JOIN attivita ON attivita.id_todo = todo_view.id ANd attivita.data_attivita IS NULL WHERE todo_view.timestamp_completamento IS NULL GROUP BY todo_view.id HAVING n_attivita = 0'
		);
	

	}

