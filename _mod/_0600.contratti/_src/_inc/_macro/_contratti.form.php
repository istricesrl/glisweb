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


    // tendina ruoli progetti
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
    );

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
