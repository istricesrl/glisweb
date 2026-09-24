<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'certificazioni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'certificazioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
#        'tipologia' => 'tipologia',
        '__label__' => 'certificazione'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // inclusione filtri speciali
	// $ct['etc']['include']['filters'] = 'inc/certificazioni.view.filters.html';
/*
    // tendina tipologia
	$ct['etc']['select']['tipologie_certificazioni'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_certificazioni_view'
    );
*/
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
