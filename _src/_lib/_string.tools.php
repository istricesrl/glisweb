<?php

    /**
     * libreria di funzioni per le operazioni sulle stringhe
     *
     * Questa libreria contiene funzioni per la manipolazione delle stringhe.
     *
     * introduzione
     * ============
     * 
     * constanti
     * =========
     * La libreria definisce le seguenti costanti 
     *
     * costante             | spiegazione
     * ---------------------|--------------------------------------------------------------
     * CUT_CENTER           | 
     * CUT_RIGHT            | 
     * CUT_LEFT             | 
     *
     * funzioni
     * ========
     * 
     * dipendenze
     * ==========
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-08-13       | Sara Tullini         | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     * 
     * TODO documentare
     *
     */

    // costanti
    define( 'CUT_CENTER'            , 'CUT_C' );
    define( 'CUT_RIGHT'            , 'CUT_R' );
    define( 'CUT_LEFT'            , 'CUT_L' );

    /**
     * converte un intero in un numero di byte
     * 
     * Questa funzione prende in input un numero e attraverso divisioni successive per 1024 lo trasforma in
     * una stringa che indica la dimensione con relativa unità di misura.
     * 
     * @param   int         $filesize       dimensione in byte
     * 
     * @return  string                      dimensione in byte, Kb, Mb, Gb, Tb
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
     * @param   string      $t         la stringa da modificare
     * @param   string      $c         il carattere ripetuto da ridurre (opzionale, di default riduce gli spazi)
     * 
     * @return  string                 la stringa modificata
     * 
     */
    function riduciCaratteriDoppi( $t, $c = " " ) {

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
        $t = preg_replace( $expr, $sost, $t );

        // restituzione risultato
        return $t;

    }

    /**
     *
     * TODO la sostituzione della virgola così è un po' grezza, migliorare (può esserci anche il punto per le migliaia, eccetera)
     * TODO documentare
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
     * TODO documentare
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
     * TODO documentare
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
     * TODO documentare
     *
     */
    function string2boolean( $s ) {

        if( empty( $s ) ) {
            return false;
        } else {
            switch( strtolower( $s ) ) {
                case 'true':
                case 1:
                    return true;
                default:
                    return false;
            }
        }

    }

    /**
     *
     * TODO documentare
     *
     */
    function boolean2string( $s ) {

        return ( $s === true ) ? 'true' : 'false';

    }
        
    /**
     *
     * TODO documentare
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
     * TODO documentare
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
     * TODO documentare
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
     * TODO commentare
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
     * TODO commentare
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
     * TODO documentare
     *
     */
    function ts2string( $d ) {

        return date( 'j', $d ) . ' ' . int2month( date( 'n', $d ) ) . ' ' . date( 'Y', $d );

    }

    /**
     *
     * TODO documentare
     *
     */
    function date2string( $d ) {

        return ts2string( strtotime( $d ) );

    }

    /**
     *
     * TODO documentare
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
     * TODO documentare
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
     * TODO documentare
     *
     */
    function m2km( $m ) {

        return $m / 1000;

    }

    /**
     *
     * TODO documentare
     *
     */
    function km2m( $km ) {

        return $km * 1000;

    }

    /**
     *
     * TODO documentare
     * TODO questa funzione va aggiunta a readFromFile() per evitare che dia fuori il testo con il BOM
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
     * TODO documentare
     * 
     */
    function domainFromURL( $url ) {

        $array = parse_url( $url );
        return $array['host'];

    }

    /**
     * 
     * 
     * TODO documentare
     * 
     */
    function inRegexpArray( $t, $a ) {

        $match = false;
      
        foreach( $a as $r ) {
            if( ! preg_match( '/^\/.*\/[a-z]*$/', $r ) ) {
                $r = '/' . $r . '/';
            }
            if( preg_match( $r, $t ) ) {
                $match = true;
            }
        }

        return $match;

    }

    function clean_string($string) {

        $s = trim( $string );

        $s = iconv( "UTF-8", "UTF-8//IGNORE", $s );
      
        if( $s != $string ) {
            logWrite( $string . ' pulito (clean UTF-8) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        $s = preg_replace( '/(?>[\x00-\x1F]|\xC2[\x80-\x9F]|\xE2[\x80-\x8F]{2}|\xE2\x80[\xA4-\xA8]|\xE2\x81[\x9F-\xAF])/', ' ', $s );

        if( $s != $string ) {
            logWrite( $string . ' pulito (rimozione caratteri speciali step 1) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        /*
        $s = preg_replace( '/[\x00-\x1F\x80-\xFF]/', '', $s );

        if( $s != $string ) {
            logWrite( $string . ' pulito (rimozione caratteri speciali step 2) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }
        */

        $s = preg_replace('/\s+/', ' ', $s );

        if( $s != $string ) {
            logWrite( $string . ' pulito (rimozione spazi doppi) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        return $s;

    }

    if( ! function_exists( 'mb_detect_encoding' ) ) {

        function mb_detect_encoding( $string ) {

            return ( utf8_encode( utf8_decode( $string ) ) == $string ) ? 'UTF-8' : 'ASCII';

        }

    }

    /**
     *
     * TODO documentare
     *
     */
    function isBinaryString( $data ) {        
        return ! mb_check_encoding( $data, 'UTF-8' );
    }

    /**
     * questa funzione rimuove da una stringa tutti i caratteri diversi da numeri, vigola e punto
     * 
     * TODO documentare
     * 
     */
    function extractNumber( $string ) {

        return preg_replace( '/[^0-9\.\,]/', '', $string );

    }

    /**
     * 
     * 
     * 
     */
    function writeCurrency( $v, $c = '€' ) {

        return $c . ' ' . number_format( $v, 2, ',', '.' );

    }

