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
	$ct['form']['table'] = 'documenti';

    // tabella della vista
	$ct['view']['table'] = 'pagamenti';

    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

        // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagamenti.form';
    $ct['view']['open']['table'] = 'pagamenti';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'pagamenti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_documento';

	$ct['view']['cols'] = array(
        'id' => '#',
        'data_ora_scadenza' => 'scadenza',
        'nome' => 'nome',
		'modalita_pagamento' => 'modalita pagamento',
		'iban' => 'iban',
        'importo_lordo_totale' => 'importo',
        'data_ora_pagamento' => 'pagato',
		'id_documento' => 'id_documento'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'importo_lordo_totale' => 'text-right',
        'quantita' => 'text-right',
		'totale_riga' => 'text-right',
        'id_documento' => 'd-none',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data_lavorazione' => 'no-wrap', 
        'data_ora_pagamento' => 'no-wrap', 
#        'tipologia' => 'text-left',
		'id_articolo' => 'text-left'
    );

	// RELAZIONI CON IL MODULO MASTRI
	if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

    // preset filtro righe documento
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
		$ct['view']['__restrict__']['id_documento']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
