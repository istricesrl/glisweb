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
        if( ! isset( $ct['form']['__filesystem_mode__'] ) ) {
            $ct['page']['parents']['h1'][ max( array_keys( $ct['page']['parents']['h1'] ) ) ][ LINGUA_CORRENTE ] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $ct['form']['table'] . getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $ct['form']['table'] ) . ' WHERE id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) );
        }
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

    // metadati
    if( isset( $ct['etc']['metadati'] ) ) {
        $sidx = time();
        foreach( $ct['etc']['metadati'] as $metadato => $dettagli ) {

            // metadato di default per sconto secondo corso
            $ct['etc']['sub'][ $metadato ] = array(
                'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) : $sidx++ ),
                'nome' => $metadato 
            );
    
            // ricerca metadato per sconto secondo corso
            if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
                foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
                    if( $m['nome'] == $metadato ) {
                        $ct['etc']['sub'][ $metadato ] = $m;
                        $ct['etc']['sub'][ $metadato ]['idx'] = $k;
                    }
                }
            }
    
        }
    }

    // timer
	timerCheck( $cf['speed'], '-> fine logiche di gestione metadati modulo' );

    // debug
	// print_r( $ct['page'] );
