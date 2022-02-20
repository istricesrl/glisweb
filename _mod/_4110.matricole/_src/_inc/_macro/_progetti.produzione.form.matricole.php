<?php

    /**
     * macro form progetti chiusura
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'progetti';

    // tabella della vista
	$ct['view']['table'] = 'progetti_matricole';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.produzione.matricole.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'progetti.produzione.matricole.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

	$ct['view']['cols'] = array(
        'id' => '#',
#        'tipologia' => 'tipologia',
#        'data' => 'data',
        'matricola' => 'matricola'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'quantita' => 'text-right',
		'totale_riga' => 'text-right',
        'id_documento' => 'd-none',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data' => 'no-wrap', 
#        'tipologia' => 'text-left',
		'id_articolo' => 'text-left'
    );

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		// preset filtro custom progetti aperti
		$ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';