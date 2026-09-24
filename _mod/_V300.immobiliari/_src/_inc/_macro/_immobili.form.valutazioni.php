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

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'valutazioni.immobiliari.form';
    $ct['view']['open']['table'] = 'valutazioni';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'valutazioni.immobiliari.form';
    
    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_immobile';

	$ct['view']['cols'] = array(
        'id' => '#',
        'timestamp_valutazione' => 'data',
        'anagrafica' => 'esecutore',
        'condizione' => 'condizione',
	    'disponibilita' => 'disponibilità',
        'id_immobile' => 'id_immobile',
        'mq_calpestabili' => 'mq calpestabili',
	    'mq_commerciali' => 'mq commerciali',
        'classe_energetica' => 'classe energetica'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id_immobile' => 'd-none'
    );

	// preset filtro righe documento
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_immobile']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( isset($ct['view']['data']) ){
        foreach( $ct['view']['data'] as &$row ) {
            if( isset($row['timestamp_valutazione']) ){
                $row['timestamp_valutazione'] = date( 'd/m/Y H:i',$row['timestamp_valutazione']);
            }
        }
    }
