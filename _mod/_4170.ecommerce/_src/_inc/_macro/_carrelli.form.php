<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella della vista
	$ct['form']['table'] = 'carrelli';


    // tendina articoli
	$ct['etc']['select']['articoli'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM articoli_view' );
	
	 // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM comuni_view' );


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
	