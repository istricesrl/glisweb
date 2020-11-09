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

    // base
	$path = ( isset( $_REQUEST['path'] ) ) ? $_REQUEST['path'] : 'var/contenuti/';
	$path = str_replace( '../', NULL, $path );
	$base = DIR_BASE . $path;
	$parent = dirname( $path );

    // creazione cartella
	if( isset( $_REQUEST['cartella'] ) ) {
	    $cartella = DIR_BASE . $path . $_REQUEST['cartella'];
//	    $cartella = $path . $_REQUEST['cartella'];
	    checkFolder( $cartella );
	}

    // liste
	$dirs = array();
	$files = array();

    // GET string
	$ct['browse']['get'] = http_build_query( $_GET ) . '&path=';

    // directory superiore
	if( $path != 'var/contenuti/' ) {
	    $dirs[] = $parent;
	}

    // controllo che la directory esista
	if( is_dir( $base ) ) {
	    foreach( new DirectoryIterator( $base ) as $f ) {
//	if( is_dir( $path ) ) {
//	    foreach( new DirectoryIterator( $path ) as $f ) {
		if( ! $f->isDot() ) {
		    if( $f->isFile() ) {
			$files[] = array( 'path' => $path.$f->getFilename(), 'size' => writeByte( $f->getSize() ) );
		    } elseif( $f->isDir() ) {
			$dirs[] = $path.$f->getFilename();
		    }
		}
	    }
	}

    // array $ct
	$ct['browse']['files'] = $files;
	$ct['browse']['dirs'] = $dirs;
	$ct['browse']['parent'] = $parent;
	$ct['browse']['path'] = $path;

	// debug
	// echo '<pre>'.print_r( $ct['browse'], true ).'</pre>';
	// echo $path.'<br>';
	// echo $parent.'<br>';
	// echo $base.'<br>';
	// print_r( $files );
	// print_r( $dirs );
	// print_r( $ct );
	// die( 'wtf' );

?>
