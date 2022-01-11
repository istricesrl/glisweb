<?php


    // tabella gestita
	$ct['form']['table'] = 'cron';

         // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 OR se_dipendente = 1 OR se_interinale = 1'
    );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view'
    );

         // tendina anagrafica
	$ct['etc']['select']['contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM contratti_view'
    );


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
