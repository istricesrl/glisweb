<?php

    /**
     * macro view archivio anagrafica
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = 'anagrafica_archiviati';

    // tabella per l'apertura
	$ct['view']['open']['table'] = 'anagrafica';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'anagrafica.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail',
	    'categorie' => 'categorie'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left no-wrap',
	    'telefoni' => 'text-left',
	    'mail' => 'text-left',
	    'categorie' => 'text-left'
	);

    // colonne custom
	if( isset( $_SESSION['account']['se_commerciale'] ) && ! empty( $_SESSION['account']['se_commerciale'] ) ) {
	    arrayInsertAssoc( '__label__', $ct['view']['cols'], array( 'provincia' => 'provincia' ) );
	    arrayInsertAssoc( '__label__', $ct['view']['class'], array( 'provincia' => 'text-left' ) );
	    $ct['view']['cols']['agente'] = 'agente';
	    $ct['view']['class']['agente'] = 'text-left';
	}

    // template filtri custom
	$ct['etc']['include']['filters'] = 'inc/anagrafica.view.filters.html';

    // tendina categoria
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
