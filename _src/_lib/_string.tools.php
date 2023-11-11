<?php

    /**
     * libreria di funzioni per le operazioni sulle stringhe
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // costanti
	define( 'CUT_CENTER'			, 'CUT_C' );
	define( 'CUT_RIGHT'			, 'CUT_R' );
	define( 'CUT_LEFT'			, 'CUT_L' );

    /**
     *
     * @questa funzione converte il peso in unità di misura byte in funzione del tipo di file. 
     *type i : i = 0 fino alla taglia del parametro passato : filesize. finché filesize supera 1024 viene / per 1024 e i incrementa. printf di controllo : con il peso del file finale associato al tipo passato
     */
    function writeByte( $filesize ) {

	$type = array( 'Bytes' , 'Kb' , 'Mb' , 'Gb' , 'Tb' );

	for( $i = 0 ; $filesize > 1024 ; $i++ ) {
	    $filesize /= 1024;
	}

	return sprintf( '%0.2f', round( $filesize , 2 ) ) . ' ' . $type[ $i ];

    }

    /**
     * questa funzione riduce i caratteri ripetuti in una stringa
     * tramite l'impiego di una espressione regolare
     *
     * @param string $t         la stringa da modificare
     * @param string $c         il carattere ripetuto da ridurre (opzionale, di default riduce gli spazi)
     * @return string           la stringa modificata
     *
     * @author                  Fabio Mosti <fabio@videoarts.eu>
     * @version                 2012-05-10 14:39        funzione creata
     * @version                 2012-05-12 11:09        test unit e debug
     *
     */
    function riduciCaratteriDoppi( $t , $c = " " ) {

	// compongo l'espressione regolare
	    switch( $c ) {

		case " ":

		    $expr = '/\s+/';
		    $sost = ' ';

		break;

		case "\\":
		case "^":
		case "{":
		case "}":
		case "[":
		case "]":
		case "(":
		case ")":
		case "?":
		case "*":
		case "$":
		case "+":
		case ".":

		    $expr = "/[\\$c]+/";
		    $sost = $c;

		break;

		default:

		    $expr = "/[$c]+/";
		    $sost = $c;

		break;

	    }
 
	// eseguo l'espressione regolare
	    $t = preg_replace( $expr , $sost , $t );

	// restituzione risultato
	    return $t;

    }

    /**
     *
     * @todo la sostituzione della virgola così è un po' grezza, migliorare (può esserci anche il punto per le migliaia, eccetera)
     * @todo documentare
     *
     */
    function numeric2null( $s ) {
        if( is_numeric( $s ) && strpos( $s, ',' ) !== false ) {
            $s = str_replace( ',', '.', $s );
        }
        return empty2null( $s, true );
    }

    /**
     *
     * @todo documentare
     *
     */
    function string2num( $s ) {
        if( is_numeric( str_replace( array( ',', '.' ), NULL, $s ) ) ) {
            if( strpos( $s, ',' ) !== false && strpos( $s, '.' ) === false ) {
                // es. 1000,50 -> 1000.50
                $s = str_replace( ',', '.', $s );
            } elseif( strpos( $s, ',' ) !== false && strpos( $s, '.' ) !== false ) {
                if( strpos( $s, ',' ) < strpos( $s, '.' ) ) {
                    // es. 1,000.50 -> 1000.50
                    $s = str_replace( ',', NULL, $s );
                } else {
                    // es. 1.000,50 -> 1000.50
                    $s = str_replace( ',', '.', str_replace( '.', NULL, $s ) );
                }
            }
        }
        return $s;
    }

    /**
     *
     * @todo documentare
     *
     */
    function empty2null( $s, $numeric = false ) {

	if( $numeric === true && is_numeric( $s ) ) {
	    return $s;
	} elseif( empty( $s ) ) {
	    return NULL;
	} else {
	    return $s;
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function string2boolean( $s ) {

	switch( strtolower( $s ) ) {
	    case 'true':
	    case 1:
		return true;
	    default:
		return false;
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function boolean2string( $s ) {

        return ( $s === true ) ? 'true' : 'false';

    }
        
    /**
     *
     * @todo documentare
     *
     */
    function riduciStringa( $s, $l, $c = '~', $t = CUT_CENTER ) {

	$lm = $l - strlen( $c );
	$lx = floor( $lm / 2 );

	switch( $t ) {
	    case CUT_CENTER:
		return ( substr( $s, 0, $lx ) . $c . substr( $s, 1 - ( $lm - $lx ) ) );
	    break;
	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function int2month( $m, $l = 'it-IT' ) {

        switch( $m ) {
            case 1:
                return 'gennaio';
            break;
            case 2:
                return 'febbraio';
            break;
            case 3:
                return 'marzo';
            break;
            case 4:
                return 'aprile';
            break;
            case 5:
                return 'maggio';
            break;
            case 6:
                return 'giugno';
            break;
            case 7:
                return 'luglio';
            break;
            case 8:
                return 'agosto';
            break;
            case 9:
                return 'settembre';
            break;
            case 10:
                return 'ottobre';
            break;
            case 11:
                return 'novembre';
            break;
            case 12:
                return 'dicembre';
            break;
            default:
                return 'mese sconosciuto (' . $m . ')';
            break;
        }

    }

    /**
     *
     * @todo documentare
     *
     */
    function int2day( $d, $l = 'it-IT' ) {

        switch( $d ) {
            case 0:
                return 'domenica';
            break;
            case 1:
                return 'lunedì';
            break;
            case 2:
                return 'martedì';
            break;
            case 3:
                return 'mercoledì';
            break;
            case 4:
                return 'giovedì';
            break;
            case 5:
                return 'venerdì';
            break;
            case 6:
                return 'sabato';
            break;
            default:
                return 'giorno sconosciuto (' . $d . ')';
            break;
        }

    }

    /**
     * converte in stringa il livello di errore
     *
     *
     *
     * @todo commentare
     *
     */
    function logLvl2string( $l ) {

	switch( $l ) {
	    case 0:
		    return 'LOG_EMERG';
	    break;
	    case 1:
		    return 'LOG_ALERT';
	    break;
	    case 2:
		    return 'LOG_CRIT';
	    break;
	    case 3:
		    return 'LOG_ERR';
	    break;
	    case 4:
		    return 'LOG_WARNING';
	    break;
	    case 5:
		    return 'LOG_NOTICE';
	    break;
	    case 6:
		    return 'LOG_INFO';
	    break;
	    case 7:
    		return 'LOG_DEBUG';
	    break;
	    default:
		    return NULL;
	    break;
	}

    }

    /**
     * converte in stringa il livello di report
     *
     *
     * E_ERROR               |   1      | errore fatale, l'esecuzione viene terminata
     * E_WARNING             |   2      | errore non fatale, l'esecuzione prosegue ma può dare risultati imprevisti
     * E_PARSE               |   4      | errore di parsing durante la compilazione; questo livello è riservato al parser
     * E_NOTICE              |   8      | evento notevole, ma non necessariamente un errore
     * E_CORE_ERROR          |   16     | errore fatale PHP; riservato al core PHP
     * E_CORE_WARNING        |   32     | errore non fatale PHP; riservato al core PHP
     * E_COMPILE_ERROR       |   64     | errore fatale di compilazione; riservato allo Zend Scripting Engine
     * E_COMPILE_WARNING     |   128    | errore non fatale di compilazione; riservato allo Zend Scripting Engine
     * E_USER_ERROR          |   256    | errore generato tramite la funzione trigger_error()
     * E_USER_WARNING        |   512    | avviso generato tramite la funzione trigger_error()
     * E_USER_NOTICE         |   1024   | evento notevole segnalato tramite la funzione trigger_error()
     * E_STRICT              |   2048   | violazione formale
     * E_RECOVERABLE_ERROR   |   4096   | errore fatale ma gestibile, non pregiudica il funzionamento del core PHP
     * E_DEPRECATED          |   8192   | errore di obsolescenza
     * E_USER_DEPRECATED     |   16384  | errore di obsolescenza generato tramite la funzione trigger_error()
     * E_ALL                 |   32767  | tutti i messaggi di errore
     *
     * @todo commentare
     *
     */
    function reportLvl2string( $l ) {

        switch( $l ) {
            case 1:
                return 'E_ERROR';
            break;
            case 2:
                return 'E_WARNING';
            break;
            case 4:
                return 'E_PARSE';
            break;
            case 8:
                return 'E_NOTICE';
            break;
            case 16:
                return 'E_CORE_ERROR';
            break;
            case 32:
                return 'E_CORE_WARNING';
            break;
            case 64:
                return 'E_COMPILE_ERROR';
            break;
            case 128:
                return 'E_COMPILE_WARNING';
            break;
            case 256:
                return 'E_USER_ERROR';
            break;
            case 512:
                return 'E_USER_WARNING';
            break;
            case 1024:
                return 'E_USER_NOTICE';
            break;
            case 2048:
                return 'E_STRICT';
            break;
            default:
                return NULL;
            break;
        }
    
        }
    
        /**
     *
     * @todo documentare
     *
     */
    function ts2string( $d ) {

	return date( 'j', $d ) . ' ' . int2month( date( 'n', $d ) ) . ' ' . date( 'Y', $d );

    }

    /**
     *
     * @todo documentare
     *
     */
    function date2string( $d ) {

	return ts2string( strtotime( $d ) );

    }

    /**
     *
     * @todo documentare
     *
     */
    if( ! function_exists( 'str_starts_with' ) ) {

        function str_starts_with( $haystack, $needle ) {

            if( strpos( $haystack, $needle ) === 0) {
                return true;
             } else {
                 return false;
             }

        }

    }

    /**
     *
     * @todo documentare
     *
     */
    function str_starts_with_array( $haystack, $needles ) {

        foreach( $needles as $needle ) {
            if( str_starts_with( $haystack, $needle ) ) {
                return true;
            }
        }

        return false;

    }

    /**
     *
     * @todo documentare
     *
     */
    function m2km( $m ) {

        return $m / 1000;

    }

    /**
     *
     * @todo documentare
     *
     */
    function km2m( $km ) {

        return $km * 1000;

    }

    /**
     *
     * @todo documentare
     * @todo questa funzione va aggiunta a readFromFile() per evitare che dia fuori il testo con il BOM
     *
     */
    function removeBom( $t ) {
        $bom = pack('H*','EFBBBF');
        $t = preg_replace("/^$bom/", '', $t);
        return $t;
    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function domainFromURL( $url ) {

        $array = parse_url( $url );
        return $array["host"];

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function inRegexpArray( $t, $a ) {

        $match = false;

        foreach( $a as $r ) {
            if( preg_match( $r, $t ) ) {
                $match = true;
            }
        }

        return $match;

    }

    function clean_string($string) {

        $s = trim($string);
        $s = iconv("UTF-8", "UTF-8//IGNORE", $s); // drop all non utf-8 characters
      
        $s = preg_replace('/(?>[\x00-\x1F]|\xC2[\x80-\x9F]|\xE2[\x80-\x8F]{2}|\xE2\x80[\xA4-\xA8]|\xE2\x81[\x9F-\xAF])/', ' ', $s);
        $s = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $s);
        $s = preg_replace('/\s+/', ' ', $s); // reduce all multiple whitespace to a single space
      
        if( $s != $string ) {
            logWrite( $string . ' pulito a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        return $s;

    }
