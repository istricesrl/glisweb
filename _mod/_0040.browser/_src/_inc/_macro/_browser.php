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
	$path = DIR_VAR_CONTENUTI . ( ( empty( $_REQUEST['path'] ) ) ? NULL : str_replace( DIR_VAR_CONTENUTI, NULL, $_REQUEST['path'] ) );
	$base = $path = str_replace( '../', NULL, $path );
	$base = shortPath( $base );
	$parent = dirname( $path );

	// TODO ognuna delle azioni seguenti dev'essere preceduta da un controllo sui privilegi dell'utente corrente
	// bisogna essere sicuri che i guest non possano agire sul filesystem

    // creazione cartella
	if( isset( $_REQUEST['cartella'] ) ) {
		$cartella = $path . $_REQUEST['cartella'];
		// die( 'creo ' . $cartella );
	    checkFolder( $cartella );
	}

    // cancellazione file
	if( isset( $_REQUEST['rmfile'] ) ) {
		$rmfile = $path . $_REQUEST['rmfile'];
		// die( 'cancello: ' . $rmfile );
	    deleteFile( $rmfile );
	}

    // cancellazione cartella
	if( isset( $_REQUEST['rmfolder'] ) ) {
	    $rmfolder = $path . $_REQUEST['rmfolder'];
		// die( 'cancello: ' . $rmfolder );
	    recursiveDelete( $rmfolder );
	}

	// spostamento file
	if( isset( $_REQUEST['mvfile'] ) ) {
		$mvfile = $path . $_REQUEST['mvfile'];
		$mvdest = DIR_BASE . $_REQUEST['mvfilepath'] . '/' . basename( $_REQUEST['mvfile'] );
		// die( 'sposto ' . $mvfile . ' su ' . $mvdest );
		rename( $mvfile, $mvdest );
	}

	// spostamento cartella
	if( isset( $_REQUEST['mvfolder'] ) ) {
		$mvfolder = $path . $_REQUEST['mvfolder'];
		$mvdest = DIR_BASE . $_REQUEST['mvfolderpath'] . '/' . basename( $_REQUEST['mvfolder'] );
		// die( 'sposto ' . $mvfolder . ' su ' . $mvdest );
		if( file_exists( $mvdest ) ) {
			die( $mvdest . ' esiste già' );
		} else {
			rename( $mvfolder, $mvdest );
		}
	}

	// tendina directory
	foreach( dirTree2array( DIR_VAR_CONTENUTI ) as $d ) {
		$l = str_replace( DIR_VAR_CONTENUTI, NULL, $d );
		if( empty( $l ) ) { $l = '(root)'; }
		$ct['etc']['select']['cartelle'][ $d ] = array(
			'id' => shortPath( $d ),
			'__label__' => str_repeat( '- ', substr_count( $l, '/' ) ) . basename( $l )
		);
	}

	// ordinamenti
	ksort( $ct['etc']['select']['cartelle'], SORT_STRING );

    // liste
	$dirs = array();
	$files = array();

    // GET string
	$ct['browse']['get'] = http_build_query( $_GET ) . '&path=';

    // directory superiore
	if( $path != DIR_VAR_CONTENUTI ) {
	    $dirs[] = $parent;
	}

    // controllo che la directory esista
	if( is_dir( $path ) ) {
	    foreach( new DirectoryIterator( $path ) as $f ) {
//	if( is_dir( $path ) ) {
//	    foreach( new DirectoryIterator( $path ) as $f ) {
			if( ! $f->isDot() ) {
				if( $f->isFile() ) {
					$files[ $f->getFilename() ] = array(
						'path' => $base.$f->getFilename(),
						'size' => writeByte( $f->getSize() ) );
				} elseif( $f->isDir() ) {
					$dirs[ $f->getFilename() ] = $path.$f->getFilename();
				}
			}
	    }
	} else {
		die( $path . ' non esiste' );
	}

	// ordinamenti
	ksort( $dirs, SORT_STRING );
	ksort( $files, SORT_STRING );

    // array $ct
	$ct['browse']['files'] = $files;
	$ct['browse']['dirs'] = $dirs;
	$ct['browse']['parent'] = $parent;
	$ct['browse']['path'] = $path;
	$ct['browse']['base'] = $base;

	// debug
	// echo '<pre>'.print_r( $ct['browse'], true ).'</pre>';
	// echo $path.'<br>';
	// echo $parent.'<br>';
	// echo $base.'<br>';
	// print_r( $files );
	// print_r( $dirs );
	// print_r( $ct );
	// die( 'wtf' );
