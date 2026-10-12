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
	$ct['view']['table'] = 'categorie_prodotti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'categorie.prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'codice' => 'codice',
	    '__label__' => 'categoria'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'codice' => 'text-left',
	    '__label__' => 'text-left'
	);

	// preset ordinamento
    $ct['view']['__sort__'] = array(
        'codice' => 'ASC'
    );

    // tendina dei genitori: solo quelli che hanno figli, gli unici per cui il filtro ha senso
    $ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT DISTINCT g.id, g.__label__ FROM categorie_prodotti_view AS g INNER JOIN categorie_prodotti AS f ON f.id_genitore = g.id ORDER BY g.__label__'
    );

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/categorie.prodotti.view.filters.html';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
