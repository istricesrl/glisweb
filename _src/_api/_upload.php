<?php

    /**
     * API file standard
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../_config.php';

    // risposta
	$reply = array();

    // log
	logWrite( 'chiamata API file', 'uploader' );

	// accorcio il path
	shortPath( $_SERVER['HTTP_X_TARGET_FOLDER'] );

	// verifico che il path sia consentito
	if( str_starts_with_array( $_SERVER['HTTP_X_TARGET_FOLDER'], array( 'tmp/', 'var/contenuti/' ) ) ) {

    // TODO verifico che l'utente possa caricare il file
	if( true ) {

	    // dati ricevuti dagli header della richiesta ajax
		$fileName	= $_SERVER['HTTP_X_FILE_NAME'];
		$fileSize	= $_SERVER['HTTP_X_FILE_SIZE'];
		$chunkNumber	= $_SERVER['HTTP_X_CHUNK_NUMBER'];
		$totalChunks	= $_SERVER['HTTP_X_CHUNK_TOTAL'];

	    // log
		logWrite( 'inizio caricamento file: ' . $fileName . ' chunk ' . $chunkNumber . '/' . $totalChunks, 'uploader', LOG_NOTICE );

	    // nome del file scritto
		$collisionCounter = 0;
		$targetFolder = ( isset( $_SERVER['HTTP_X_TARGET_FOLDER'] ) ) ? $_SERVER['HTTP_X_TARGET_FOLDER'] : 'tmp/';
		$targetRelativePath = DIR_BASE . $targetFolder;

	    // controllo il percorso
		checkFolder( $targetFolder );

	    // gestione delle collisioni
		do {

		    $targetFileRelativePath = $targetRelativePath . $fileName;
		    $targetFileAbsolutePath = $targetFolder . $fileName;

		    if( file_exists( $targetFileRelativePath ) ) {

			$collision = true;

			$arrayNomeFile = explode( '.', $fileName );
			$estensione = array_pop( $arrayNomeFile );
			$arrayNomeFile[] = $collisionCounter;
			$arrayNomeFile[] = $estensione;
			$fileName = implode( '.', $arrayNomeFile );

			$collisionCounter++;

		    } else {

			$collision = false;

		    } 

		} while( $collision == true );

	    // nome e percorso dei chunk
		$estensioneChunk = '.part' . sprintf( '%04d' , $chunkNumber );
		$targetFileRelativePathWithChunk = $targetFileRelativePath . $estensioneChunk;

	    // apertura degli stream di input e di output
		$input = fopen( 'php://input' , 'r' );
		$output = fopen( $targetFileRelativePathWithChunk , 'w' );

	    // scrittura dati
		while( $data = fread( $input, 1024 ) ) {

		    fwrite( $output, $data );
		}

	    // chiusura degli stream di input e di output
		fclose( $input );
		fclose( $output );

	    // dimensione del file scritto
		$writeData = filesize( $targetFileRelativePathWithChunk );

	    // se questo chunk era l'ultimo creo il file completo
		if( $chunkNumber == $totalChunks ) {

		    // costruisco la lista dei parziali
			$arrayChunks = glob( $targetFileRelativePath . '.part*' );

		    // apro il file base
			$h = fopen( $targetFileRelativePath , "ab" );

		    // riassemblo il file originale...
			foreach( $arrayChunks as $chunk ) {

			    // apro il chunk
				$in = fopen( $chunk , "rb" );

				if( $in ) {
				    while( $buff = fread( $in, 1048576 ) ) {
					fwrite( $h , $buff );
				    }
				}

				fclose( $in );
				unlink( $chunk );

			}

		    // chiudo il file base
			fclose( $h );

		}

	    // risposta ajax
		$reply['debug']				= 'on';
		$reply['fileSize']			= $fileSize;
		$reply['writtenData']			= $writeData;
		$reply['fileUrl']			= $cf['site']['url'].$targetFileAbsolutePath;
		$reply['filePath']			= $targetFileAbsolutePath;

	}

} else {
	$reply['error'][] = 'percorso non consentito: ' . $_SERVER['HTTP_X_TARGET_FOLDER'];
}

    // invio risposta
	buildJson( $reply );
