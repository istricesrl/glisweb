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

    // se è presente un id, sostituisco il titolo della pagina corrente con la __label__ dell'oggetto
	if( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
	    $ct['page']['query'][ LINGUA_CORRENTE ] = '?' . $ct['form']['table'] . '[id]=' . $_REQUEST[ $ct['form']['table'] ]['id'];
	    $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] .= $ct['page']['query'][ LINGUA_CORRENTE ];
	    $ct['page']['parents']['h1'][ max( array_keys( $ct['page']['parents']['h1'] ) ) ][ LINGUA_CORRENTE ] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $ct['form']['table'] . getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $ct['form']['table'] ) . ' WHERE id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) );
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ] . '&' . $ct['form']['table'] . '[__method__]=get';
	    $backmd5 = md5( $backurl );
	    $_SESSION['backurls'][ $backmd5 ] = $backurl;
		$ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
#		echo 'backurl('.$backmd5.')='.$backurl;
#	} elseif( isset( $ct['form']['table'] ) && ! empty( $ct['form']['table'] ) ) {
	} else {
	    $backurl = $ct['page']['parents']['path'][ max( array_keys( $ct['page']['parents']['path'] ) ) ][ LINGUA_CORRENTE ];
	    $backmd5 = md5( $backurl );
	    $_SESSION['backurls'][ $backmd5 ] = $backurl;
	    $ct['page']['backurl'][ LINGUA_CORRENTE ] = $backmd5;
		if( isset( $ct['form']['table'] ) ) {
			$ct['page']['etc']['tabs'] = array( $ct['page']['id'] );
		}
	}

    // timer
	timerCheck( $cf['speed'], '-> fine logiche di gestione di default' );

    // debug
	// print_r( $ct['page'] );
