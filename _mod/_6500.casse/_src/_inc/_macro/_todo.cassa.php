<?php

	$ct['form']['table'] = '';
	
	if( isset( $_SESSION['account']['id_anagrafica'] ) ){

		// todo per cui l'utente ha attività da fare
		$ct['etc']['todo_da_fare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_completa_view.* FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id WHERE attivita.data_attivita IS NULL and attivita.id_anagrafica = ? GROUP BY todo_completa_view.id',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		foreach( $ct['etc']['todo_da_fare'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE data_attivita IS NULL AND id_todo = ? AND id_anagrafica = ?', array( array( 's' => $todo['id']), array( 's' => $_SESSION['account']['id_anagrafica'] ) ) );

		}

		// todo pianificate per altri
		$ct['etc']['todo_da_fare_per_altri'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_completa_view.* FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id WHERE attivita.data_attivita IS NULL and attivita.id_anagrafica <> ? AND todo_completa_view.id_responsabile <> ? GROUP BY todo_completa_view.id',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ),array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		foreach( $ct['etc']['todo_da_fare_per_altri'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE data_attivita IS NULL AND id_todo = ? AND id_anagrafica <> ?', array( array( 's' => $todo['id']), array( 's' => $_SESSION['account']['id_anagrafica'] ) ) );

		}

		//print_r($ct['etc']['todo_da_fare']);
		// todo per cui l'utente non ha attività pianificate ma altri sì e lui ne è responsabile
		$ct['etc']['todo_responsabile'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_completa_view.*, count(attivita.id) AS n_attivita FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id WHERE attivita.data_attivita IS NULL AND attivita.id_anagrafica <> ? AND todo_completa_view.id_responsabile = ? AND todo_completa_view.timestamp_completamento IS NULL GROUP BY todo_completa_view.id HAVING n_attivita > 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ), array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);

		foreach( $ct['etc']['todo_responsabile'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE data_attivita IS NULL AND id_todo = ?', array( array( 's' => $todo['id']) ) );

		}


		// todo per cui l'utente non sono presenti attività pianificate  e lui ne è responsabile
		$ct['etc']['todo_da_pianificare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT  todo_completa_view.*, count(attivita.id) AS n_attivita FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id WHERE attivita.data_attivita IS NULL AND todo_completa_view.id_responsabile = ? AND todo_completa_view.timestamp_completamento IS NULL GROUP BY todo_completa_view.id HAVING n_attivita = 0',
			array( array( 's' => $_SESSION['account']['id_anagrafica'] ) )
		);
//print_r($ct['etc']['todo_da_pianificare']);
	} else {

		// todo con attività ancora da fare
		$ct['etc']['todo_da_fare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_completa_view.* FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id ANd attivita.data_attivita IS NULL GROUP BY todo_completa_view.id'
		);
	
		foreach( $ct['etc']['todo_da_fare'] as &$todo ){

			$todo['attivita'] = mysqlQuery(
				$cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE data_attivita IS NULL AND id_todo = ?', array( array( 's' => $todo['id']) ) );

		}

		// todo per cui non sono presenti attività pianificate 
		$ct['etc']['todo_da_pianificare'] = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT todo_completa_view.*, count(attivita.id) AS n_attivita FROM todo_completa_view LEFT JOIN attivita ON attivita.id_todo = todo_completa_view.id ANd attivita.data_attivita IS NULL WHERE todo_completa_view.timestamp_completamento IS NULL GROUP BY todo_completa_view.id HAVING n_attivita = 0'
		);
	

	}




	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';