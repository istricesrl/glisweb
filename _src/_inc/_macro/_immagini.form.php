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
	$ct['form']['table'] = 'immagini';

    // tendina dei tagli
	$ct['etc']['select']['tagli'] = array(
	    array( 'id' => 'START', '__label__' => 'peso iniziale' ),
	    array( 'id' => 'MIDDLE', '__label__' => 'peso centrale' ),
	    array( 'id' => 'END', '__label__' => 'peso finale' )
	);

    // informazioni sull'immagine
	if( isset( $_REQUEST['immagini']['path'] ) ) {

	    // dimensioni
		$ds = imageSize( $_REQUEST['immagini']['path'] );
		$ct['etc']['formats']['ORIGINAL '.$ds['w'].'x'.$ds['h'].'px'] = array( 'path' => $_REQUEST['immagini']['path'], 'size' => writeByte( getFileSize( $_REQUEST['immagini']['path'] ) ) );

	    // altri formati
		foreach( $cf['image']['formats'] as $k => $v ) {
		    $f = ( ( $k == 'l' ) ? 'LANDSCAPE' : 'PORTRAIT' );
		    foreach( $v as $j ) {
                $y = 'var/immagini/' . $j . $k . '/' . basename( $_REQUEST['immagini']['path'] );
                if( file_exists( DIR_BASE . $y ) ) {
                    $ct['etc']['formats'][ $f . ' ' . $j . 'px' ] = array( 'path' => $y, 'size' => writeByte( getFileSize( DIR_BASE . $y ) ) );
                }
		    }
		}

	}
	
	$ct['etc']['select']['orientamenti'] = array( 
	    array( 'id' => NULL, '__label__' => 'automatico' ),
	    array( 'id' => 'L', '__label__' => 'landscape' ),
	    array( 'id' => 'P', '__label__' => 'portrait' ),
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
