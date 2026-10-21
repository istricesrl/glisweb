<?php

    /**
     * macro form prodotti caratteristiche
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
	$ct['form']['table'] = 'articoli';

    // tendina caratteristiche
    //
    // l'albero delle caratteristiche, con il percorso come etichetta. Fino al 01/10/2026 stava in caratteristiche_prodotti
    // e la chiave esterna di articoli_caratteristiche puntava li' sui deploy che lo usavano e a caratteristiche nei file
    // di base, per cui la tendina proponeva caratteristiche che il database poteva rifiutare; ora l'albero e'
    // caratteristiche e caratteristiche_prodotti e' una vista su di essa ( patch _202610011700.caratteristiche.albero.sql )
	$ct['etc']['select']['caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM caratteristiche_view'
    );
    
	// tendina icona per caratteristica/opzione presente o meno
	$ct['etc']['select']['se_non_presente'] = array(
	    array( 'id' => NULL, '__label__' => 'sì' ),
	    array( 'id' => 1, '__label__' => 'no' )
	);

	// tendina icona per caratteristica/opzione visibile in menù o meno
	$ct['etc']['select']['se_visibile'] = array(
	    array( 'id' => 1, '__label__' => 'sì' ),
	    array( 'id' => NULL, '__label__' => 'no' )
	);

    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
