<?php

    /**
     * libreria di funzioni per le operazioni sulle stringhe
     *
     * Questa libreria contiene funzioni per la manipolazione delle stringhe.
     *
     * introduzione
     * ============
     * Questa libreria raccoglie le funzioni di uso comune per lavorare con le stringhe: conversioni fra stringhe e altri tipi
     * di dato ( numeri, booleani, date, livelli di log ), formattazione di valori per la presentazione ( dimensioni in byte,
     * importi, mesi e giorni in italiano ), pulizia del testo proveniente dall'esterno ( spazi doppi, BOM, caratteri di
     * controllo ) e alcune piccole utilità per gli URL e le espressioni regolari.
     *
     * Le funzioni non sono ordinate per gruppo all'interno del file, che è cresciuto per aggiunte successive; la tabella
     * delle funzioni più avanti le raggruppa per area tematica.
     *
     * costanti
     * ========
     * La libreria definisce le seguenti costanti, che indicano il punto in cui riduciStringa() taglia una stringa troppo lunga.
     *
     * costante             | spiegazione
     * ---------------------|--------------------------------------------------------------
     * CUT_CENTER           | taglia la stringa al centro, conservandone l'inizio e la fine
     * CUT_RIGHT            | taglia la stringa a destra ( non ancora implementata in riduciStringa() )
     * CUT_LEFT             | taglia la stringa a sinistra ( non ancora implementata in riduciStringa() )
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire le stringhe da e verso altri tipi di dato.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * numeric2null()                   | converte un valore vuoto non numerico in NULL
     * string2num()                     | normalizza i separatori decimali e delle migliaia di una stringa numerica
     * empty2null()                     | converte un valore vuoto in NULL
     * string2boolean()                 | converte una stringa in un valore booleano
     * boolean2string()                 | converte un valore booleano in stringa
     * m2km()                           | converte i metri in chilometri
     * km2m()                           | converte i chilometri in metri
     * safe_unserialize()               | deserializza una stringa se contiene dati serializzati
     *
     * funzioni di formattazione
     * -------------------------
     * Le funzioni in questo gruppo servono per rendere leggibili dei valori, tipicamente per mostrarli all'utente o scriverli nei log.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * writeByte()                      | converte un intero in un numero di byte
     * writeCurrency()                  | formatta un numero come importo in valuta
     * int2month()                      | converte il numero di un mese nel suo nome in italiano
     * int2day()                        | converte il numero di un giorno della settimana nel suo nome in italiano
     * ts2string()                      | converte una timestamp in una data in forma estesa in italiano
     * date2string()                    | converte una data in forma estesa in italiano
     * logLvl2string()                  | converte in stringa il livello di errore
     * reportLvl2string()               | converte in stringa il livello di report
     * convertISO8601Duration()         | converte una durata ISO 8601 in ore, minuti e secondi
     *
     * funzioni di manipolazione e pulizia
     * -----------------------------------
     * Le funzioni in questo gruppo servono per modificare o ripulire il contenuto delle stringhe.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * riduciCaratteriDoppi()           | riduce i caratteri ripetuti in una stringa
     * riduciStringa()                  | riduce una stringa alla lunghezza data sostituendo la parte tagliata con un segnaposto
     * removeBom()                      | rimuove il BOM UTF-8 dall'inizio di una stringa
     * clean_string()                   | ripulisce una stringa da spazi superflui, caratteri non validi e caratteri di controllo
     * extractNumber()                  | rimuove da una stringa tutti i caratteri diversi da numeri, virgola e punto
     *
     * funzioni per gli URL
     * --------------------
     * Le funzioni in questo gruppo servono per lavorare con gli URL.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * domainFromURL()                  | restituisce il nome host di un URL
     * string2url()                     | normalizza una stringa in un URL valido
     *
     * funzioni di verifica e ricerca
     * ------------------------------
     * Le funzioni in questo gruppo servono per effettuare controlli sul contenuto delle stringhe.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * str_starts_with_array()          | verifica se una stringa comincia con uno dei prefissi dati
     * inRegexpArray()                  | verifica se una stringa corrisponde ad almeno una delle espressioni regolari date
     * isBinaryString()                 | verifica se una stringa non è testo UTF-8 valido
     *
     * funzioni di compatibilità
     * -------------------------
     * Queste funzioni sono definite solo se PHP non le fornisce già, per consentire l'uso del framework su versioni di PHP
     * più vecchie o prive delle estensioni necessarie.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * str_starts_with()                | verifica se una stringa comincia con un prefisso dato
     * mb_detect_encoding()             | distingue in modo approssimativo una stringa UTF-8 da una ASCII
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _log.utils.php
     *
     * Sono inoltre richieste le estensioni PHP iconv ( per clean_string() ) e mbstring ( per isBinaryString() ).
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-08-13       | Sara Tullini         | documentazione
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
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
     * una stringa che indica la dimensione con relativa unità di misura, con due decimali ( ad esempio "1.50 Mb" ).
     * La divisione avviene solo per valori strettamente maggiori di 1024, per cui 1024 byte restano "1024.00 Bytes".
     * Oltre i terabyte non ci sono unità di misura: per valori superiori a 1024 Tb l'indice dell'unità esce
     * dall'array e la stringa restituita non ha l'unità di misura ( con un warning ).
     * 
     * @param       int         $filesize       dimensione in byte
     * 
     * @return      string                      dimensione in Bytes, Kb, Mb, Gb, Tb
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
     * riduce i caratteri ripetuti in una stringa
     *
     * Questa funzione sostituisce le sequenze di caratteri ripetuti con un solo carattere, tramite un'espressione regolare.
     * Con il carattere di default ( lo spazio ) la riduzione riguarda qualsiasi sequenza di caratteri di spaziatura, compresi
     * tabulazioni e ritorni a capo, che vengono tutti sostituiti da un singolo spazio; con gli altri caratteri viene ridotta
     * solo la ripetizione del carattere indicato. I metacaratteri delle espressioni regolari vengono protetti, ad eccezione
     * della barra / che, essendo il delimitatore dell'espressione, la fa fallire ( in quel caso preg_replace() restituisce NULL ).
     * Se $c contiene più di un carattere viene trattato come una classe di caratteri e ogni sequenza di uno qualsiasi di essi
     * viene sostituita dall'intera stringa $c.
     *
     * @param       string      $t      la stringa da modificare
     * @param       string      $c      il carattere ripetuto da ridurre ( opzionale, di default riduce gli spazi )
     *
     * @return      string              la stringa modificata
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
     * converte un valore vuoto non numerico in NULL
     *
     * Questa funzione restituisce NULL se il valore passato è vuoto e non numerico ( stringa vuota, NULL, false, array vuoto ),
     * mentre restituisce invariati i valori numerici, compreso lo zero, e tutti gli altri valori; è in pratica empty2null()
     * con il parametro $numeric a true, e serve a non perdere gli zeri quando si prepara un valore per il database.
     *
     * Prima della conversione la funzione sostituisce la virgola decimale con il punto, ma solo se il valore è una stringa
     * che contiene una virgola e che con il punto al posto della virgola diventa numerica: "1,5" diventa "1.5", mentre
     * "Roma, 5" o "1,2,3" restano come sono. Una stringa con una sola virgola fra due gruppi di cifre viene sempre letta
     * come decimale, per cui "1,000" diventa "1.000", cioè uno.
     *
     * TODO la sostituzione della virgola così è un po' grezza, migliorare (può esserci anche il punto per le migliaia, eccetera)
     *
     * @param       mixed       $s      il valore da convertire
     *
     * @return      mixed               NULL se il valore è vuoto e non numerico, altrimenti il valore invariato
     *
     */
    function numeric2null( $s ) {
        // NB: prima la condizione era is_numeric( $s ), che per una stringa con la virgola è sempre falsa, e la sostituzione
        // non scattava mai; controller() passa qui tutti i campi, per cui si converte solo ciò che diventa un numero ( 2026-09-24 )
        if( is_string( $s ) && strpos( $s, ',' ) !== false && is_numeric( str_replace( ',', '.', $s ) ) ) {
            $s = str_replace( ',', '.', $s );
        }
        return empty2null( $s, true );
    }

    /**
     * normalizza i separatori decimali e delle migliaia di una stringa numerica
     *
     * Questa funzione prende una stringa che rappresenta un numero scritto con la virgola o il punto come separatori e la
     * riporta alla forma con il punto decimale e senza separatore delle migliaia: "1000,50", "1.000,50" e "1,000.50"
     * diventano tutti "1000.50". Se la stringa contiene solo la virgola, la virgola viene considerata decimale ( quindi
     * "1,000" diventa "1.000", cioè uno ); se contiene solo il punto viene lasciata invariata ( quindi "1.000" resta uno ).
     * Se la stringa, tolti virgole e punti, non è numerica viene restituita invariata. Il valore restituito resta una stringa:
     * la conversione a numero la fa PHP quando lo si usa in un'operazione aritmetica.
     *
     * Se il valore è vuoto ( compresi "0" e 0 ), oppure è un array o un oggetto, viene restituito invariato, a meno che
     * $force sia true: in quel caso la funzione restituisce 0.
     *
     * @param       mixed       $s          la stringa da normalizzare
     * @param       bool        $force      se true, i valori vuoti, gli array e gli oggetti vengono convertiti in 0 ( default false )
     *
     * @return      mixed                   la stringa normalizzata, il valore invariato oppure 0
     *
     */
    function string2num( $s, $force = false ) {
        if( ! empty( $s ) && ! is_array( $s ) && ! is_object( $s ) ) {
            if( is_numeric( str_replace( array( ',', '.' ), '', $s ) ) ) {
                if( strpos( $s, ',' ) !== false && strpos( $s, '.' ) === false ) {
                    // es. 1000,50 -> 1000.50
                    $s = str_replace( ',', '.', $s );
                } elseif( strpos( $s, ',' ) !== false && strpos( $s, '.' ) !== false ) {
                    if( strpos( $s, ',' ) < strpos( $s, '.' ) ) {
                        // es. 1,000.50 -> 1000.50
                        $s = str_replace( ',', '', $s );
                    } else {
                        // es. 1.000,50 -> 1000.50
                        $s = str_replace( ',', '.', str_replace( '.', '', $s ) );
                    }
                }
            }
        } elseif( $force === true ) {
            $s = 0;
        }
        return $s;
    }

    /**
     * converte un valore vuoto in NULL
     *
     * Questa funzione restituisce NULL se il valore passato è vuoto secondo empty() ( stringa vuota, "0", 0, NULL, false,
     * array vuoto ), altrimenti lo restituisce invariato. Se $numeric è true i valori numerici vengono sempre restituiti
     * invariati, per cui lo zero non viene convertito in NULL; è il caso tipico dei campi numerici da scrivere nel database.
     *
     * @param       mixed       $s          il valore da convertire
     * @param       bool        $numeric    se true, i valori numerici ( zero compreso ) non vengono convertiti ( default false )
     *
     * @return      mixed                   NULL se il valore è vuoto, altrimenti il valore invariato
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
     * converte una stringa in un valore booleano
     *
     * Questa funzione restituisce true se il valore passato è la stringa "true" ( senza distinzione fra maiuscole e minuscole )
     * oppure un valore che PHP considera uguale a 1 con il confronto non stretto dello switch ( 1, "1", true, "1.0" );
     * per qualsiasi altro valore, compresi i valori vuoti e stringhe come "yes" o "on", restituisce false.
     *
     * @param       mixed       $s      il valore da convertire
     *
     * @return      bool                true se il valore rappresenta il vero, false altrimenti
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
     * converte un valore booleano in stringa
     *
     * Questa funzione restituisce la stringa "true" se il valore passato è esattamente il booleano true, e "false" in tutti gli
     * altri casi; il confronto è stretto, per cui anche 1 o la stringa "true" producono "false".
     *
     * @param       mixed       $s      il valore da convertire
     *
     * @return      string              "true" oppure "false"
     *
     */
    function boolean2string( $s ) {

        return ( $s === true ) ? 'true' : 'false';

    }
        
    /**
     * riduce una stringa alla lunghezza data sostituendo la parte tagliata con un segnaposto
     *
     * Questa funzione accorcia una stringa inserendo al posto della parte eliminata il segnaposto $c; è usata da
     * _txt.tools.php per far stare le etichette nella larghezza dei report di testo. È implementata soltanto la modalità
     * CUT_CENTER, che conserva l'inizio e la fine della stringa: con le altre modalità la funzione restituisce NULL. La
     * lunghezza della stringa restituita è $l - 1 caratteri ( la stringa "abcdefghijklmnopqrstuvwxyz" ridotta a 10 diventa
     * "abcd~wxyz" ); i chiamanti di _txt.tools.php tengono conto di questo carattere in meno. Il conteggio è fatto in byte con
     * strlen() e substr(), per cui i caratteri multibyte possono essere spezzati.
     *
     * La funzione non controlla se la stringa è già abbastanza corta: con una stringa più corta di $l l'inizio e la fine si
     * sovrappongono e il risultato contiene parti ripetute ( "abc" ridotta a 10 diventa "abc~abc" ). Va quindi chiamata solo
     * sulle stringhe più lunghe di $l, come fanno i chiamanti attuali.
     *
     * TODO implementare CUT_RIGHT e CUT_LEFT, che oggi restituiscono NULL
     * TODO restituire la stringa invariata se è già lunga al massimo $l caratteri
     *
     * @param       string      $s      la stringa da ridurre
     * @param       int         $l      la lunghezza di riferimento ( la stringa ottenuta è lunga $l - 1 caratteri )
     * @param       string      $c      il segnaposto da inserire al posto della parte tagliata ( default '~' )
     * @param       string      $t      la modalità di taglio, una delle costanti CUT_* ( default CUT_CENTER )
     *
     * @return      string              la stringa ridotta, oppure NULL se la modalità di taglio non è CUT_CENTER
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
     * converte il numero di un mese nel suo nome in italiano
     *
     * Questa funzione restituisce il nome in minuscolo del mese corrispondente al numero passato ( da 1 per gennaio a 12
     * per dicembre ); il confronto non è stretto, per cui vanno bene anche le stringhe come "3" o "03". Per un numero fuori
     * intervallo restituisce la stringa "mese sconosciuto (x)". Il parametro della lingua è previsto ma non ancora usato:
     * il nome è sempre in italiano.
     *
     * @param       int         $m      il numero del mese, da 1 a 12
     * @param       string      $l      la lingua in formato IETF ( ignorato, default 'it-IT' )
     *
     * @return      string              il nome del mese
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
     * converte il numero di un giorno della settimana nel suo nome in italiano
     *
     * Questa funzione restituisce il nome in minuscolo del giorno della settimana corrispondente al numero passato, con la
     * numerazione di date( 'w' ): 0 per domenica, da 1 per lunedì a 6 per sabato. Per un numero fuori intervallo restituisce
     * la stringa "giorno sconosciuto (x)". Il parametro della lingua è previsto ma non ancora usato: il nome è sempre in
     * italiano.
     *
     * @param       int         $d      il numero del giorno della settimana, da 0 ( domenica ) a 6 ( sabato )
     * @param       string      $l      la lingua in formato IETF ( ignorato, default 'it-IT' )
     *
     * @return      string              il nome del giorno
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
     * Questa funzione restituisce il nome della costante di log di PHP corrispondente al livello passato, da 0 ( LOG_EMERG )
     * a 7 ( LOG_DEBUG ), come usati da logger(); per un valore fuori intervallo restituisce NULL. È usata dall'API di stato
     * del framework per mostrare il livello di log corrente. Il confronto dello switch non è stretto, per cui NULL e false
     * vengono interpretati come 0 e restituiscono 'LOG_EMERG'.
     *
     * @param       int         $l      il livello di log, da 0 a 7
     *
     * @return      string              il nome della costante di log, oppure NULL se il livello non è riconosciuto
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
     * Questa funzione restituisce il nome della costante di error reporting di PHP corrispondente al valore passato; è usata
     * dall'API di stato del framework per mostrare il livello di report corrente ( REPORT_CURRENT_LEVEL ). La funzione
     * riconosce i singoli livelli elencati nella tabella seguente ed E_ALL; poiché il valore passato a error_reporting() è
     * una maschera di bit, per una combinazione di più livelli restituisce i nomi dei livelli presenti uniti da " | "
     * ( es. "E_ERROR | E_WARNING" ). Per zero, o per un valore che non contiene nessun livello noto, restituisce NULL.
     *
     * costante              | valore   | significato
     * ----------------------|----------|-------------------------------------------------------------------
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
     * E_ALL                 |   32767  | tutti i messaggi di errore ( 30719 da PHP 8.4, che ne toglie E_STRICT )
     *
     * @param       int         $l      il livello di report
     *
     * @return      string              il nome della costante di report, i nomi dei livelli presenti uniti da " | ", oppure
     *                                  NULL se il livello non è riconosciuto
     *
     */
    function reportLvl2string( $l ) {

        // NB: E_ALL si confronta con la costante perché il suo valore cambia con la versione di PHP ( 2026-09-24 )
        if( $l == E_ALL ) {
            return 'E_ALL';
        }

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
            case 4096:
                return 'E_RECOVERABLE_ERROR';
            break;
            case 8192:
                return 'E_DEPRECATED';
            break;
            case 16384:
                return 'E_USER_DEPRECATED';
            break;
            default:

                // NB: error_reporting() riceve una maschera di bit, per cui un valore che non è un livello singolo si
                // scompone nei livelli che contiene, invece di restituire NULL come prima ( 2026-09-24 )
                $r = array();
                for( $b = 1; $b <= 16384; $b *= 2 ) {
                    if( (int) $l & $b ) {
                        $r[] = reportLvl2string( $b );
                    }
                }

                return ( empty( $r ) ) ? NULL : implode( ' | ', $r );

            break;
        }

    }
    
    /**
     * converte una timestamp in una data in forma estesa in italiano
     *
     * Questa funzione restituisce la data corrispondente alla timestamp Unix passata nella forma "giorno mese anno" con il
     * nome del mese in italiano, ad esempio "5 marzo 2024"; il giorno è senza zero iniziale. Il nome del mese è ottenuto con
     * int2month().
     *
     * @param       int         $d      la timestamp Unix da convertire
     *
     * @return      string              la data in forma estesa
     *
     */
    function ts2string( $d ) {

        return date( 'j', $d ) . ' ' . int2month( date( 'n', $d ) ) . ' ' . date( 'Y', $d );

    }

    /**
     * converte una data in forma estesa in italiano
     *
     * Questa funzione converte la data passata in timestamp con strtotime() e la passa a ts2string(), restituendo quindi una
     * stringa come "5 marzo 2024". Se strtotime() non riesce a interpretare la data restituisce false, che date() tratta come
     * zero: il risultato è in quel caso "1 gennaio 1970" ( o la data corrispondente all'epoca nel fuso orario corrente ).
     *
     * @param       string      $d      la data da convertire, in un formato riconosciuto da strtotime()
     *
     * @return      string              la data in forma estesa
     *
     */
    function date2string( $d ) {

        return ts2string( strtotime( $d ) );

    }

    /**
     * verifica se una stringa comincia con un prefisso dato
     *
     * Questa funzione è definita solo se PHP non fornisce già la funzione nativa str_starts_with(), introdotta con PHP 8, e ne
     * riproduce il comportamento: restituisce true se $haystack comincia con $needle, false altrimenti.
     *
     * @param       string      $haystack       la stringa in cui cercare
     * @param       string      $needle         il prefisso da cercare
     *
     * @return      bool                        true se la stringa comincia con il prefisso, false altrimenti
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
     * verifica se una stringa comincia con uno dei prefissi dati
     *
     * Questa funzione restituisce true se la stringa comincia con almeno uno dei prefissi contenuti nell'array $needles, e
     * false altrimenti, compreso il caso di array vuoto. È usata ad esempio dall'API di upload per verificare che la cartella
     * di destinazione sia fra quelle ammesse.
     *
     * @param       string      $haystack       la stringa in cui cercare
     * @param       array       $needles        l'array dei prefissi da cercare
     *
     * @return      bool                        true se la stringa comincia con uno dei prefissi, false altrimenti
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
     * converte i metri in chilometri
     *
     * Questa funzione divide per mille il valore passato.
     *
     * @param       float       $m      la distanza in metri
     *
     * @return      float               la distanza in chilometri
     *
     */
    function m2km( $m ) {

        return $m / 1000;

    }

    /**
     * converte i chilometri in metri
     *
     * Questa funzione moltiplica per mille il valore passato.
     *
     * @param       float       $km     la distanza in chilometri
     *
     * @return      float               la distanza in metri
     *
     */
    function km2m( $km ) {

        return $km * 1000;

    }

    /**
     * rimuove il BOM UTF-8 dall'inizio di una stringa
     *
     * Questa funzione elimina il Byte Order Mark UTF-8 ( la sequenza di byte EF BB BF ) se si trova all'inizio della stringa,
     * cosa che capita con i file di testo salvati da alcuni editor; se il BOM non c'è la stringa viene restituita invariata.
     *
     * TODO questa funzione va aggiunta a readFromFile() per evitare che dia fuori il testo con il BOM
     *
     * @param       string      $t      la stringa da ripulire
     *
     * @return      string              la stringa senza BOM
     *
     */
    function removeBom( $t ) {
        $bom = pack('H*','EFBBBF');
        $t = preg_replace("/^$bom/", '', $t);
        return $t;
    }

    /**
     * restituisce il nome host di un URL
     *
     * Questa funzione estrae con parse_url() il nome host dall'URL passato; è usata per ricavare i domini da inserire nella
     * Content Security Policy delle pagine. Se l'URL non contiene un host ( ad esempio "example.com" senza schema, che
     * parse_url() interpreta come un percorso ) oppure non è interpretabile, la funzione restituisce NULL generando un warning.
     *
     * @param       string      $url    l'URL da cui estrarre l'host
     *
     * @return      string              il nome host, oppure NULL se non presente
     *
     */
    function domainFromURL( $url ) {

        $array = parse_url( $url );
        return $array['host'];

    }

    /**
     * verifica se una stringa corrisponde ad almeno una delle espressioni regolari date
     *
     * Questa funzione confronta la stringa con ciascuna delle espressioni regolari contenute nell'array e restituisce true
     * se almeno una corrisponde, false altrimenti ( anche se l'array è vuoto ). Le espressioni possono essere scritte complete
     * di delimitatori e modificatori ( ad esempio "/^abc/i" ) oppure senza: in quel caso vengono racchiuse fra due barre. Una
     * espressione senza delimitatori che contiene a sua volta una barra non protetta non è valida e non corrisponde mai.
     * È usata dall'API di stato del framework per riconoscere i cookie dichiarati con un'espressione regolare.
     *
     * @param       string      $t      la stringa da verificare
     * @param       array       $a      l'array delle espressioni regolari
     *
     * @return      bool                true se almeno un'espressione corrisponde, false altrimenti
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

    /**
     * ripulisce una stringa da spazi superflui, caratteri non validi e caratteri di controllo
     *
     * Questa funzione è usata da _csv.tools.php per ripulire i valori letti dai file CSV. Nell'ordine: toglie gli spazi in
     * testa e in coda, elimina le sequenze di byte che non sono UTF-8 valido, sostituisce con uno spazio i caratteri di
     * controllo ( ASCII e Unicode, compresi gli spazi e i separatori invisibili ) e infine riduce a un solo spazio ogni
     * sequenza di caratteri di spaziatura. Ogni passo che modifica davvero la stringa viene registrato nel log
     * details/csv/cleanstring, a LOG_ERR per i primi due e a LOG_INFO per la riduzione degli spazi; la nota nel corpo della
     * funzione spiega perché.
     *
     * @param       string      $string     la stringa da ripulire
     *
     * @return      string                  la stringa ripulita
     *
     */
    function clean_string($string) {

        /**
         * OGNI CONTROLLO SI CONFRONTA CON IL PASSO PRECEDENTE, NON CON L'ORIGINALE
         * ( fix 2026-09-12 ).
         *
         * Fino a qui tutti e tre i controlli confrontavano $s con $string, cioe' con la stringa
         * di partenza NON ripulita dal trim(). Effetto: bastava uno spazio in testa o in coda -
         * il caso piu' comune che esista in un CSV - perche' tutte e tre le condizioni restassero
         * vere fino in fondo, e la funzione scrivesse TRE righe di log, a LOG_ERR, per una
         * stringa a cui non era stato fatto niente di anomalo.
         *
         * Il 12/09/2026 questo ha prodotto 1,37 GB in var/log/details/csv/cleanstring.err.202609.log
         * durante una sola importazione: il dataset veniva riparsato a ogni iterazione e ogni
         * campo con uno spazio di troppo passava di qui. Essendo a LOG_ERR, abbassare il livello
         * di log del deploy non lo spegne: la correzione doveva stare qui.
         *
         * Adesso ogni passo dichiara soltanto cio' che ha cambiato davvero. Il trim non e' un
         * errore e non si logga; la normalizzazione degli spazi doppi e' normalizzazione e non
         * un'anomalia di codifica, quindi scende a LOG_INFO.
         */
        $s = trim( $string );

        $p = $s;
        $s = iconv( "UTF-8", "UTF-8//IGNORE", $s );

        if( $s !== $p ) {
            logWrite( $p . ' pulito (clean UTF-8) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        $p = $s;
        $s = preg_replace( '/(?>[\x00-\x1F]|\xC2[\x80-\x9F]|\xE2[\x80-\x8F]{2}|\xE2\x80[\xA4-\xA8]|\xE2\x81[\x9F-\xAF])/', ' ', $s );

        if( $s !== $p ) {
            logWrite( $p . ' pulito (rimozione caratteri speciali step 1) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }

        /*
        $s = preg_replace( '/[\x00-\x1F\x80-\xFF]/', '', $s );

        if( $s != $string ) {
            logWrite( $string . ' pulito (rimozione caratteri speciali step 2) a ' . $s, 'details/csv/cleanstring', LOG_ERR );
        }
        */

        $p = $s;
        $s = preg_replace('/\s+/', ' ', $s );

        if( $s !== $p ) {
            logWrite( $p . ' pulito (rimozione spazi doppi) a ' . $s, 'details/csv/cleanstring', LOG_INFO );
        }

        return $s;

    }

    /**
     * distingue in modo approssimativo una stringa UTF-8 da una ASCII
     *
     * Questa funzione è definita solo se l'estensione mbstring non è disponibile e sostituisce in modo molto semplificato la
     * funzione nativa mb_detect_encoding(): restituisce 'UTF-8' se la stringa sopravvive invariata alla doppia conversione
     * utf8_decode() / utf8_encode(), e 'ASCII' altrimenti. Accetta un solo parametro, per cui gli altri argomenti della
     * funzione nativa non sono supportati.
     *
     * NOTA utf8_encode() e utf8_decode() sono deprecate da PHP 8.2; inoltre senza mbstring manca anche mb_check_encoding(),
     * per cui isBinaryString() non funziona comunque.
     *
     * @param       string      $string     la stringa da esaminare
     *
     * @return      string                  'UTF-8' oppure 'ASCII'
     *
     */
    if( ! function_exists( 'mb_detect_encoding' ) ) {

        function mb_detect_encoding( $string ) {

            return ( utf8_encode( utf8_decode( $string ) ) == $string ) ? 'UTF-8' : 'ASCII';

        }

    }

    /**
     * verifica se una stringa non è testo UTF-8 valido
     *
     * Questa funzione restituisce true se la stringa non è codificata in UTF-8 valido, e la considera quindi un contenuto
     * binario; è usata da _filesystem.tools.php per distinguere i file di testo da quelli binari. Si noti che anche un testo
     * in una codifica diversa, ad esempio ISO-8859-1 con lettere accentate, risulta binario; la stringa vuota non lo è.
     *
     * @param       string      $data       la stringa da verificare
     *
     * @return      bool                    true se la stringa non è UTF-8 valido, false altrimenti
     *
     */
    function isBinaryString( $data ) {        
        return ! mb_check_encoding( $data, 'UTF-8' );
    }

    /**
     * rimuove da una stringa tutti i caratteri diversi da numeri, virgola e punto
     *
     * Questa funzione restituisce la stringa passata privata di ogni carattere che non sia una cifra, una virgola o un punto;
     * serve ad esempio a estrarre un importo da un testo come "€ 1.234,50". Il risultato non viene normalizzato ( per quello
     * si veda string2num() ) e il segno meno viene eliminato, per cui un numero negativo diventa positivo.
     *
     * @param       string      $string     la stringa da cui estrarre il numero
     *
     * @return      string                  la stringa contenente solo cifre, virgole e punti
     *
     */
    function extractNumber( $string ) {

        return preg_replace( '/[^0-9\.\,]/', '', $string );

    }

    /**
     * formatta un numero come importo in valuta
     *
     * Questa funzione restituisce il valore passato formattato all'italiana, con due decimali, la virgola decimale e il punto
     * come separatore delle migliaia, preceduto dal simbolo della valuta e da uno spazio ( ad esempio "€ 1.234,50" ). Il
     * valore deve essere numerico: con una stringa non numerica number_format() solleva un errore.
     *
     * @param       float       $v      l'importo da formattare
     * @param       string      $c      il simbolo della valuta ( default '€' )
     *
     * @return      string              l'importo formattato
     *
     */
    function writeCurrency( $v, $c = '€' ) {

        return $c . ' ' . number_format( $v, 2, ',', '.' );

    }

    /**
     * normalizza una stringa in un URL valido
     *
     * Questa funzione prende un URL che può contenere caratteri non ammessi ( spazi, lettere accentate, eccetera ) e prova a
     * renderlo valido: se la stringa è già un URL valido la restituisce così com'è, altrimenti la scompone con parse_url(),
     * codifica ciascun segmento del percorso con rawurlencode() eliminando le barre doppie, ricostruisce la query string con
     * http_build_query() e rimette insieme l'URL. È usata da _filesystem.tools.php per scaricare file da URL scritti in modo
     * non canonico. Gli spazi in testa e in coda vengono ignorati; se il percorso manca viene impostato a "/".
     *
     * La funzione restituisce NULL se la stringa è vuota, se non è interpretabile da parse_url(), se manca lo schema o l'host
     * ( quindi "www.example.com" senza "https://" non viene accettato ) oppure se l'URL ricostruito non è comunque valido.
     *
     * @param       string      $url    la stringa da normalizzare
     *
     * @return      string              l'URL normalizzato, oppure NULL se non è possibile ottenere un URL valido
     *
     */
    function string2url( string $url ): ?string {

        // Trim iniziale
        $url = trim($url);

        if ($url === '') {
            return null;
        }

        // Se è già una URL valida, la restituisco così com'è
        if (filter_var($url, FILTER_VALIDATE_URL)) {
            return $url;
        }

        // Provo a parsare la URL
        $parts = parse_url($url);
        if ($parts === false) {
            return null;
        }

        // Per avere una URL completa, almeno scheme + host devono esistere
        if (!isset($parts['scheme'], $parts['host'])) {
            return null;
        }

        // Normalizzo il path (encodo ogni segmento)
        if (isset($parts['path'])) {
            // evito doppie slash
            $parts['path'] = preg_replace('#/{2,}#', '/', $parts['path']);

            $segments = explode('/', $parts['path']);
            $segments = array_map(function($seg) {
                // lascio vuoto il segmento vuoto (prima dello slash iniziale)
                return $seg === '' ? '' : rawurlencode($seg);
            }, $segments);

            $parts['path'] = implode('/', $segments);
        } else {
            $parts['path'] = '/';
        }

        // Normalizzo la query (se esiste) ricostruendola con http_build_query
        if (isset($parts['query'])) {
            parse_str($parts['query'], $q);
            $parts['query'] = http_build_query($q);
        }

        // Ricostruisco la URL
        $newUrl  = $parts['scheme'] . '://';

        if (isset($parts['user'])) {
            $newUrl .= $parts['user'];
            if (isset($parts['pass'])) {
                $newUrl .= ':' . $parts['pass'];
            }
            $newUrl .= '@';
        }

        $newUrl .= $parts['host'];

        if (isset($parts['port'])) {
            $newUrl .= ':' . $parts['port'];
        }

        $newUrl .= $parts['path'];

        if (!empty($parts['query'])) {
            $newUrl .= '?' . $parts['query'];
        }

        if (!empty($parts['fragment'])) {
            $newUrl .= '#' . $parts['fragment'];
        }

        // Controllo finale di validità
        if (filter_var($newUrl, FILTER_VALIDATE_URL)) {
            return $newUrl;
        }

        return null;
    }

    /**
     * converte una durata ISO 8601 in ore, minuti e secondi
     *
     * Questa funzione prende una durata in formato ISO 8601 ( ad esempio "PT1H2M30S" ) e la restituisce nella forma
     * "hh:mm:ss", oppure "mm:ss" se la durata è inferiore all'ora. Se il valore passato è vuoto restituisce NULL; se non è una
     * durata valida il costruttore di DateInterval solleva un'eccezione, che la funzione non intercetta. Vengono considerate
     * solo ore, minuti e secondi: giorni, mesi e anni eventualmente presenti vengono ignorati ( "P1DT2H" diventa "02:00:00" ).
     *
     * @param       string      $duration       la durata in formato ISO 8601
     *
     * @return      string                      la durata in forma hh:mm:ss o mm:ss, oppure NULL se vuota
     *
     */
    function convertISO8601Duration($duration) {
        if(!$duration) return null;

        $interval = new DateInterval($duration);

        $hours = $interval->h;
        $minutes = $interval->i;
        $seconds = $interval->s;

        if($hours > 0) {
            return sprintf('%02d:%02d:%02d', $hours, $minutes, $seconds);
        } else {
            return sprintf('%02d:%02d', $minutes, $seconds);
        }
    }

    /**
     * deserializza una stringa se contiene dati serializzati
     *
     * Questa funzione prova a deserializzare il valore passato solo se ha l'aspetto di un dato prodotto da serialize(), e in
     * tutti gli altri casi lo restituisce invariato; si può quindi chiamare senza controlli preventivi su valori che possono
     * essere serializzati oppure no. I valori non stringa vengono restituiti così come sono; le stringhe vengono ripulite dagli
     * spazi in testa e in coda e deserializzate se lunghe almeno quattro caratteri e se cominciano con uno dei tipi a, O, s,
     * b, i o d seguito dai due punti. La stringa "b:0;" viene riconosciuta a parte e restituisce false. Se la deserializzazione
     * fallisce viene restituita la stringa ( già ripulita dagli spazi ).
     *
     * Per sicurezza la deserializzazione non istanzia oggetti ( allowed_classes a false ): un oggetto serializzato diventa un
     * __PHP_Incomplete_Class. Il NULL serializzato ( "N;" ) è più corto di quattro caratteri e viene restituito come stringa.
     *
     * @param       mixed       $value      il valore da deserializzare
     *
     * @return      mixed                   il valore deserializzato, oppure il valore di partenza se non è serializzato
     *
     */
    function safe_unserialize($value) {

    // Se non è una stringa non può essere serializzata
    if (!is_string($value)) {
        return $value;
    }

    $value = trim($value);

    // Caso speciale: false serializzato
    if ($value === 'b:0;') {
        return false;
    }

    // Lunghezza minima plausibile
    if (strlen($value) < 4) {
        return $value;
    }

    // Deve iniziare con un tipo valido di serialize
    if (!preg_match('/^[aOsbid]:/', $value)) {
        return $value;
    }

    // Tentativo di unserialize sicuro (no oggetti)
    $result = @unserialize($value, ['allowed_classes' => false]);

    // Se fallisce, restituisco il valore originale
    if ($result === false && $value !== 'b:0;') {
        return $value;
    }

    return $result;
}
