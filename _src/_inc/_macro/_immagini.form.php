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

	// tendina categorie
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

	$ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
	);

	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM prodotti_view'
	);

	// tendina categorie
	$ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM pagine_view'
	);

	// tendina categorie
	$ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
	);

	// tendina categorie
	$ct['etc']['select']['categorie_risorse'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_risorse_view'
	);

	// tendina categorie
	$ct['etc']['select']['categorie_notizie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_notizie_view'
	);

	// tendina categorie
	$ct['etc']['select']['categorie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view'
	);

	$ct['etc']['select']['risorse'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM risorse_view'
	);

	$ct['etc']['select']['notizie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM notizie_view'
	);

	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view'
	);

	$ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM indirizzi_view'
	);

	$ct['etc']['select']['edifici'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM edifici_view'
	);

	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM immobili_view'
	);

	$ct['etc']['select']['contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM contratti_view'
	);
	$ct['etc']['select']['valutazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM valutazioni_view'
	);
	$ct['etc']['select']['rinnovi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM rinnovi_view'
	);

	
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
