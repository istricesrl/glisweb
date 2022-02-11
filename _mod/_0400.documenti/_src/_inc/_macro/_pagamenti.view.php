<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['view']['table'] = 'pagamenti';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagamenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_ora_scadenza' => 'scadenza',
		'documento' => 'documento',
        'nome' => 'nome',
        'emittente' => 'da',
        'destinatario' => 'a',
#		'mastro_provenienza' => 'scarico',
#		'mastro_destinazione' => 'carico',
        'importo_netto_totale' => 'importo netto',
        'data_ora_pagamento' => 'pagato'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'documento' => 'text-left',
        'numero' => 'text-left',
        'data_ora_scadenza' => 'no-wrap',
        'data_ora_pagamento' => 'no-wrap',
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'destinatario' => 'text-left',
        'tipologia' => 'text-left',
        'importo_netto_totale' => 'text-right' 
    );

	// RELAZIONI CON IL MODULO MASTRI
	if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/pagamenti.view.filters.html';

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1 ORDER BY __label__'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   