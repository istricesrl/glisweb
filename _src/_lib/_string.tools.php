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
     * @todo documentare
     *
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
     * @todo documentare
     *
     */
    function empty2null( $s, $numeric = false ) {

	if( $numeric === true && $s == 0 ) {
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


    //questa funzione restituisce la stringa passata fino a :
    function substr2char($stringa) {
	return substr( $stringa, 0, strpos( $stringa, ':' ) );
    }


/*funzione specifica relativa a _rest.php
    function substr2char($stringa = $cf['ws']['request']['headers']['Referer'] ) {
    return substr( $stringa, 0, strpos( $stringa, ':' ) );
    } /*