<?php

    /**
     * libreria per la gestione e la manipolazione degli array
     * 
     * Questa libreria contiene una collezione di funzioni utili per lavorare con gli array; la gestione degli array è particolarmente importante per il
     * funzionamento di GlisWeb dal momento che, data la sua natura essenzialmente procedurale, ne fa largo uso.
     * 
     * introduzione
     * ============
     * Questa libreria aiuta gli sviluppatori a gestire gli array, semplificando molte operazioni di uso comune e implementando soluzioni efficienti per alcuni
     * dei problemi classici che ci si trova di fronte lavorando con gli array.
     * 
     * Come di consueto le funzioni della libreria sono raggruppate per area tematica e sono precedute dalla dichiarazione delle costanti essenziali per il
     * funzionamento della libreria stessa.
     * 
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * ARRAY_SORT_ASC               | costante per l'ordinamento ascendente degli array
     * ARRAY_SORT_DSC               | costante per l'ordinamento discendente degli array
     * ARRAY_SEPARATOR              | separatore di default per la conversione di stringhe in array
     * CHECK_BY_KEY                 | costante per la verifica di esistenza di un elemento in un array
     * CHECK_BY_VALUE               | costante per la verifica di esistenza di un valore in un array
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire da array o in array vari tipi di dati.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * array2string()                   | converte un array in una stringa
     * string2array()                   | converte una stringa in un array
     * 
     * funzioni di ordinamento
     * -----------------------
     * Le funzioni in questo gruppo servono per ordinare gli array.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * rksort()                         | ordina un array in modo ricorsivo
     * arraySortBy()                    | ordina un array in base a uno o più campi
     * 
     * funzioni di manipolazione dei dati
     * ----------------------------------
     * Le funzioni in questo gruppo servono per manipolare i dati all'interno degli array.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * trimArray()                      | rimuove gli elementi vuoti da un array
     * removeFromArray()                | rimuove uno o più elementi da un array
     * removeColumnsFromArray()         | rimuove una o più colonne da un array
     * removeColumnFromArray()          | rimuove una colonna da un array
     * renameColumnInArray()            | rinomina una colonna in un array
     * arrayLowercase()                 | modifica in lowercase tutti gli elementi di un array
     * remapArray()                     | rimappa un array
     * arrayFilterBy()                  | rimuove gli elementi di un array che non contengono una stringa
     * arrayKeyValuesImplode()          | implode un array associativo in una stringa
     * arrayInsertAssoc()               | inserisce un elemento in un array dopo un altro elemento specificato
     * arrayInsertSeq()                 | inserisce un elemento in un array dopo una posizione specificata
     * arrayInsertBefore()              | inserisce un elemento in un array prima di un altro elemento specificato
     * addStr2arrayElements()           | aggiunge una stringa a tutti gli elementi di un array
     * reindex_array_recursive()        | reindicizza un array in modo ricorsivo
     * arrayReplaceRecursive()          | rimpiazza ricorsivamente un valore in un array
     * 
     * funzioni di ricerca
     * -------------------
     * Le funzioni in questo gruppo servono per cercare elementi all'interno degli array.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * array_key_first()                | restituisce la prima chiave dell'array
     * array_key_last()                 | restituisce l'ultima chiave dell'array
     * array_column()                   | restituisce i valori di una colonna di un array
     * 
     * funzioni di verifica
     * --------------------
     * Le funzioni in questo gruppo servono per effettuare vari controlli sugli array.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * is_associative_array()           | verifica se un array è associativo
     * isEmptyArray()                   | verifica se un array è vuoto
     * 
     * funzioni di stampa
     * ------------------
     * Le funzioni in questo gruppo servono per stampare gli array.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * print_l()                        | stampa un array in linea
     * 
     * funzioni specifiche per GlisWeb
     * -------------------------------
     * Queste funzioni sono specifiche per GlisWeb e servono a manipolare gli array in modo da adattarli alle esigenze del CMS.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * metadati2associativeArray()      | trasforma una stringa di metadati in un array associativo
     * 
     * funzioni di retrocompatibilità
     * ------------------------------
     * Nel corso del tempo sono state effettuate diverse operazioni di refactoring che hanno portato alla modifica di nomi di funzioni utilizzate in passato;
     * per garantire la retrocompatibilità con le versioni precedenti del framework sono state create delle funzioni wrapper che richiamano le nuove funzioni.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * arrayTrim()                      | alias di trimArray()
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-05-02       | Fabio Mosti          | refactoring completo della libreria
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    // definizione delle costanti della libreria
    if( ! defined( 'ARRAY_SORT_ASC' ) ) { define( 'ARRAY_SORT_ASC'          , 'ASC' ); }
    if( ! defined( 'ARRAY_SORT_DSC' ) ) { define( 'ARRAY_SORT_DSC'          , 'DSC' ); }
    if( ! defined( 'ARRAY_SEPARATOR' ) ) { define( 'ARRAY_SEPARATOR'        , '|' ); }
    if( ! defined( 'CHECK_BY_KEY' ) ) { define( 'CHECK_BY_KEY'              , 'CBK' ); }
    if( ! defined( 'CHECK_BY_VALUE' ) ) { define( 'CHECK_BY_VALUE'          , 'CBV' ); }

    // funzioni richieste
    if( ! function_exists( 'logger' ) ) {
        die( 'la funzione core logger() non è definita, definirla per utilizzare la libreria' );
    }

    /**
     * FUNZIONI DI CONVERSIONE
     */

    /**
     * converte una stringa in un array
     * 
     * Questa funzione prende in input una stringa e la converte in array; se la stringa passata è vuota restituisce
     * un array vuoto.
     * 
     * @param       string      $s      la stringa da convertire
     * @param       string      $c      il separatore da utilizzare per la conversione
     * 
     * @return      array               l'array ottenuto dalla conversione
     * 
     */
    function string2array( &$s, $c = ARRAY_SEPARATOR ) {
        if( empty( $s ) ) {
            return array();
        } else {
            $s = explode( $c, $s );
        }
    }

    /**
     * converte un array in una stringa
     * 
     * Questa funzione prende in input un array e lo converte in una stringa; se l'array passato è vuoto restituisce una
     * stringa vuota. Per riunire l'array in una stringa viene utilizzato il separatore passato come secondo parametro.
     * 
     * @param       array       $a      l'array da convertire
     * @param       string      $c      il separatore da utilizzare per la conversione
     * 
     * @return      string              la stringa ottenuta dalla conversione
     * 
     */
    function array2string( &$a, $c = ARRAY_SEPARATOR ) {
        if( empty( $a ) ) {
            return '';
        } else {
            $a = implode( $c, $a );
        }
    }

    /**
     * FUNZIONI DI ORDINAMENTO
     */

    /**
     * ordina un array in modo ricorsivo
     * 
     * Questa funzione ordina un array in modo ricorsivo, ovvero ordina l'array principale e tutti i suoi array figli.
     * 
     * @param       array       $array      l'array da ordinare
     * 
     * @return      void
     * 
     */
    function rksort( &$array ) {
        if( is_array( $array ) ) {
            ksort( $array );
            array_walk( $array, 'rksort' );
        }
    }

    /**
     * ordina un array in base a uno o più campi
     * 
     * Questa funzione ordina un array in base a uno o più campi specificati; se i campi sono più di uno, l'ordinamento
     * avviene in base al primo campo, e in caso di parità in base al secondo campo, e così via.
     * 
     * @param       mixed       $fields     il campo o i campi su cui ordinare l'array
     * 
     * @return      void
     * 
     */
    function arraySortBy( $fields, &$array, $direction = ARRAY_SORT_ASC ) {

        if( ! is_array( $fields ) ) {
            $fields = array( $fields );
        }

        usort( $array,
            function( $a, $b ) use ( $fields, $direction ) {
                $direction = ( $direction == ARRAY_SORT_ASC ) ? -1 : 1;
                foreach( $fields as $field ) {
                    $a = strtolower( $a[ $field ] );
                    $b = strtolower( $b[ $field ] );
                    if ( empty( $a ) && ! empty( $b ) ) return -1 * $direction;
                    if ( ! empty( $a ) && empty(  $b ) ) return 1 * $direction;
                    if ( $a > $b ) return -1 * $direction;
                    if ( $a < $b ) return 1 * $direction;
                }
                if ( $a == $b ) { return 0; }
            }
        );

    }

    /**
     * FUNZIONI DI MANIPOLAZIONE DEI DATI
     */

    /**
     * rimuove gli elementi vuoti da un array
     * 
     * Questa funzione rimuove gli elementi vuoti da un array, ovvero gli elementi che sono nulli o vuoti.
     * 
     * @param       array       $ar         l'array da ripulire
     * @param       int         $limit      il limite di lunghezza degli elementi
     * 
     * @return      array                   l'array ripulito
     * 
     */
    function trimArray( $ar, $limit = 0 ) {
        $ar = array_map( 'strval', $ar ); #elimina i null
        $ar = array_map( 'trim', $ar );
        $ar = array_filter( $ar );
        return $ar;
    }

    /**
     * rimuove uno o più elementi da un array
     * 
     * Questa funzione rimuove uno o più elementi da un array; se l'elemento da rimuovere è una stringa, viene convertita
     * in un array di un solo elemento, in modo da poter utilizzare in entrambi i casi la funzione array_diff().
     * 
     * @param       array       $a      l'array da cui rimuovere l'elemento
     * @param       mixed       $e      l'elemento da rimuovere
     * 
     * @return      void
     * 
     */
    function removeFromArray( &$a, $e ) {
        if( ! is_array( $e ) ) { $e = array( $e ); }
        $a = array_diff( $a, $e );
    }

    /**
     * rimuove una o più colonne da un array
     * 
     * Questa funzione rimuove una o più colonne da un array multidimensionale.
     * 
     * @param       array       $array      l'array da cui rimuovere le colonne
     * @param       array       $keys       l'array contenente i nomi delle colonne da rimuovere
     * 
     * @return      void
     * 
     */
    function removeColumnsFromArray( &$array, $keys ) {
        if( ! is_array( $keys ) ) { $keys = array( $keys ); }
        foreach( $keys as $key ) {
            removeColumnFromArray( $array, $key );
        }
    }

    /**
     * rimuove una colonna da un array
     * 
     * Questa funzione rimuove una colonna da un array multidimensionale.
     * TODO questa funzione è sostanzialmente un doppione di removeColumnsFromArray, va eliminata
     * 
     * @param       array       $array      l'array da cui rimuovere la colonna
     * @param       string      $key        il nome della colonna da rimuovere
     * 
     * @return      void
     * 
     */
    function removeColumnFromArray( &$array, $key ) {
        return array_walk($array, function (&$v) use ($key) {
            unset($v[$key]);
        });
    }

    /**
     * rinomina una colonna in un array
     * 
     * Questa funzione rinomina una colonna in un array multidimensionale.
     * 
     * @param       array       $array      l'array in cui rinominare la colonna
     * @param       string      $oldKey     il nome della colonna da rinominare
     * @param       string      $newKey     il nuovo nome della colonna
     * 
     * @return      void
     * 
     */
    function renameColumnInArray( &$array, $oldKey, $newKey ) {
        return array_walk($array, function (&$v) use ($oldKey, $newKey) {
            $v[$newKey] = $v[$oldKey];
            unset($v[$oldKey]);
        });
    }

    /**
     * modifica in lowercase tutti gli elementi di un array
     * 
     * Questa funzione modifica in lowercase tutti gli elementi di un array.
     * 
     * @param       array       $a      l'array da modificare
     * 
     * @return      void
     * 
     */
    function arrayLowercase( &$a ) {
        $a = array_map( 'strtolower', $a );
    }

    /**
     * rimappa un array
     * 
     * Questa funzione rimappa un array multidimensionale in base a un array di mappatura.
     * 
     * @param       array       $array      l'array da rimappare
     * @param       array       $map        l'array di mappatura
     * 
     * @return      void
     * 
     */
    function remapArray( &$array, $map ) {
        return array_walk($array, function (&$v) use ($map) {
            foreach( $map as $old => $new ) {
                $n[ $new ] = $v[ $old ];
            }
            $v = $n;
        });
    }

    /**
     * rimuove gli elementi di un array che non contengono una stringa
     * 
     * Questa funzione rimuove gli elementi di un array che non contengono una stringa specificata.
     * 
     * @param       array       $fields     i campi su cui effettuare la ricerca
     * @param       string      $match      la stringa da cercare
     * @param       array       $array      l'array da filtrare
     * 
     * @return      void
     * 
     */
    function arrayFilterBy( $fields, $match, &$array ) {

        $filtered = array();

        if( empty( $fields ) ) {
            $fields = array_keys( $array[0] );
        } elseif( ! is_array( $fields ) ) {
            $fields = explode( ',', $array );
            array_map( 'trim', $fields );
        }

        $tokens = explode( ' ', $match );

        foreach( $array as $row ) {

            $matches = 0;

            foreach( $row as $field ) {

                foreach( $tokens as $token ) {
                    if( preg_match( '/' . $token . '/i', $field ) ) {
                        $matches++;
                    }
                }

            }

            if( $matches > 0 ) {
                $filtered[] = $row;
            }

        }

        $array = $filtered;

    }

    /**
     * implode un array associativo in una stringa
     * 
     * Questa funzione prende in input un array associativo e lo trasforma in una stringa di coppie chiave valore.
     * 
     * @param       array       $array      l'array da trasformare
     * @param       string      $tk1        il separatore tra chiave e valore
     * @param       string      $tk2        il separatore tra le coppie chiave valore
     * 
     * @return      string                  la stringa ottenuta dalla trasformazione
     * 
     */
    function arrayKeyValuesImplode( $array, $tk1 = '=', $tk2 = '&', $empty = false ) {

        $t = array();

        foreach( $array as $k => $v ) {
            if( ! empty( $v ) || $empty === true ) {
                $t[] = $k . $tk1 . $v;
            }
        }

        return implode( $tk2, $t );

    }

    /**
     * inserisce un elemento in un array dopo un altro elemento specificato
     * 
     * Questa funzione inserisce un elemento in un array dopo un altro elemento specificato.
     * 
     * @param       mixed       $ref        l'elemento di riferimento
     * @param       array       $target     l'array in cui inserire l'elemento
     * 
     * @return      void
     * 
     */
    function arrayInsertAssoc( $ref, &$target, $add ) {

        $r = array();

        foreach( $target as $k => $v ) {

            $r[ $k ] = $v;

            if( $k == $ref ) {
                foreach( $add as $y => $j ) {
                    $r[ $y ] = $j;
                }
            }

        }

        $target = $r;

    }

    /**
     * inserisce un elemento in un array dopo una posizione specificata
     * 
     * Questa funzione inserisce un elemento in un array dopo una posizione specificata.
     * 
     * @param       int         $pos        la posizione di riferimento
     * @param       array       $target     l'array in cui inserire l'elemento
     * @param       mixed       $add        l'elemento da inserire
     * 
     * @return      void
     * 
     */
    function arrayInsertSeq( $ref, &$target, $add ) {

        array_splice( $target, ( array_search( $ref, $target ) + 1 ), 0, $add );

    }

    /**
     * inserisce un elemento in un array prima di una posizione specificata
     * 
     * Questa funzione inserisce un elemento in un array prima di una posizione specificata.
     * 
     * @param       mixed       $ref        l'elemento di riferimento
     * @param       array       $target     l'array in cui inserire l'elemento
     * @param       mixed       $add        l'elemento da inserire
     * 
     * @return      void
     * 
     */
    function arrayInsertBefore( $ref, &$target, $add ) {

        array_splice( $target, ( array_search( $ref, $target ) ), 0, $add );

    }

    /**
     * aggiunge una stringa a tutti gli elementi di un array
     * 
     * Questa funzione aggiunge una stringa a tutti gli elementi di un array.
     * 
     * @param       array       $a      l'array da modificare
     * @param       string      $p      la stringa da aggiungere all'inizio
     * @param       string      $s      la stringa da aggiungere alla fine
     * 
     * @return      array               l'array modificato
     * 
     */
    function addStr2arrayElements( $a, $p = '', $s = '' ) {
        return array_map(
            function( $v ) use ( $p, $s ) {
                return $p . $v . $s;
            },
            $a
        );
    }

    /**
     * reindicizza un array in modo ricorsivo
     * 
     * Questa funzione reindicizza un array in modo ricorsivo, ovvero reindicizza l'array principale e tutti i suoi array figli.
     * 
     * TODO per continuità semantica con le altre funzioni della libreria questa funzione andrebbe rinominata in reindexArrayRecursive()
     * 
     * @param       array       $array      l'array da reindicizzare
     * 
     * @return      array                   l'array reindicizzato
     * 
     */
    function reindex_array_recursive( $array ) {
        if( is_array( $array ) ) {
            if( array_keys( $array ) === range( 0, count( $array ) - 1 ) ) {
                return array_values( array_map( 'reindex_array_recursive', $array ) );
            } else {
                foreach( $array as $value ) {
                    $value = reindex_array_recursive( $value );
                }
                return $array;
            }
        } else {
            return $array;
        }
    }

    /**
     * rimpiazza ricorsivamente un valore in un array
     * 
     * Questa funzione rimpiazza ricorsivamente un valore in un array.
     * 
     * @param       array       $a1     l'array in cui rimpiazzare il valore
     * 
     * @return      array               l'array modificato
     * 
     */
    function arrayReplaceRecursive( &$a1, $a2 ) {

        $a1 = ( is_array( $a1 ) ) ? $a1 : array();
        $a2 = ( is_array( $a2 ) ) ? $a2 : array();

        $a1 = array_replace_recursive( $a1, $a2 );

        return $a1;

    }

    /**
     * FUNZIONI DI RICERCA
     */

    /**
     * restituisce la prima chiave dell'array
     * 
     * Questa funzione restituisce la prima chiave dell'array passato come parametro.
     * 
     * @param       array       $a      l'array di cui restituire la prima chiave
     * 
     * @return      mixed               la prima chiave dell'array
     * 
     */
    if( ! function_exists( 'array_key_first' ) ) {
        function array_key_first( $a ) {
            reset( $a );
            return key( $a );
        }
    }

    /**
     * restituisce l'ultima chiave dell'array
     * 
     * Questa funzione restituisce l'ultima chiave dell'array passato come parametro.
     * 
     * @param       array       $a      l'array di cui restituire l'ultima chiave
     * 
     * @return      mixed               l'ultima chiave dell'array
     * 
     */
    if( ! function_exists( 'array_key_last' ) ) {
        function array_key_last( $a ) {
            $ks = array_keys( $a );
            return $ks[ ( count( $ks ) - 1 ) ];
        }
    }

    /**
     * restituisce i valori di una colonna di un array
     * 
     * Questa funzione restituisce i valori di una colonna di un array, ovvero restituisce un array contenente tutti i
     * valori di una colonna specificata di un array multidimensionale.
     * 
     * @param       array       $a      l'array da cui estrarre i valori
     * 
     * @return      array               l'array contenente i valori della colonna
     * 
     */
    if( ! function_exists( 'array_column' ) ) {
        function array_column( $a, $k ) {
            $r = array();
            if( is_array( $a ) ) {
                foreach( $a as $v ) {
                    $r[] = $v[ $k ];
                }
            }
            return $r;
        }
    }

    /**
     * FUNZIONI DI VERIFICA
     */

    /**
     * verifica se un array è associativo
     * 
     * Questa funzione verifica se un array è associativo, ovvero se contiene almeno una chiave di tipo stringa.
     * 
     * @param       array       $a      l'array da verificare
     * 
     * @return      boolean             true se l'array è associativo, false altrimenti
     * 
     */
    function is_associative_array( array $a ) {
        return count( array_filter( array_keys( $a ), 'is_string' ) ) > 0;
    }

    /**
     * verifica se un array è vuoto
     * 
     * Questa funzione verifica se un array è vuoto, ovvero se contiene almeno un elemento.
     * 
     * @param       array       $a      l'array da verificare
     * 
     * @return      boolean             true se l'array è vuoto, false altrimenti
     * 
     */
    function isEmptyArray( $value ) {
        if( is_array( $value ) ) {
            $empty = TRUE;
            array_walk_recursive( $value, function( $item ) use ( &$empty ) {
                $empty = $empty && empty( $item );
            });
        } else {
            $empty = empty( $value );
        }
        return $empty;
    }

    /**
     * FUNZIONI DI STAMPA
     */

    /**
     * stampa un array in linea
     * 
     * Questa funzione stampa un array in linea, ovvero senza andare a capo e rimuovendo gli spazi doppi.
     * 
     * @param       array       $a      l'array da stampare
     * 
     * @return      string              la stringa ottenuta dalla stampa
     * 
     */
    function print_l( $a ) {
        return riduciCaratteriDoppi( str_replace( "\n", '', print_r( $a, true ) ) );
    }

    /**
     * FUNZIONI SPECIFICHE PER GLISWEB
     */

    /**
     * trasforma una stringa di metadati in un array associativo
     * 
     * Questa funzione trasforma una stringa di metadati in un array associativo. Per comprendere il funzionamento
     * di questa funzione occorre sapere come vengono estratti i metadati dal database; in particolare si tenga
     * presente che il pipe nel nome del metadato indica un livello di annidamento.
     * 
     * @param       array       $r      l'array contenente i metadati
     * @param       array       $a      l'array associativo da popolare
     * 
     * @return      array               l'array associativo ottenuto dalla trasformazione
     * 
     */
    function metadati2associativeArray( $r, &$a = array() ) {

        foreach( $r as $row ) {

            $dettagli = explode( '|', $row['nome'] );

            $lvl =& $a;

            foreach( $dettagli as $chiave ) {

                $lvl = array_replace_recursive(
                    $lvl,
                    array(
                        $chiave => array()
                    )
                );

                $lvl =& $lvl[ $chiave ];

            }

            if( empty( $row['ietf'] ) ) {
                $lvl = $row['testo'];
            } else {
                $lvl[ $row['ietf'] ] = $row['testo'];
            }

        }

        return( $a );

    }

    /**
     * ALIAS DI FUNZIONI INSERITI PER RETROCOMPATIBILITÀ
     */

    // arrayTrim() -> trimArray()
    function arrayTrim( $a ) {
        return trimArray( $a );
    }
