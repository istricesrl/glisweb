<?php

    // tabella gestita
	$ct['form']['table'] = 'carrelli';

	$ct['etc']['select']['articoli'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM articoli_view' );

	$ct['etc']['timestamp_inserimento'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT timestamp_inserimento FROM carrelli WHERE id = ?', array( array( 's' => $_REQUEST['carrelli']['id'] ) ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
