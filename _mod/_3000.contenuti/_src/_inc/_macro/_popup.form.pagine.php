<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'popup';

    // view gestita
    $ct['view']['table'] = 'popup_pagine';

    // tendina anagrafica
	$ct['etc']['select']['popup_pagine'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM popup_pagine_view'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
