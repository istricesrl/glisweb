<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella corrente
	$tb = $ct['form']['table'];

    // se è presente un id, sostituisco il titolo della pagina corrente con la __label__ dell'oggetto
	if( isset( $_REQUEST[ $tb ]['id'] ) && ! empty( $_REQUEST[ $tb ]['id'] ) ) {
	    $ct['page']['query'][ LINGUA_CORRENTE ] = '?' . $tb . '[id]=' . $_REQUEST[ $tb ]['id'];
	    $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] .= $ct['page']['query'][ LINGUA_CORRENTE ];
	    $ct['page']['parents']['h1'][ max( array_keys( $ct['page']['parents']['h1'] ) ) ][ LINGUA_CORRENTE ] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $tb . getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $tb ) . ' WHERE id = ?', array( array( 's' => $_REQUEST[ $tb ]['id'] ) ) );
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] . '&' . $tb . '[__method__]=get';
	    $backmd5 = md5( $backurl );
	    $_SESSION['backurls'][ $backmd5 ] = $backurl;
		$ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
#		echo 'backurl('.$backmd5.')='.$backurl;
#	} elseif( isset( $tb ) && ! empty( $tb ) ) {
	} else {
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ];
	    $backmd5 = md5( $backurl );
	    $_SESSION['backurls'][ $backmd5 ] = $backurl;
	    $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
	    $ct['page']['etc']['tabs'] = array( $ct['page']['id'] );
	}

    // timer
	timerCheck( $cf['speed'], '-> fine logiche di gestione di default' );

    // debug
	// print_r( $ct['page'] );
