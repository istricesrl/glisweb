<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'valutazioni_certificazioni';

    // tendina anagrafica
	$ct['etc']['select']['valutazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM valutazioni_view'
    );

    /**
     * tendina emittenti — disattivata il 2026-09-10, il campo che la usa e' commentato
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: su Polmasi 55.372 righe,
     * 4,58 MB serializzati e 1,00 MB compressi, cioe' esattamente sopra il tetto di memcached —
     * scrittura in cache fallita ( errore 37 ) e query rifatta a ogni apertura del form.
     *
     * E finiva tutta in pagina per niente: i tre campi che la leggono
     * ( `anagrafica.certificazioni.form.html:60`, `valutazioni.certificazioni.form.html:60`,
     *   `bin/anagrafica.form.certificazioni.sub.html:32` ) sono **dentro un commento HTML**, e un
     * commento HTML non ferma Twig: la macro veniva valutata lo stesso e le 55.263 `<option>`
     * venivano scritte nella pagina, invisibili all'operatore ma spedite al browser.
     *
     * Se un domani il campo emittente si riattiva, non va riacceso questo elenco: si usa
     * `frm.selectBox()` con `populate-api="anagrafica"`, come il campo del certificato qui sopra.
     */
    $ct['etc']['select']['emittenti'] = array();
    
    // tendina per le certificazioni
    $ct['etc']['select']['certificazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM certificazioni_view'
    );
    

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
