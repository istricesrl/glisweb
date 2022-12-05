<?php

    /**
     *
     *
     *
     *
     *
     *
     * -# dichiarazione tabella della vista
     * -# dichiarazione della pagina di apertura
     * -# dichiarazione delle colonne della vista
     * -# dichiarazione delle classi delle colonne
     * -# aggiunta delle colonne variabili
     * -# inclusione dei filtri speciali
     * -# popolazione tendine
     * -# trasformazioni
     * -# macro di default
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

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = 'anagrafica_attivi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'anagrafica.form';
	$ct['view']['open']['table'] = 'anagrafica';

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
	    'telefoni' => 'text-left d-none d-md-table-cell',
	    'mail' => 'text-left d-none d-md-table-cell',
	    'categorie' => 'text-left'
	);

    // colonne variabili
	if( isset( $_SESSION['account']['se_commerciale'] ) && ! empty( $_SESSION['account']['se_commerciale'] ) ) {
#	    arrayInsertAssoc( '__label__', $ct['view']['cols'], array( 'provincia' => 'provincia' ) );
#	    arrayInsertAssoc( '__label__', $ct['view']['class'], array( 'provincia' => 'text-left' ) );
	    $ct['view']['cols']['agente'] = 'agente';
	    $ct['view']['class']['agente'] = 'text-left';
	}

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/anagrafica.view.filters.html';

    // tendina categoria
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
