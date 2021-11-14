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
	$ct['etc']['select']['tipologie_embed'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_embed_view' );


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
