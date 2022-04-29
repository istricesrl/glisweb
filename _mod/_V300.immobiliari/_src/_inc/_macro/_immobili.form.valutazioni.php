<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
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
	$ct['form']['table'] = 'immobili';

    // tabella della vista
	$ct['view']['table'] = 'valutazioni';

    // id della vista
   	# $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'valutazioni.form';
    $ct['view']['open']['table'] = 'valutazioni';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'valutazioni.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_immobile';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'valutazione',
        'timestamp_valutazione' => 'data valutazione',
        'id_immobile' => 'id_immobile'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
        'id_immobile' => 'd-none'
	);


	// preset filtro righe documento
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_immobile']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    if( isset($ct['view']['data']) ){
        foreach( $ct['view']['data'] as &$row ) {
            if( isset($row['timestamp_valutazione']) ){
                $row['timestamp_valutazione'] = date( 'd/m/Y H:i',$row['timestamp_valutazione']);
            }
        }
    }
