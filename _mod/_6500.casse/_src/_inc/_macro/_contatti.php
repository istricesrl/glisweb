<?php

    $ct['form']['table'] = 'contatti';

	if(  isset( $_REQUEST['anagrafica']['id'] ) && !empty($_REQUEST['anagrafica']['id']) ){
		$ct['etc']['id_cliente'] = $_REQUEST['anagrafica']['id'];
	}

    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['contatto'] );
        unset( $_REQUEST[ $ct['form']['table'] ]['id'] );
		unset( $_SESSION['assistenza']['id_cliente'] );
		unset( $_SESSION['assistenza']['id_documento_ritiro'] );
        unset( $_SESSION['assistenza']['id_todo_ritiro'] );
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $_SESSION['contatto'] = $_REQUEST[ $ct['form']['table'] ];
    }

    if( isset( $_SESSION['contatto'] ) && !empty( $_SESSION['contatto'])  && !isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM contatti_view WHERE id = ?', array( array( 's' => $_SESSION['contatto']['id']  ) ) );

    }

    // tendina  anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);


    // articoli campagne
	$ct['etc']['select']['campagne'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM campagne_view '
	);

    // tipologie contatti
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contatti_view '
	);



    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

