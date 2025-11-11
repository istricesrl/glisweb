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

    // tendina tipologie embed
	$ct['etc']['select']['embed'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM embed_view' );


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
