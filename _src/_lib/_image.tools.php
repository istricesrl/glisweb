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

    /**
     *
     * @todo documentare
     *
     */
    function imageSize( $f ) {

	// inizializzazione variabili
	    fullPath( $f );

	// se il file da processare esiste
	    if( file_exists( $f ) ) {

		// debug
		    // echo $f . PHP_EOL;

		// prelevo le dimensioni del file
		    $d = getimagesize( $f );

		    $w = $d[0];
		    $h = $d[1];

		    $o = ( $w >= $h ) ? 'l' : 'p';
		    $g = ( $w >= $h ) ? $w : $h;
		    $l = ( $w >= $h ) ? $h : $w;

		    $r = ( $o == 'l' ) ? ( $w / $h ) : ( $h / $w );

		// restituzione del risultato
		    return array(
			"h" => $h	// altezza dell'immagine
			,
			"w" => $w	// larghezza dell'immagine
			,
			"r" => $r	// rapporto lato maggiore / lato minore
			,
			"o" => $o	// orientamento dell'immagine
			,
			"g" => $g	// lato maggiore dell'immagine
			,
			"l" => $l	// lato minore dell'immagine
		    );

	    } else {

		// errore
		    return false;

	    }

    }

    /**
     *
     * @todo documentare
     *
     */
    function imageOpen( $f ) {

	fullPath( $f );
	checkfolder( dirname( $f ) );

	switch( exif_imagetype( $f ) ) {
	    case IMAGETYPE_JPEG:
		return imagecreatefromjpeg( $f );
	    break;
	    case IMAGETYPE_PNG:
		return imagecreatefrompng( $f );
	    break;
	    case IMAGETYPE_WEBP:
		return imagecreatefromwebp( $f );
	    break;
	    default:
		return false;
	    break;
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function imageCut( $fs, $d = 1024, $fd = false, $b = 'MIDDLE' ) {

	// handler dell'immagine sorgente
	    $is = imageOpen( $fs );

	// dimensioni dell'immagine
	    $dim = imageSize( $fs );

	// orientamento dell'immagine
	    if( $dim['o'] == 'l' ) {

		// se l'immagine è orizzontale, tengo bloccata l'altezza e croppo la larghezza
		    $ch = $dim['h'];
		    $cw = $d;
		    $x = ( $b == 'START' ) ? 0 : ( ( $b == 'MIDDLE' ) ? round( ( $dim['w'] - $d ) / 2 ) : ( $dim['w'] - $d ) );
		    $y = 0;

	    } else {

		// se l'immagine è verticale, tengo bloccata la larghezza e croppo l'altezza
		    $ch = $d;
		    $cw = $dim['w'];
		    $x = 0;
		    $y = ( $b == 'START' ) ? 0 : ( ( $b == 'MIDDLE' ) ? round( ( $dim['h'] - $d ) / 2 ) : ( $dim['h'] - $d ) );

	    }

	// crop
	    $id = imagecrop( $is, array( 'x' => $x, 'y' => $y, 'width' => $cw, 'height' => $ch ) );

	// palette e canale alfa
	    if( strtolower( getFileExtension( $fd ) ) == 'png' ) {
		imagealphablending( $id, false );
		imagesavealpha( $id, true );
		imagepalettecopy( $is, $id );
	    }

	// debug
	    // imagestring( $id, 5, 5, 30, $cw . 'x' . $ch, imagecolorallocate( $id, 255, 0, 0 ) );

	// scrivo l'immagine
	    imageWrite( $id, $fd );

    }

    /**
     *
     * @todo documentare
     *
     */
    function imageWrite( $id, $f, $t = NULL ) {

	fullPath( $f );
	checkfolder( dirname( $f ) );

	if( $t === NULL ) {
	    $t = strtolower( getFileExtension( $f ) );
	}

	switch( $t ) {
	    case 'jpg':
	    case 'jpeg':
	    case IMAGETYPE_JPEG:
		imagejpeg( $id, $f );
	    break;
	    case 'png':
	    case IMAGETYPE_PNG:
		imagealphablending( $id, false );
		imagesavealpha( $id, true );
		imagepng( $id, $f );
	    break;
	    case 'webp':
	    case IMAGETYPE_WEBP:
		imagewebp( $id, $f );
	    break;
	    default:
		return false;
	    break;
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function imageConvert( $fs, $td, $fd = NULL ) {

	// apro l'immagine sorgente
	    $id = imageOpen( $fs );

	// file di destinazione
	    if( $fd === NULL ) {
		$fd = str_replace( '.'.getFileExtension($fs), '.'.$td, $fs );
	    }

	// debug
	    // echo $fd . PHP_EOL;

	// scrivo l'immagine
	    imageWrite( $id, $fd );

		return $fd;

    }

    /**
     *
     * @todo documentare
     *
     */
    function imageResize( $fs, $d = 1024, $fd = false, $o = NULL ) {

	// estensioni supportate
	    $ext = array( 'jpg', 'jpeg', 'png', 'webp' );

	// se non viene specificato un file di destinazione, assume che sia uguale al sorgente
	    if( $fd == false ) {
		$fd = $fs;
	    }

	// creo i full path
	    fullPath( $fs );
	    fullPath( $fd );

	// controllo il path di destinazione
	    checkFolder( dirname( $fd ) );

	// estensione
	    $x = strtolower( getFileExtension( $fs ) );

	// controllo che la dimensione max sia diversa da 0 altrimenti copio l'immagine senza scalarla
	    if( empty( $d ) ) {

		// copio l'immagine
		    copy( $fs, $fd );

		// restituisco true
		    return true;

	    } elseif( file_exists( $fs ) && in_array( $x, $ext ) ) {

		// prende in entrata le dimensioni dell'immagine originale
		    $dimensioni = getimagesize( $fs );

		    $altezza = $dimensioni[1];		// l'altezza dell'immagine
		    $larghezza = $dimensioni[0];	// la larghezza dell'immagine

		// se l'immagine ha dimensioni nulle, allora il file è danneggiato
		    if( empty( $altezza ) || empty( $larghezza ) ) {

			// log
			    logWrite( 'file danneggiato: ' . $fs, 'image', LOG_ERR );

			// restituisco false
			    return false;

		    } else {

			// nel caso l'immagine sia piu' alta che larga...
			    if( $altezza > $larghezza && $o != 'l' ) {

				// ...viene ridimensionata a partire dalla larghezza e l'altezza viene scalata proporzionalmente
				    $valore_riferimento = $larghezza; 
				    $valore_secondario = $altezza;

				// scalatura proporzionale della dimensione secondaria
				    $alpha_dim = round( ( $d * $valore_riferimento ) / $valore_secondario );
				    $beta_dim = $d;

			    } else {

				// ...altrimenti viene ridimensionata a partire dall'altezza e la larghezza viene scalata proporzionalmente
				    $valore_riferimento = $altezza;
				    $valore_secondario = $larghezza;

				// dimensione principale valorizzata al massimo consentito
				    $alpha_dim = $d;

				// scalatura proporzionale della dimensione secondaria
				    $beta_dim = round( ( $d * $valore_riferimento ) / $valore_secondario );

			    }

			// creazione dell'immagine di destinazione
			    $identificatore_destinazione = imagecreatetruecolor( $alpha_dim , $beta_dim );

			// TODO questa cosa andrebbe fatta con
			// $identificatore_provenienza = imageOpen( $fs );

			// a seconda del tipo di file viene creato un file immagine differente
			    switch( $x ) {
				case 'jpg':
				case 'jpeg':
				    $identificatore_provenienza = imagecreatefromjpeg( $fs );
				break;
				case 'png':
				    imagealphablending( $identificatore_destinazione , false );
				    imagesavealpha( $identificatore_destinazione , true );
				    $identificatore_provenienza = imagecreatefrompng( $fs );
				break;
				case 'webp':
				    $identificatore_provenienza = imagecreatefromwebp( $fs );
				break;
				case 'gif':
				default:
				    $exit_message = 'formato non supportato: ' . $x;
				break;
			    }

			// controllo che l'immagine sia valida
			    if( empty( $identificatore_provenienza ) ) {

				// log
				    logWrite( 'impossibile leggere: ' . $fs, 'image', LOG_DEBUG );

				// restituisco false
				    return false;

			    } else {

				// log
				    logWrite( 'lettura ok: ' . $fs, 'image', LOG_DEBUG );

				// trasferimento della palette dall'immagine creata in memoria al file di destinazione
				    imagepalettecopy( $identificatore_provenienza , $identificatore_destinazione );

				// copiatura dell'immagine creata in memoria sul file
				    $cont = imagecopyresampled(
					$identificatore_destinazione,
					$identificatore_provenienza,
					0,0,0,0,
					$alpha_dim,
					$beta_dim,
					$larghezza,
					$altezza
				    );

				// esito dell'operazione
				    if( $cont ) {

					logWrite( 'scalamento corretto a ' . $d . 'px di: ' . $fs, 'image' , LOG_DEBUG );
					$exit_message = 'file creato con successo';

				    } else {

					logWrite( 'impossibile scalare a ' . $d . 'px: ' . $fs, 'image' , LOG_DEBUG );
					$exit_message = 'impossibile creare il file ' . $fd;

					// output
					    return false;

				    }

				// debug
				    // imagestring( $identificatore_destinazione, 5, 5, 5, $alpha_dim . 'x' . $beta_dim, imagecolorallocate( $identificatore_destinazione, 255, 0, 0 ) );

				// scrittura del file
				    switch( $x ) {

					case 'jpg':
					case 'jpeg':
					    $cont = imagejpeg( $identificatore_destinazione , $fd );
					break;

					case 'png':
					    $cont = imagepng( $identificatore_destinazione , $fd );
					break;

					case 'webp':
					    $cont = imagewebp( $identificatore_destinazione , $fd );
					break;

					case 'gif':
					default:
					    logWrite( 'formato ' . $x . ' non supportato' , 'image' , LOG_DEBUG );
					break;

				    }

				// esito dell'operazione
				    if( $cont ) {

					logWrite( 'scrittura corretta: ' . $fd, 'image' , LOG_DEBUG );
					$exit_message = 'file creato con successo';

					// output
					    return true;

				    } else {

					logWrite( 'impossibile scrivere: ' . $fd, 'image' , LOG_DEBUG );
					$exit_message = 'impossibile creare il file ' . $fd;

					// output
					    return false;

				    }

			    }

		    }

	    } else {

		// output
		    return false;

	    }

    }

    if( ! function_exists( 'imagecrop' ) ) {
	function imagecrop( $src, array $rect ) {
	    $dest = imagecreatetruecolor( $rect['width'], $rect['height'] );
		imagecopyresampled(
		    $dest,
		    $src,
		    0,
		    0,
		    $rect['x'],
		    $rect['y'],
		    $rect['width'],
		    $rect['height'],
		    $rect['width'],
		    $rect['height']
		);
		return $dest;
	}
    }
