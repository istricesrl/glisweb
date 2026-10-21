<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


	// tabella gestita
    $ct['form']['table'] = 'valutazioni';

    // tendina per le certificazioni
    $ct['etc']['select']['certificazioni'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM certificazioni_view'
    );

	/**
	 * tendina emittenti — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['emittenti'] = array();

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

 