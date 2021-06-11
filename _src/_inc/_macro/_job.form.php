<?php


    // tabella gestita
	$ct['form']['table'] = 'job';

    // tendina
	$ct['etc']['select']['job'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM job_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
