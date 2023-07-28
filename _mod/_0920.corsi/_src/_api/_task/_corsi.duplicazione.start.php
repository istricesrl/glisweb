<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// debug
	// die( print_r( $_REQUEST, true ) );

	// ...
	if( true ) {

		// tipologie
		$tipologie = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM tipologie_periodi_view'
		);

		// debug
		// print_r( $tipologie );

		// ...
		$saltare = array();

		// tipologie da utilizzare
		foreach( $tipologie as $tipologia ) {
			if( isset( $_REQUEST[ 'salta_' . $tipologia['id'] ] ) && ! empty( $_REQUEST[ 'salta_' . $tipologia['id'] ] ) ) {
				$saltare[] = $tipologia['id'];
			}
		}

		// workspace
		$workspace = array(
			'sostituzioni' => array(
				'periodo_partenza' => $_REQUEST['periodo_partenza'],
				'disciplina' => $_REQUEST['disciplina'],
				'periodo_destinazione' => $_REQUEST['periodo_destinazione'],
				'riferimento' => $_REQUEST['riferimento'],
				'fascia_eta' => $_REQUEST['fascia_eta'],
				'prezzo' => $_REQUEST['prezzo'],
				'iscritti_max' => $_REQUEST['iscritti_max'],
				'calendario_dal' => $_REQUEST['calendario_dal'],
				'calendario_al' => $_REQUEST['calendario_al'],
				'intervallo_max' => $_REQUEST['intervallo_max'],
				'saltare' => $saltare
			),
			'lista' => array()
		);

		// debug
		// print_r( $_REQUEST );
		// print_r( $workspace );
		// die();

		// codici richiesti esplicitamente
		if( ! empty( $_REQUEST['codici'] ) ) {
			$workspace['lista'] = array_replace_recursive(
				$workspace['lista'],
				array_map( 'trim', explode( ',', $_REQUEST['codici'] ) )
			);
		}

		// condizioni base
		$whr = array(
			array( 's' => $_REQUEST['periodo_partenza'] )
		);

		// disciplina
		if( ! empty( $_REQUEST['disciplina'] ) ) {
			$ljn = ' LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id';
			$cnd = ' AND progetti_categorie.id_categoria = ?';
			$whr[] = array( 's' => $_REQUEST['disciplina'] );
		}

		// codici ricavati da periodo e categoria
		$workspace['lista'] = array_replace_recursive(
			$workspace['lista'],
			mysqlSelectColumn(
				'id',
				$cf['mysql']['connection'],
				'SELECT * FROM progetti ' . $ljn . ' WHERE id_periodo = ?' . $cnd,
				$whr
			)
		);

		// codici esclusi
		if( ! empty( $_REQUEST['esclusi'] ) ) {
			$workspace['lista'] = array_diff(
				$workspace['lista'],
				array_map( 'trim', explode( ',', $_REQUEST['esclusi'] ) )
			);
		}

		// debug
		// print_r( $workspace );

		// creo il job
		$status['inserimento'] = mysqlQuery(
			$cf['mysql']['connection'],
			'INSERT INTO job ( nome, job, iterazioni, delay, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ?, ? )',
			array(
				array( 's' => 'duplicazione corsi' ),
				array( 's' => '_mod/_0920.corsi/_src/_api/_job/_corsi.duplicazione.php' ),
				array( 's' => 5 ),
				array( 's' => 3 ),
				array( 's' => 1 ),
				array( 's' => json_encode( $workspace ) )
			)
		);

	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
