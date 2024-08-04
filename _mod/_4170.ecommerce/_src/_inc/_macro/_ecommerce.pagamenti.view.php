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
/*
    // id della vista
    $ct['view']['id'] = md5(
        $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] .
        ( ( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id'] : NULL )
    );
*/
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagamenti.amministrazione.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_scadenza' => 'scadenza',
		'documento' => 'documento',
        'nome' => 'nome',
        'emittente' => 'da',
        'destinatario' => 'a',
		'id_tipologia_documento' => 'id_tipologia_documento',
#		'mastro_destinazione' => 'carico',
        'importo_lordo_finale' => 'importo',
        'data_ora_pagamento' => 'pagato'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id_tipologia_documento' => 'd-none',
        'nome' => 'text-left',
        'documento' => 'text-left',
        'numero' => 'text-left',
        'data_scadenza' => 'no-wrap',
        'data_ora_pagamento' => 'no-wrap',
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'destinatario' => 'text-left',
        'tipologia' => 'text-left',
        'importo_lordo_finale' => 'text-right' 
    );

	// RELAZIONI CON IL MODULO MASTRI
	if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/ecommerce.pagamenti.view.filters.html';

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina tipologie
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

    // tendina tipologie
	$ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, nome AS __label__ FROM modalita_pagamento_view'
	);

    // tendina tipologie
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT account.id, concat( anagrafica.nome, " ", cognome ) AS __label__ 
        FROM account 
        INNER JOIN account_gruppi ON account_gruppi.id_account = account.id
        INNER JOIN anagrafica ON anagrafica.id = account.id_anagrafica 
        WHERE account_gruppi.id_gruppo = 2
        ORDER BY __label__'
	);

/*
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
	    'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__'
	);
*/
    // tendina aziende
	$ct['etc']['select']['aziende'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_tipologia_documento']['EQ'] )  ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_tipologia_documento']['EQ'] = 1;
    }
*/

#    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_pagamento']['NL'] ) ) {
    $ct['view']['__filters__']['timestamp_pagamento']['NL'] = 1;
#    }

/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__']['__filters__']['id_emittente']['EQ'] )  ) {
        $_REQUEST['__view__']['__filters__']['id_emittente']['EQ'] = trovaIdAziendaGestita();
    }
*/

#    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__']['__filters__']['id_emittente|id_destinatario']['EQ'] ) ) {
    $ct['view']['__filters__']['id_emittente|id_destinatario']['EQ'] = trovaIdAziendaGestita();
#    }

    // debug
    // die( print_r( $_REQUEST['__view__']['__filters__'], true ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_pagamento']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_pagamento']['EQ'] ) ) {

        if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_pagamento']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_pagamento']['EQ'] ) ) {
        
            if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_pagamento']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_pagamento']['EQ'] ) ) {
        
                if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_account_inserimento']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_account_inserimento']['EQ'] ) ) {
        
                    // die('CALCOLO TOTALI PER OPERATORE');

                    $ct['etc']['totali']['livello'] = 'operatore';
                    $ct['etc']['totali']['contanti'] = 100;
                    $ct['etc']['totali']['carte'] = 200;

                } else {

                    // die('CALCOLO TOTALI PER TUTTI GLI OPERATORI');

                    $ct['etc']['totali']['livello'] = 'tutti gli operatori';
                    $ct['etc']['totali']['contanti'] = 150;
                    $ct['etc']['totali']['carte'] = 250;

                }
            
            }
        
        }
    
    }
