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
	$ct['view']['table'] = 'caratteristiche';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'caratteristiche.prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left'
	);

    // tendina dei genitori: solo quelli che hanno figli, gli unici per cui il filtro ha senso
    $ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT DISTINCT g.id, g.__label__ FROM caratteristiche_view AS g INNER JOIN caratteristiche AS f ON f.id_genitore = g.id ORDER BY g.__label__'
    );

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/caratteristiche.prodotti.view.filters.html';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
