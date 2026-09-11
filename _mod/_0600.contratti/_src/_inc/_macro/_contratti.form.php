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
    $ct['form']['table'] = 'contratti';


    /**
     * tendina anagrafica — disattivata il 2026-09-10, il campo ha gia' la ricerca REST
     *
     * Era `SELECT id, __label__ FROM anagrafica_view` senza WHERE. Su un deploy con l'anagrafica
     * grande ( Polmasi: 55.372 righe ) sono circa 5 MB serializzati: oltre il tetto di 1 MB di
     * memcached, quindi la scrittura in cache fallisce con l'errore 37 e la query si rifa' a ogni
     * apertura del form.
     *
     * Non serviva. Il campo e' reso da `frm.selectBox()` con `populate-api="anagrafica"`
     * ( _src/_templates/_athena/bin/contratti.form.sub.html ): quando la macro riceve un `api` NON stampa
     * nemmeno le `<option>` — rende un hidden e lascia cercare via REST a
     * `_src/_js/_lib/_selectbox.js` da tre caratteri in su, e l'etichetta del valore gia' scelto
     * la prende da `/api/anagrafica/<id>`. La lista serviva al piu' a risolvere quell'etichetta.
     */
    $ct['etc']['select']['anagrafica'] = array();

    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_anagrafica_view WHERE se_contratti = 1'
    );

    // tendina emittenti
	$ct['etc']['select']['agenzia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static '
    );
    
    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view '
    );

    // tendina immobili
	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM immobili_view '
    );

    // tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view'
    );

    // tendina tipologia rinnovo
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_rinnovi_view WHERE se_contratti = 1'
    );

	// ...
	if( ! isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
		$_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] = trovaIdAziendaGestita();
		$_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_ruolo'] = 35;
		if( isset( $_REQUEST['__preset__']['contratti']['id_anagrafica'] ) ) {
			$_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][1]['id_anagrafica'] = $_REQUEST['__preset__']['contratti']['id_anagrafica'];
			$_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][1]['id_ruolo'] = 32;
		}
	}

    // macro di default per l'entità contratti
	// require '_contratti.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
