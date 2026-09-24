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
    $ct['form']['table'] = 'anagrafica_certificazioni';

    // tendina anagrafica
    /**
     * tendina anagrafica — disattivata il 2026-09-10, il campo ha gia' la ricerca REST
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE. Su un deploy con
     * l'anagrafica grande ( Polmasi: 55.372 righe ) sono 4,58 MB serializzati, che compressi fanno
     * esattamente 1,00 MB: sopra il tetto di memcached, quindi la scrittura in cache fallisce con
     * l'errore 37 e la query si rifa' a ogni apertura del form.
     *
     * Non serviva. Il campo e' reso da `frm.selectBox()` con `populate-api="anagrafica"`
     * ( `_src/_templates/_athena/anagrafica.certificazioni.form.html:52` ): quando la macro riceve
     * un `api` NON stampa nemmeno le `<option>` — rende un hidden e lascia cercare via REST a
     * `_src/_js/_lib/_selectbox.js` da tre caratteri in su.
     *
     * NB: la tendina `emittenti` qui sotto fa la stessa query e viene svuotata anche lei, ma per un
     * motivo diverso: il suo campo usa `frm.select()` senza api, quindi la lista la stamperebbe
     * davvero — solo che il campo e' dentro un commento HTML. Il dettaglio e' nel blocco qui sotto.
     */
    $ct['etc']['select']['anagrafica'] = array();

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
