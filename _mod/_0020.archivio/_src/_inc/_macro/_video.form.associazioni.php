<?php

    /**
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'video';

    // tendina pagine
	$ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM pagine_view' 
    );

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' 
    );

    // tendina categorie prodotti
	$ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_prodotti_view' 
    );

    // tendina ruoli
	$ct['etc']['select']['ruoli'] = mysqlQuery( 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM ruoli_video_view' 
    );

	/**
	 * tendina anagrafica — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['anagrafica'] = array();

    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
