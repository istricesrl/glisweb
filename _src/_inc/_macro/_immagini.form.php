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

    // tendina pagine
	$ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM pagine_view' 
    );

    // tendina eventi
#	$ct['etc']['select']['id_evento'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM eventi_view' );

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' 
    );

    // tendina categorie prodotti
	$ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_prodotti_view' 
    );

    // tendina ruoli
	$ct['etc']['select']['ruoli'] = mysqlQuery( 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM ruoli_immagini_view' 
    );

    // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina ruoli anagrafica
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlQuery( 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM ruoli_immagini_anagrafica_view' 
    );

    // tendina delle lingue
	$ct['etc']['select']['lingue'] = &$cf['localization']['languages'];

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
