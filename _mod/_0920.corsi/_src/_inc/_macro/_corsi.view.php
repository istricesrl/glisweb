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
	$ct['view']['table'] = 'corsi';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'corsi.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        'nome' => 'nome',
        'fasce' => 'fasce',
        'discipline' => 'discipline',
        'livelli' => 'livelli',
        'stato' => 'stato'            
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'cliente' => 'text-left d-none d-md-table-cell',
        'stato' => 'd-none',
        'tipologia' => 'text-left',
        'nome' => 'text-left',
        'categorie' => 'text-left',
        'discipline' => 'text-left',
        'livelli' => 'text-left',
        'stato' => 'text-left'  
    );

        // tendina categorie progetti
	$ct['etc']['select']['discipline'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

	$ct['etc']['select']['classi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_classe = 1'
	);

	$ct['etc']['select']['fasce'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_fascia = 1'
	);

    $ct['etc']['select']['stati'] = array(
        array( 'id' => 'attivo', '__label__' => 'attivo'),
        array( 'id' => 'concluso', '__label__' => 'concluso'),
        array( 'id' => 'futuro', '__label__' => 'futuro'),
    );

    $ct['etc']['include']['filters'] = 'inc/corsi.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
