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
    // la vista e' caratteristiche_prodotti_view e non caratteristiche_view: sono due tabelle
    // diverse, e la chiave esterna articoli_caratteristiche.id_caratteristica punta a
    // caratteristiche_prodotti. Leggendo da caratteristiche_view la tendina restava vuota su
    // qualunque deploy che non popoli anche la tabella caratteristiche, e senza tendina la scheda
    // non permette di assegnare nessuna caratteristica all'articolo. E' la stessa vista che usa
    // gia' la scheda gemella del prodotto, _prodotti.form.caratteristiche.php
	$ct['etc']['select']['caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM caratteristiche_prodotti_view'
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
