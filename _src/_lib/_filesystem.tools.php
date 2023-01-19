<?php

    /**
     * funzioni per l'I/O su file
     *
     * Questa libreria contiene funzioni utili per le operazioni di I/O su file.
     *
     * modalità di apertura dei file
     * =============================
     * L'apertura dei files nel framework si basa sulle modalita' di apertura possibili per
     * fopen() come illustrate nella documentazione di PHP (http://it2.php.net/manual/it/function.fopen.php).
     * Qui di seguito le riportiamo in breve:
     *
     * modalità | spiegazione
     * ---------|--------------------------------------------------------------
     * r        | sola lettura, puntatore all'inizio del file
     * r+       | lettura e scrittura, puntatore all'inizio del file
     * w        | sola scrittura, puntatore all'inizio del file e troncatura a zero (se non esiste lo crea)
     * w+       | lettura e scrittura, puntatore all'inizio del file e troncatura a zero (se non esiste lo crea)
     * a        | sola scrittura, puntatore alla fine del file (se non esiste lo crea)
     * a+       | lettura e scrittura, puntatore alla fine del file (se non esiste lo crea)
     * x        | sola scrittura, puntatore all'inizio del file (se non esiste lo crea, se esiste da' errore)
     * x+       | lettura e scrittura, puntatore all'inizio del file (se non esiste lo crea, se esiste da' errore)
     * c        | sola scrittura, se il file non esiste viene creato, se esiste non viene troncato ma il puntatore viene posizionato all'inizio del file
     * c+       | lettura e scrittura, se il file non esiste viene creato, se esiste non viene troncato ma il puntatore viene posizionato all'inizio del file
     *
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella.
     *
     * costante                  | spiegazione
     * --------------------------|--------------------------------------------------------------
     * READ_FILE_AS_ARRAY        | legge il file come un array con la funzione file()
     * READ_FILE_AS_STRING       | legge il file come una stringa con file_get_contents()
     * WRITE_FILE_OVERWRITE      | sovrascrive il file (lo crea se non esiste)
     * WRITE_FILE_APPEND         | appende al file (lo crea se non esiste)
     *
     * Inoltre, per funzionare correttamente, la libreria richiede che siano valorizzate le
     * seguenti costanti globali.
     *
     * costante                  | spiegazione
     * --------------------------|--------------------------------------------------------------
     * DIR_BASE                  | il percorso base dove lavorare (ad es. /var/www/)
     *
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze.
     *
     *
     *
     * @todo finire di documentare l'introduzione di questa libreria
     * @todo finire di documentare le funzioni di questa libreria
     * @todo se la costante DIR_BASE non è valorizzata, farlo qui
     *
     * @file
     *
     */

    // definizione delle costanti della libreria
	define( 'FILE_READ_AS_ARRAY'		, 'READ_ARRAY' );
	define( 'FILE_READ_AS_STRING'		, 'READ_STRING' );
	define( 'FILE_WRITE_OVERWRITE'		, 'w+' );
	define( 'FILE_WRITE_APPEND'		, 'a+' );

    /**
     *
     * @todo documentare
     *
     */
    function fullPath( &$f ) {

	if( strpos( $f, DIR_BASE ) === false ) {
	    $f = DIR_BASE . $f;
	}

	return $f;

    }

    /**
     *
     * @todo documentare
     *
     */
    function shortPath( &$f ) {

	$f = str_replace( DIR_BASE, NULL, $f );

	return $f;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getShortPath( $f ) {

        return shortPath( $f );

    }

    /**
     *
     * @todo documentare
     *
     */
    function getFileNameWithoutExtension( $f ) {

        fullPath( $f );

        $i = pathinfo( $f );

        return $i['filename'];

    }

    /**
     * verifica l'esistenza di un path di directory creando quelle mancanti
     *
     * @param string		$p	il percorso da verificare
     *
     * @todo				testare a fondo
     * @todo				restituire false in caso di errore
     * @todo				documentare &$e
     *
     */
    function checkFolder( $p ) {

	$f = DIR_BASE;

	shortPath( $p );

	$p = rtrim( $p , '/' );

	$passi = explode( '/' , $p );

	foreach( $passi as $passo ) {

	    $f .=  $passo . '/';

	    if( ! is_dir( $f ) ) {

		if( @mkdir( $f ) ) {

		    chmod( $f , 0775 );

		} else {

		    $m  = 'impossibile creare ' . $f;
		    error_log( $m );
            return false;

		}

	    }

	}

	return true;

    }

    /**
     * apre un handler a un file
     *
     * La funzione apre un file e restituisce il relativo handler. Prima di aprire il file, verifica
     * il percorso tramite checkFolder() assumendo che l'argomento $f contenga un percorso completo
     * a partire dalla directory base del sito.
     *
     * @param string		$f	il nome del file al quale aggiungere comprensivo di percorso
     * @param string		$m	la modalita' con cui si desidera aprire il file
     *
     * @returns resource		il puntatore al file
     *
     * @todo				documentare &$e
     *
     */
    function openFile( $f, $m = FILE_WRITE_APPEND ) {

	// path completo
	    fullPath( $f );

	// componente directory
	    $d = dirname( $f );

	// verifico il percorso
	    checkFolder( $d );

	// pertura del file
	    $r = @fopen( $f, $m );

	// restituzione del risultato
	    return $r;

    }

    /**
     * chiude un puntatore a un file
     *
     * @param string		$h	il puntatore al file da chiudere
     *
     * @todo				questa funzione dovrebbe ritornare false se ci sono dei problemi
     *
     */
    function closeFile( $h ) {

	return fclose( $h );

    }

    /**
     *
     * @todo documentare
     *
     */
    function checkFile( $f ) {

	fullPath( $f );
	$d = dirname( $f );

    if( checkFolder( $d ) ) {

        if( closeFile( openFile( $f ) ) ) {

            return true;

        }

    }

    return false;

    }

    /**
     * scrive una stringa su un file
     *
     * Questa funzione scrive una stringa su un file sovrascrivendo eventuali
     * informazioni già presenti. Se si vuole aggiungere contenuto a un file,
     * utilizzare la funzione appendToFile(). Dal momento che questa funzione
     * utilizza openFile() per creare l'handle di scrittura, se la cartella
     * in cui si è richiesto di scrivere verrà creata automaticamente se non
     * esiste.
     *
     * In caso di errore inserisce un messaggio specifico nella variabile $e
     *
     * @param string		$t	la stringa da scrivere
     * @param string		$f	il nome del file su cui scrivere comprensivo di percorso
     * @param string		$m	la modalita' con cui si desidera aprire il file
     *
     *
     * @todo				documentare &$e
     * 
     */
    function writeToFile( $t, $f, $m = FILE_WRITE_OVERWRITE ) {

	$r = NULL;

	$h = openFile( $f, $m );

	if( $h ) {

	    $r = fwrite( $h, $t );
	    closeFile( $h );

	} else {

	    $m  = 'impossibile scrivere su ' . $f;
	    error_log( $m );
	    $r = false;

	}

	return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function overwriteToFile( $t, $f ) {

	return writeToFile( $t, $f, FILE_WRITE_OVERWRITE );

    }

    //SDF-CGDL

    /**
     * aggiunge una stringa a un file
     *
     * La funzione apre il file, inserisce la stringa di testo alla fine di esso e poi lo rihciude.
     * In caso di impossibilità di scrittura la funzione si interrompe e viene aggiornato il file di log con relativo messaggio di errore
     *
     *
     * @param string		$t	la stringa da aggiungere
     * @param string		$f	il nome del file al quale aggiungere comprensivo di percorso
     *
     * @todo				finire di documentare
     * @todo				documentare &$e
     * 
     */
    function appendToFile( $t, $f ) {

	return writeToFile( $t, $f, FILE_WRITE_APPEND );

    }

    /**
     * elimina un file
     *
     * @param string		$f	il nome del file da eliminare comprensivo di percorso
     *
     * @todo				questa funzione dovrebbe ritornare false se ci sono dei problemi
     *
     */
    function deleteFile( $f ) {

	// path completo
	    fullPath( $f );

	// cancellazione del file
	    if( file_exists( $f ) && is_writeable( $f ) ) {
		$r = @unlink( $f );
		if( $r === false ) {
		    $m = 'errore nella cancellazione di ' . $f;
		    error_log( $m ); 
		}
	    } else {
		$m = 'impossibile cancellare di ' . $f;
		error_log( $m ); 
		$r = false;
	    }

	// true o false
	    return $r;

    }

    /**
     *
     * @todo documentare
     * @todo documentare
     *
     */
    function deleteDir( $f ) {

	// path completo
	    fullPath( $f );

	// cancellazione del file
	    if( file_exists( $f ) && is_writeable( $f ) ) {
		$r = rmdir( $f );
		if( $r === false ) { error_log( 'errore nella cancellazione di ' . $f ); }
	    } else {
		error_log( 'impossibile cancellare ' . $f );
		$r = false;
	    }

	// true o false
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getDirIterator( $d ) {

	fullPath( $d );

	return new RecursiveIteratorIterator(
	    new RecursiveDirectoryIterator( $d, FilesystemIterator::SKIP_DOTS ),
	    RecursiveIteratorIterator::CHILD_FIRST
	);

    }

    /**
     *
     * @todo implementare i controlli (vedi deleteDir)
     * @todo mettere come opzionale la rimozione della cartella radice
     * @todo documentare
     *
     */
    function recursiveDelete( $d, $p = true, &$e = array() ) {

	// path completo
	    fullPath( $d );

	// se la cartella esiste
	    if( file_exists( $d ) ) {

		// rimozione dei file
		    foreach( getDirIterator( $d ) as $fileinfo ) {
                $e[] = $fileinfo->getRealPath();
                $todo = ( $fileinfo->isDir() ) ? 'rmdir' : 'unlink';
                $todo( $fileinfo->getRealPath() );
		    }

		// rimozione della cartella radice
		    if( $p === true ) {
			return rmdir( $d );
		    } else {
			return true;
		    }

	    } else {

		// ritorno false
		    return false;

	    }

    }

    /**
     *
     * @todo documentare
     *
     */
    function dirTree2array( $d ) {

        // path completo
            fullPath( $d );

        // array del risultato
            $a = array();

        // se la cartella esiste
            if( file_exists( $d ) ) {
    
            // cartella base
            $a[] = $d;

            // aggiunta cartella
                foreach( getDirIterator( $d ) as $fileinfo ) {
                    if( $fileinfo->isDir() ) {
                        $a[] = $fileinfo->getRealPath();
                    }
                }

                // restituisco il risultato
                return $a;

            } else {
    
            // ritorno false
                return false;
    
            }
    
        }
    
    /**
     * restituisce la dimensione di un file
     *
     * @param string		$f	il nome del file da controllare comprensivo di percorso
     *
     * @todo				questa funzione dovrebbe ritornare false se ci sono dei problemi
     *
     */
    function getFileSize( $f ) {

	// path completo
	    fullPath( $f );

	// restituisco la dimensione del file in bytes o false in caso di fallimento
	    return @filesize( $f );

    }

    /**
     * legge il contenuto di un file in una stringa o in un array di stringhe
     *
     * @param string		$f	il nome del file dal quale leggere comprensivo di percorso
     * @param string		$m	la modalita' con cui si desidera aprire il file
     *
     * @todo finire di documentare
     *
     */
    function readFromFile( $f, $m = FILE_READ_AS_ARRAY ) {

	// path completo
	    fullPath( $f );

	    if( file_exists( $f ) && is_readable( $f ) ) {

		switch( $m ) {

		    case FILE_READ_AS_ARRAY:
			return file( $f );
		    break;
		    case FILE_READ_AS_STRING:
			return file_get_contents( $f );
		    break;
		    default:
			return false;
		    break;

		}

	    } else {

		return false;

	    }

    }

    /**
     *
     * @todo documentare
     *
     */
    function readStringFromFile( $f, $trim = false ) {

        $t = readFromFile( $f, FILE_READ_AS_STRING );
        if( $trim === true ) { $t = trim( $t ); }
	    return $t;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getFilteredFileList( $d , $f = '*', $s = false ) {

	fullPath( $d );

	$a = glob( $d . $f , GLOB_BRACE );

	$r = array();

	foreach( $a as $t ) {
	    if( is_file( $t ) ) {
		shortPath( $t );
        if( $s !== false ) {
            $t = basename( $t );
        }
        $r[] = $t;
	    }
	}

	return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getFileList( $d, $full = false ) {

	$t = array();

	foreach( getDirIterator( $d ) as $f ) {
	    if( $f->isFile() ) {
		$t[] = ( $full === true ) ? $f->getRealPath() : $f->getFileName();
	    }
	}

	return $t;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getFilteredDirList( $d, $f = '*', $s = false ) {

        fullPath( $d );

        $a = glob( $d . $f , GLOB_BRACE );
    
        $r = array();
    
        foreach( $a as $t ) {
            if( is_dir( $t ) ) {
            shortPath( $t );
            if( $s !== false ) {
                $t = basename( $t );
            }
            $r[] = $t;
            }
        }
    
        return $r;
    
    }
       
    /**
     *
     * @todo documentare
     *
     */
    function getDirList( $d, $full = false ) {

	$t = array();

	foreach( getDirIterator( $d ) as $f ) {
	    if( $f->isDir() ) {
		$t[] = ( $full === true ) ? $f->getRealPath() : $f->getFileName();
	    }
	}

	return $t;

    }

    /**
     * calcola ricorsivamente lo spazio occupato da una directory
     *
     * @param			$d	la directory da controllare
     *
     * @return			int	la dimensione della cartella
     *
     */
    function getDirSize( $d ) {

	$t = 0;

	if( is_dir( $d ) ) {
#	    foreach( new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $d ) ) as $f ) {
	    foreach( getDirIterator( $d ) as $f ) {
		$t += $f->getSize();
	    }
	} else {
	    $t = getSize( $d );
	}

	return $t;

    }

    /**
     *
     * @todo documentare
     *
     */
    function getRecursiveDirList( $d ) {

	$r = array();

#	foreach( new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $d ) ) as $f ) {
	foreach( getDirIterator( $d ) as $f ) {

	    if( $f->isDir() )
		$r[] = $f->getRealPath();

	}

	return $r;

    }

    /**
     * calcola la dimensione di un file in byte
     *
     * @param			$f	il file da esaminare
     * @return			int	la dimensione del file in byte
     *
     * @todo verificare che il file esista e sia un file
     * @todo verificare di avere i permessi per leggere il file
     *
     */
     function getSize( $f ) {

	fullPath( $f );

	return @filesize( $f );

     }

    //SDF-CGDL
    /**
     * recupera l'estensione del file
     *
     * @param			$f	il file da esaminare
     * @return			string	l'estensione del file
     *
     * @todo questa va testata
     * @todo documentare
     *
     */
     function getFileExtension( $f ) {

	return substr( basename( $f ) , strrpos( basename( $f ) , '.' ) + 1 );

     }

    /**
     *
     * @todo documentare
     *
     */
    function moveFile( $f1, $f2 ) {

	fullPath( $f1 );
	checkFolder( dirname( $f1 ) );

	fullPath( $f2 );
	checkFolder( dirname( $f2 ) );

	return @rename( $f1, $f2 );

    }

    /**
     *
     * @todo documentare
     *
     */
    function copyFile( $f1, $f2 ) {

	fullPath( $f2 );
	checkFolder( dirname( $f2 ) );

	if( filter_var( $f1, FILTER_VALIDATE_URL ) ) {

	    $ch = curl_init();
	    curl_setopt( $ch, CURLOPT_URL, $f1 );
	    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
	    $data = curl_exec( $ch );
	    $error = curl_error( $ch );
	    curl_close( $ch );

	    $h = fopen( $f2, FILE_WRITE_OVERWRITE );
	    fputs( $h, $data );
	    fclose( $h );

	    return ( ( empty( $error ) && file_exists( $f2 ) ) ? true : false );

	} else {

	    fullPath( $f1 );
	    checkFolder( dirname( $f1 ) );

	    return copy( $f1, $f2 );

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function globRecursive( $path , $find ) {

	$r = array();

	$dh = @opendir( $path );

	if( $dh ) {
	    while( ( $file = readdir( $dh ) ) !== false ) {

		if( substr( $file, 0, 1) == '.' ) continue;

		$rfile = "{$path}/{$file}";

		if ( is_dir( $rfile ) ) {

		    array_merge( $r , globRecursive( $rfile , $find ) );

		} else {

		    if( fnmatch( $find, $file ) ) {

			$r[] = $file;

		    }

		}

	    }

	    closedir( $dh );

	} else { $r = false; }

	return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function findFileExtension( $f ) {

	$e = explode( '.', $f );
	$a = array_reverse( $e );
	return array_shift( $a );

    }

    /**
     *
     * @todo documentare
     *
     */
    function findFileType( $f ) {

	fullPath( $f );

	return mime_content_type( $f );

    }

    /**
     *
     * @todo documentare
     *
     */
    function emptyDir( $d ) {

	foreach( getDirIterator( $d ) as $f ) {

	    if( $f->isFile() ) {
		deleteFile( $f->getRealPath() );
	    } elseif( $f->isDir() ) {
		deleteDir( $f->getRealPath() );
	    }

	}

	return 0;

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileExists( $f ) {

	if( filter_var( $f, FILTER_VALIDATE_URL ) ) {
	    $ch = curl_init( $f);
	    curl_setopt( $ch, CURLOPT_NOBODY, true );
	    curl_exec( $ch );
	    $code = curl_getinfo( $ch, CURLINFO_HTTP_CODE );
	    $status = ( $code == 200 ) ? true : false;
	    curl_close( $ch );
	    return $status;
	} else {
	    fullPath( $f );
	    return file_exists( $f );
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileModifiedTime( $f ) {

	if( filter_var( $f, FILTER_VALIDATE_URL ) ) {
	    $curl = curl_init();
	    curl_setopt( $curl , CURLOPT_URL , $f );
	    curl_setopt( $curl , CURLOPT_HEADER , 1 );
	    curl_setopt( $curl , CURLOPT_NOBODY , 1 );
	    curl_setopt( $curl , CURLOPT_RETURNTRANSFER , 1 );
	    curl_setopt( $curl , CURLOPT_TIMEOUT , 5 );
	    $curl_result = curl_exec( $curl );

	    if ( $curl_result !== false && strpos( $curl_result, '200 OK' ) !== false ) {
		$headers = explode( "\n" , $curl_result );
		$last_modified = explode( 'Last-Modified: ' , $headers[3] );
		return strtotime( $last_modified[1] );
	    } else {
		return false;
	    }

	} else {

	    fullPath( $f );
	    return filemtime( $f );

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function file2array( $f ) {
	return readFromFile( $f, FILE_READ_AS_ARRAY );
    }

    /**
     *
     * @todo documentare
     *
     */
    function array2file( $f, $a ) {
	return writeToFile( trim( implode( PHP_EOL, str_replace( PHP_EOL, NULL, $a ) ) ), $f );
    }

    /**
     *
     * @todo documentare
     *
     */
    function array2keyValueFile( $f, $a ) {

        $t = NULL;

        foreach( $a as $k => $v ) {
            $t .= $k . '="' . trim( $v, " \n\r\t\v\0\"") . '"' . PHP_EOL;
        }

        return writeToFile( $t, $f );

    }

    /**
     *
     * @todo documentare
     *
     */
    function keyValueFile2array( $f ) {

        $a = file2array( $f );

        $j = array();

        foreach( $a as $r ) {

            $s = explode( '=', $r );
            if( count( $s ) == 2 ) {
                $j[ $s[0] ] = trim( $s[1], " \n\r\t\v\0\"");
            }

        }

        return $j;

    }

    /**
     * 
     * TODO implementare due costanti per dire alla funzione se togliere le righe dall'inizio o dalla fine e aggiungere il parametro alla funzione
     * 
     */
    function fileTrimLines( $f, $n ) {

        $a = file2array( $f );
        $a = array_slice( $a, $n );
        array2file( $f, $a );
    
    }
