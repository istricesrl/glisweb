<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'contratti';

	// gestione richiesta in lista d'attesa
	if( isset( $_REQUEST['idAttesa'] ) ) {
		if( ! isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) || empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
			$_REQUEST[ $ct['form']['table'] ]['id_progetto'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_progetto FROM anagrafica_progetti WHERE id = ?', array( array( 's' => $_REQUEST['idAttesa'] ) ) );
			$ct['etc']['richiedente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_anagrafica FROM anagrafica_progetti WHERE id = ?', array( array( 's' => $_REQUEST['idAttesa'] ) ) );
		} else {
			// TODO qui archiviare la richiesta
		}
	}

    // tendina ruoli progetti
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
    );

    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_anagrafica_view WHERE se_contratti = 1'
    );

    // tendina emittenti
	$ct['etc']['select']['agenzia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static '
    );
    
    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view_static '
    );

	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_iscrizione = 1'
    );

	$ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

	/*
	if( isset( $_SESSION['__work__'] ) ){

		if( isset( $_SESSION['__work__']['id_anagrafica'] ) ){
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] = $_SESSION['__work__']['id_anagrafica'];
		}

		if( isset( $_SESSION['__work__']['id_progetto'] ) ){
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_progetto'] = $_SESSION['__work__']['id_progetto'];
		}
	}*/

	// NOTA i default da __work__ qui sono gestiti a livello di template Twig ma può avere senso gestirli qui?

	if( isset( $_SESSION['__work__'] ) ) {

		if( isset( $_SESSION['__work__']['anagrafica']['items'] ) ) {
			$anagrafica = reset( $_SESSION['__work__']['anagrafica']['items'] );
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] = $anagrafica['id'];
		}

		if( isset( $_SESSION['__work__']['iscrizioni']['items'] ) ) {
			$corso = reset( $_SESSION['__work__']['iscrizioni']['items'] );
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_progetto'] = $corso['id'];
		}

	}

	// TODO documentare bene questa cosa dei "finti" subform, i problemi legati alle chiavi, eccetera
	// dov'è che questa cosa è fatta bene? mi ricordo di aver gestito bene la cosa sia a livello di macro PHP sia a livello di template Twig, ma
	// non mi ricordo dove... poi c'è anche da differenziare il caso dei subform semplici tipo questo dal caso dei subform complessi tipo
	// i metadati... secondo me è sempre qua in zona corsi o iscrizioni o comunque in un modulo che ho gestito soprattutto io

    // ...
    if( isset( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] ) ) {
		arraySortBy( 'data_inizio', $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
    	$ct['etc']['sub']['primo_rinnovo']['key'] = $_REQUEST[ $ct['form']['table'] ]['rinnovi'][0];
	}

	// ...
	$ct['etc']['sub']['primo_rinnovo']['key'] = 0;

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {

		$ct['etc']['articoli'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT articoli.id, articoli.nome, metadati.nome AS meta, metadati.testo FROM articoli LEFT JOIN metadati ON metadati.id_articolo  = articoli.id AND metadati.nome = "periodo_iscrizione" WHERE articoli.id_prodotto = ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
		);

		$articoli = array();
		foreach( $ct['etc']['articoli'] as &$a ) {
	
			$a['prezzi'] = mysqlCachedIndexedQuery(
				$cf['memcache']['index'],
				$cf['memcache']['connection'],
				$cf['mysql']['connection'],
				'SELECT * FROM prezzi WHERE prezzi.id_articolo = ? AND prezzi.id_listino = 1',
				array( array( 's' => $a['id'] ) )
			);

			$articoli[] = $a['id'];

		}

		if( isset( $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'] ) ) {

			if( isset( $_SESSION['__work__']['anagrafica']['items'][ $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'] ] ) ) {
				unset( $_SESSION['__work__']['anagrafica']['items'][ $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'] ] );
			}

			$ct['etc']['carrello'] = mysqlSelectValue(
				$cf['mysql']['connection'],
				'SELECT id_carrello FROM carrelli_articoli WHERE destinatario_id_anagrafica = ? AND id_articolo IN (\'' . implode( '\',\'', $articoli ) . '\')',
				array( array( 's' => $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'] ) )
			);

		}

		// var_dump( $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'] );
		// echo 'SELECT id_carrello FROM carrelli_articoli WHERE destinatario_id_anagrafica = ? AND id_articolo IN (\'' . implode( '\',\'', $articoli ) . '\')' . PHP_EOL;
		// print_r( $_REQUEST['contratti']['contratti_anagrafica'] );
		// print_r( $articoli );
		// var_dump( $ct['etc']['carrello'] );
		// die();

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
