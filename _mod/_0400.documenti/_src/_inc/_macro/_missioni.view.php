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
	$ct['view']['table'] = 'missioni';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'missioni.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'cod.',
        // 'numero' => 'num.',
        // 'sezionale' => 'sez.',
        'data' => 'data',
#        'emittente' => 'emittente',
#        'destinatario' => 'destinatario',
        'nome' => 'nome',
#        '__label__' => 'nome',
        'documenti_antecedenti' => 'evade',
        'documenti_successivi' => 'controllo',
        'timestamp_chiusura' => 'chiusura',
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left no-wrap',
#        'numero' => 'text-left',
        'codice' => 'no-wrap',
        'data' => 'no-wrap', 
        '__label__' => 'text-left no-wrap',
        'nome' => 'text-left no-wrap',
        'destinatario' => 'text-left no-wrap',
        'emittente' => 'text-left no-wrap',
        'tipologia' => 'text-left no-wrap',
        'totale' => 'text-right',
        'documenti_antecedenti' => 'text-left',
        'documenti_successivi' => 'text-left',
        'timestamp_chiusura' => 'no-wrap',
    );

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id   , __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__'
	);

    // inclusione filtri speciali
//	$ct['etc']['include']['filters'] = 'inc/ddt.magazzini.view.filters.html';
	$ct['view']['__restrict__']['timestamp_chiusura']['NL'] = true;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    foreach( $ct['view']['data'] as $key => &$row ) {

        // $row['timestamp_chiusura'] = date( 'Y-m-d H:i', $row['timestamp_chiusura']);

	}