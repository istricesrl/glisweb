<?php

    /**
     * libreria per la gestione dei dati in formato CSV
     * 
     * Questa libreria contiene funzioni utili per la gestione dei dati in formato CSV e aiuta a svolgere le operazioni
     * più comuni come lettura e scrittura dei file CSV, trasformazione dei dati da array o in array, eccetera.
     * 
     * introduzione
     * ============
     * Il formato CSV è uno dei formati più diffusi e comuni per la gestione dei dati tabellari. CSV sta per "Comma Separated
     * Values" e consiste in un file di testo in cui le righe rappresentano le righe di una tabella e i campi sono separati
     * da un carattere di separazione, di solito la virgola. I campi di testo sono delimitati dalle doppie virgolette.
     * 
     * Questa libreria è pensata per semplificare al massimo la gestione dei file CSV (lettura e scrittura) e la trasformazione
     * dei dati presenti in un file CSV in un array associativo e viceversa, ovvero le operazioni che vengono effettuata più
     * di frequente con questo tipo di formato.
     * 
     * la questione del separatore
     * ---------------------------
     * Anche se il nome del formato farebbe pensare che i campi siano sempre separati da virgole, questo in realtà nella pratica
     * non avviene di frequente, per vari motivi. Il separatore può essere di fatto qualsiasi carattere, anche se i più comuni
     * oltre ai classici virgola e punto e virgola tendono ad essere caratteri meno utilizzati comunemente nel testo, come il pipe,
     * il paragrafo, la tabulazione (in questo caso si parla più propriamente di TSV, "Tab Separated Values"), eccetera.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in tre categorie principali, le funzioni di lettura, le funzioni di scrittura e le
     * funzioni di supporto. Per comprendere l'architettura della libreria, si tenga presente che essa manipola i dati sia in lettura
     * che in scrittura in diverse condizioni, che richiedono funzioni specifiche per essere gestite. Si consideri che i dati di
     * partenza per la conversione da CSV ad array associativo possono essere, in ordine di raffinazione:
     * 
     * - un file contenente dati in formato CSV
     * - un'unica stringa contenente tutte le righe in CSV
     * - un array di stringhe, ognuna rappresentante riga CSV
     * 
     * In tutti questi tre casi si assume che la prima riga contenga le intestazioni dei campi, che verranno usate come chiavi dell'array
     * associativo di destinazione; se così non fosse, è necessario passare alle funzioni di lettura un array con le chiavi da utilizzare
     * per la costruzione dell'array.
     * 
     * Viceversa in scrittura si parte sempre da un array (associativo o no), che può essere convertito in CSV in diverse modalità, in ordine
     * di raffinazione:
     * 
     * - un array di stringhe, ognuna rappresentante una riga CSV
     * - una stringa contenente tutte le righe in CSV
     * - un file contenente dati in formato CSV
     * 
     * Le chiavi della prima riga dell'array associativo vengono usate come intestazioni dei campi, e vengono scritte come prima riga; se
     * si desidera utilizzare intestazioni diverse è necessario passare alle funzioni di scrittura un array con le intestazioni da utilizzare.
     * Se si parte invece da un array non associativo, il primo elemento dell'array viene considerato di intestazione, e anche qui se si
     * desidera utilizzare intestazioni diverse è necessario passarle alle funzioni di scrittura.
     * 
     * È anche possibile richiedere alle funzioni di scrittura di non scrivere le intestazioni, in modo da ottenere un file CSV senza
     * intestazioni oppure semplicemente dati che possono essere accodati ad altri già intestati (ad esempio per aggiungere righe a un file)
     * 
     * Per dare uniformità al naming delle funzioni di questa libreria si è scelto di adottare la seguente convenzione:
     * 
     * - ci si riferisce all'array di array associativi semplicemente come "array"
     * - ci si riferisce all'array di array non associativi semplicemente come "matrix"
     * - ci si riferisce al singolo array non associativo come "vector"
     * - ci si riferisce all'array di stringhe CSV come "csvArray"
     * - ci si riferisce alla stringa contenente una riga in CSV come "csvRow"
     * - ci si riferisce alla stringa contenente tutte le righe in CSV come "csvString"
     * - ci si riferisce al file CSV come "csvFile"
     * 
     * È abbastanza intuitivo come le varie forme che possono assumere i dati siano in pratica progressive, dal file CSV all'array associativo
     * infatti abbiamo:
     * 
     * - csvFile -> csvString -> csvArray -> array
     * 
     * mentre invece per la scrittura abbiamo:
     * 
     * - array -> csvArray -> csvString -> csvFile
     * 
     * Ovviamente è possibile abbreviare i percorsi o partire già da dati che si trovano in uno stato più avanzato ma è importante capire la
     * struttura generale in modo da poterla utilizzare nel modo corretto.
     * 
     * funzioni di lettura
     * -------------------
     * Le funzioni di lettura permettono di leggere un file, una stringa o un array di stringhe CSV e di convertirli in un array associativo
     * o non associativo.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * csvFile2array()              | legge un file CSV e restituisce un array di array associativi
     * csvString2array()            | legge una stringa CSV e restituisce un array di array associativi
     * csvArray2array()             | legge un array di stringhe CSV e restituisce un array di array associativi
     * csvFile2matrix()             | legge un file CSV e restituisce un array di array non associativi 
     * csvString2matrix()           | legge una stringa CSV e restituisce un array di array non associativi
     * csvArray2matrix()            | legge un array di stringhe CSV e restituisce un array di array non associativi
     * 
     * funzioni di scrittura
     * ---------------------
     * Le funzioni di scrittura permettono di scrivere un array associativo o non associativo in un array di stringhe CSV, in un'unica
     * stringa CSV o in un file CSV.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * array2csvFile()              | scrive un array di array associativi in un file CSV
     * array2csvString()            | scrive un array di array associativi in una stringa CSV
     * array2csvArray()             | scrive un array di array associativi in un array di stringhe CSV                  
     * matrix2csvFile()             | scrive un array di array non associativi in un file CSV
     * matrix2csvString()           | scrive un array di array non associativi in una stringa CSV
     * matrix2csvArray()            | scrive un array di array non associativi in un array di stringhe CSV
     * 
     * funzioni di supporto
     * --------------------
     * Le funzioni di supporto sono funzioni di utilità che vengono utilizzate dalle altre funzioni della libreria per lavorare.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * guessCsvSeparator()          | individua il separatore di un file CSV
     * csvRow2array()               | converte una riga contenente una stringa CSV in un array associativo
     * csvRow2vector()              | converte una riga contenente una stringa CSV in un array non associativo
     * 
     * alias di funzioni inseriti per retrocompatibilità
     * -------------------------------------------------
     * Per garantire la retrocompatibilità con il codice già esistente, sono stati inseriti degli alias che puntano alle funzioni
     * aggiornate.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * csv2array()                  | alias di csvArray2array()
     * array2csv()                  | alias di array2csvArray()
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * openFile()                       | filesystem.tools
     * clean_string()                   | string.tools
     * readFromFile()                   | filesystem.tools
     * 
     * Inoltre per funzionare correttamente la libreria richiede che siano definite le seguenti costanti globali:
     * 
     * costante                 | valore    | descrizione
     * -------------------------|-----------|---------------------------------------------------------------
     * WRITE_FILE_OVERWRITE     | w+        | indica l'apertura del file in modalità sovrascrittura
     * WRITE_FILE_APPEND        | a+        | indica l'apertura del file in modalità append
     * 
     * 
     */

    // definizione delle costanti della libreria
    if( ! defined( 'FILE_WRITE_OVERWRITE' ) )   { define( 'FILE_WRITE_OVERWRITE'    , 'w+' ); }
    if( ! defined( 'FILE_WRITE_APPEND' ) )      { define( 'FILE_WRITE_APPEND'       , 'a+' ); }

    // funzioni richieste
    if( ! function_exists( 'logger' ) ) {
        die( 'la funzione core logger() non è definita, definirla per utilizzare la libreria' );
    }

    /**
     * FUNZIONI DI LETTURA
     */

    /**
     * legge un file CSV e restituisce un array di array associativi
     * 
     * Questa funzione legge un file CSV e restituisce un array di array associativi; se il separatore fornito è NULL o false,
     * la funzione utilizza indirettamente guessCsvSeparator() per individuarlo autonomamente. La funzione legge il file come array
     * di stringhe CSV e poi utilizza csvArray2array() per convertirlo in un array associativo. La funzione assume che la prima
     * riga del file contenga le intestazioni dei campi, se non viene passato esplicitamente un array di intestazioni; in questo
     * caso la riga viene eliminata dall'array e ne viene fatto il parsing, dopodiché l'array così ottenuto viene passato alla
     * funzione csvArray2array().
     * 
     * @param       string      $f      il file da leggere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array associativi
     * 
     */
    function csvFile2array( $f, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {

        // debug
        error_reporting( E_ALL );
        ini_set( 'display_errors', TRUE );
   
        // log
        logger( 'lettura file CSV: ' . $f, 'csv' );

        // leggo il contenuto del file in un array di righe CSV
        $a = readFromFile( $f );

        // log
        logger( 'dati letti dal file ' . $f . ': ' . print_r( $a, true ), 'details/csv' );

        // se non ho passato le intestazioni, le ricavo dalla prima riga
        if( empty( $h ) ) {
            $j = array_shift( $a );
            $h = csvRow2vector( $j, $s, $c, $e );
            if( empty( $s ) ) {
                $s = guessCsvSeparator( $j );
            }
        }

        // log
        logger( 'intestazione per il file ' . $f . ': ' . print_r( $h, true ), 'details/csv' );

        // leggo le righe tramite la funzione csvArray2array()
        $r = csvArray2array( $a, $s, $h, $c, $e );

        // log
        logger( 'righe lette dal file ' . $f . ': ' . print_r( $r, true ), 'details/csv' );

        // restituisco l'array di array associativi elaborato da csvArray2array()
        return $r;

    }

    /**
     * legge una stringa CSV e restituisce un array di array associativi
     * 
     * Questa funzione riceve in input una stringa contenente una serie di righe in formato CSV e la converte in un array di array associativi;
     * se il separatore fornito è NULL o false, la funzione utilizza guessCsvSeparator() per individuarlo autonomamente. La funzione utilizza
     * la prima riga per ricavare le intestazioni se non viene fornito esplicitamente un array di intestazioni; in questo caso la riga viene
     * eliminata dall'array e ne viene fatto il parsing, dopodiché l'array così ottenuto viene passato alla funzione csvArray2array().
     * 
     * @param       string      $f      la stringa da convertire
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array associativi
     * 
     */
    function csvString2array( $f, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {
    
        // TODO implementare guessNewline()

        // trim della stringa
        $f = trim( $f );

        // esplodo la stringa per newline
        $a = explode( PHP_EOL, $f );

        // se non ho passato le intestazioni, le ricavo dalla prima riga
        if( empty( $h ) ) {
            $j = array_shift( $a );
            $h = csvRow2vector( $j, $s, $c, $e );
            if( empty( $s ) ) {
                $s = guessCsvSeparator( $j );
            }
        }

        // restituisco l'array di array associativi elaborato da csvArray2array()
        return csvArray2array( $a, $s, $h, $c, $e );

    }

    /**
     * legge un array di stringhe CSV e restituisce un array di array associativi
     * 
     * Questa funzione riceve in input un array di stringhe CSV e restituisce un array di array associativi; se il separatore
     * fornito è NULL o false, la funzione utilizza guessCsvSeparator() per individuarlo autonomamente. La funzione utilizza csvString2array()
     * per fare il parsing delle stringhe CSV. Se non è fornito un array di intestazioni, la funzione assume che la prima riga
     * contenga le intestazioni per cui ne fa il parse e la elimina dall'array. L'array delle intestazioni viene fornito a csvString2array()
     * per intestare i campi.
     * 
     * @param       array       $a      l'array di stringhe da convertire
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array associativi
     * 
     */
    function csvArray2array( $a, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {

        // array per il risultato
        $r = array();

        // se non ho passato le intestazioni, le ricavo dalla prima riga
        if( empty( $h ) ) {
            $j = array_shift( $a );
            $h = csvRow2vector( $j, $s, $c, $e );
            if( empty( $s ) ) {
                $s = guessCsvSeparator( $j );
            }
        }

        // faccio il parsing di ogni riga
        foreach( $a as $row ) {
            $r[] = csvRow2array( $row, $h, $s, $c, $e );
        }

        // restituisco il risultato
        return $r;

    }

    /**
     * legge un file CSV e restituisce un array di array non associativi
     * 
     * Questa funzione legge un file CSV e restituisce un array di array non associativi; se il separatore fornito è NULL o false,
     * la funzione utilizza guessCsvSeparator() per individuarlo autonomamente. La funzione legge il file come array di stringhe CSV
     * e poi utilizza csvArray2matrix() per convertirlo in un array non associativo. La funzione non richiede le intestazioni dei
     * campi, ma se vengono fornite vengono ignorate (questa variabile è stata lasciata fra i parametri per possibili utilizzi futuri).
     * 
     * @param       string      $f      il file da leggere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array non associativi
     * 
     */
    function csvFile2matrix( $f, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {

        // leggo il contenuto del file in un array di righe CSV
        $a = readFromFile( $f );

        // scompongo le righe CSV in vettori
        $r = csvArray2matrix( $a, $s, $c, $e );

        // restituisco l'array di array non associativi elaborato da csvArray2matrix()
        return $r;

    }

    /**
     * legge una stringa CSV e restituisce un array di array non associativi
     * 
     * Questa funzione riceve in input una stringa contenente una serie di righe in formato CSV e la converte in un array di array non
     * associativi; se il separatore fornito è NULL o false, la funzione utilizza guessCsvSeparator() per individuarlo autonomamente.
     * La funzione utilizza csvArray2matrix() per fare il parsing delle stringhe CSV.
     * 
     * @param       string      $f      la stringa da convertire
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array non associativi
     * 
     */
    function csvString2matrix( $f, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {

        // debug
        error_reporting( E_ALL );
        ini_set( 'display_errors', TRUE );

        // TODO implementare guessNewline()

        // trim della stringa
        $f = trim( $f );

        // esplodo la stringa per newline
        $a = explode( PHP_EOL, $f );

        // scompongo le righe CSV in vettori
        $r = csvArray2matrix( $a, $s, $c, $e );

        // restituisco l'array di array non associativi elaborato da csvArray2matrix()
        return $r;

    }

    /**
     * legge un array di stringhe CSV e restituisce un array di array non associativi
     * 
     * Questa funzione riceve in input un array di stringhe CSV e restituisce un array di array non associativi; se il separatore
     * fornito è NULL o false, la funzione utilizza guessCsvSeparator() per individuarlo autonomamente. La funzione utilizza csvRow2vector()
     * per fare il parsing delle stringhe CSV.
     * 
     * @param       array       $a      l'array di stringhe da convertire
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di array non associativi
     * 
     */
    function csvArray2matrix( $a, $s = NULL, $h = NULL, $c = "\"", $e = '\\' ) {

        // array per il risultato
        $r = array();

        // faccio il parsing di ogni riga
        foreach( $a as $row ) {
            $r[] = csvRow2vector( $row, $s, $c, $e );
        }

        // restituisco l'array di array non associativi
        return $r;

    }

    /**
     * FUNZIONI DI SCRITTURA
     */

    /**
     * array2csvFile()              | scrive un array di array associativi in un file CSV
     * array2csvString()            | scrive un array di array associativi in una stringa CSV
     * array2csvArray()             | scrive un array di array associativi in un array di stringhe CSV                  
     * matrix2csvFile()             | scrive un array di array non associativi in un file CSV
     * matrix2csvString()           | scrive un array di array non associativi in una stringa CSV
     * matrix2csvArray()            | scrive un array di array non associativi in un array di stringhe CSV
     */

    /**
     * scrive un array di array associativi in un file CSV
     * 
     * Questa funzione riceve in input un array di array associativi e lo scrive su un file CSV; se non vengono fornite intestazioni,
     * la funzione le ricava dalle chiavi del primo array. La funzione utilizza array2csvString() per generare la stringa da scrivere
     * e writeToFile() per scriverla su file.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $f      il file su cui scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * @param       string      $m      la modalità di scrittura
     * 
     * @return      boolean             l'esito dell'operazione
     * 
     */
    function array2csvFile( $d, $f, $s = ',', $h = NULL, $c = '"', $e = '\\', $m = FILE_WRITE_OVERWRITE ) {

        // log
        logger( 'scrittura file CSV: ' . $f, 'csv' );

        // ricavo le intestazioni dalle chiavi della prima riga
        if( empty( $h ) ) {
            $h = array_keys( $d[0] );
        }

        // genero la stringa da scrivere su file tramite array2csvString()
        $t = array2csvString( $d, $s, $h, $c, $e );

        // scrivo la stringa su file utilizzando writeToFile()
        $r = writeToFile( $t, $f, $m );

        // restituisco l'esito dell'operazione
        return $r;

    }

    /**
     * scrive un array di array associativi in una stringa CSV
     * 
     * Questa funzione riceve in input un array di array associativi e lo scrive in una stringa CSV; se non vengono fornite intestazioni,
     * la funzione le ricava dalle chiavi del primo array. La funzione utilizza array2csvArray() per generare l'array di stringhe da scrivere
     * e implode() per concatenarle in una stringa.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      string              la stringa CSV
     * 
     */
    function array2csvString( $d, $s = ',', $h = NULL, $c = '"', $e = '\\' ) {

        // ricavo le intestazioni dalle chiavi della prima riga
        if( empty( $h ) ) {
            $h = array_keys( $d[0] );
        }

        // trasformo gli array di riga in stringhe tramite la array2csvArray()
        $a = array2csvArray( $d, $s, $h, $c, $e );

        // implodo le stringhe per newline
        if( is_array( $a ) ) {
            $r = implode( PHP_EOL, $a );
        }

        // restituisco la stringa
        return $r;

    }

    /**
     * scrive un array di array associativi in un array di stringhe CSV
     * 
     * Questa funzione riceve in input un array di array associativi e lo scrive in un array di stringhe CSV; se non vengono fornite
     * intestazioni, la funzione le ricava dalle chiavi del primo array. La funzione utilizza csvRow2array() per convertire ogni riga
     * in una stringa CSV.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di stringhe CSV
     * 
     */
    function array2csvArray( $d, $s = ',', $h = NULL, $c = '"', $e = '\\' ) {

        // array per il risultato
        $a = array();

        // ricavo le intestazioni dalle chiavi della prima riga
        if( empty( $h ) ) {
            $h = array_keys( $d[0] );
        }

        // aggiungo le intestazioni all'inizio dell'array $d
        array_unshift( $d, $h );

        // apro un buffer in memoria
        $b = fopen('php://memory', 'r+');

        // scrivo tutte le righe nel buffer
        foreach( $d as $r ) {
            fputcsv( $b, $r, $s, $c, $e );
        }

        // leggo il buffer
        rewind( $b );

        // leggo tutte le righe
        while( $buf = fgets( $b ) ) {
            $a[] = trim( $buf );
        }

        // chiudo il buffer
        fclose( $b );

        // restituisco l'array di stringhe
        return $a;

    }

    /**
     * scrive un array di array non associativi in un file CSV
     * 
     * Questa funzione scrive un array di array non associativi in un file CSV; se non vengono fornite intestazioni, la funzione
     * non fa nulla, altrimenti le aggiunge all'inizio dell'array. La funzione utilizza matrix2csvString() per generare la stringa
     * da scrivere e writeToFile() per scriverla su file.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $f      il file su cui scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * @param       string      $m      la modalità di scrittura
     *
     * @return      boolean             l'esito dell'operazione 
     * 
     */
    function matrix2csvFile( $d, $f, $s = ',', $h = NULL, $c = '"', $e = '\\', $m = FILE_WRITE_OVERWRITE ) {

        // log
        logger( 'scrittura file CSV: ' . $f, 'csv' );

        // se ho un array di intestazioni lo aggiungo all'inizio del file
        if( ! empty( $h ) ) {
            array_unshift( $d, $h );
        }

        // genero la stringa da scrivere su file tramite matrix2csvString()
        $t = matrix2csvString( $d, $s, NULL, $c, $e );

        // scrivo la stringa su file utilizzando writeToFile()
        $r = writeToFile( $t, $f, $m );

        // restituisco l'esito dell'operazione
        return $r;

    }

    /**
     * scrive un array di array non associativi in una stringa CSV
     * 
     * Questa funzione riceve in input un array di array non associativi e lo scrive in una stringa CSV; se non vengono fornite
     * intestazioni, la funzione non fa nulla, altrimenti le aggiunge all'inizio dell'array. La funzione utilizza matrix2csvArray()
     * per generare l'array di stringhe da scrivere e implode() per concatenarle in una stringa.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      string              la stringa CSV
     * 
     */
    function matrix2csvString( $d, $s = ',', $h = NULL, $c = '"', $e = '\\' ) {

        // se ho un array di intestazioni lo aggiungo all'inizio del file
        if( ! empty( $h ) ) {
            array_unshift( $d, $h );
        }

        // trasformo gli array di riga in stringhe tramite la matrix2csvArray()
        $a = matrix2csvArray( $d, $s, NULL, $c, $e );

        // implodo le stringhe per newline
        if( is_array( $a ) ) {
            $r = implode( PHP_EOL, $a );
        }

        // restituisco la stringa
        return $r;

    }

    /**
     * scrive un array di array non associativi in un array di stringhe CSV
     * 
     * Questa funzione riceve in input un array di array non associativi e lo scrive in un array di stringhe CSV; se non vengono fornite
     * intestazioni, la funzione non fa nulla, altrimenti le aggiunge all'inizio dell'array. La funzione utilizza csvRow2vector()
     * per convertire ogni riga in una stringa CSV.
     * 
     * @param       array       $d      l'array da scrivere
     * @param       string      $s      il separatore da utilizzare
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi di testo
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array di stringhe CSV
     * 
     */
    function matrix2csvArray( $d, $s = ',', $h = NULL, $c = '"', $e = '\\' ) {

        // array per il risultato
        $a = array();

        // se ho un array di intestazioni lo aggiungo all'inizio del file
        if( ! empty( $h ) ) {
            array_unshift( $d, $h );
        }
        // apro un buffer in memoria
        $b = fopen('php://memory', 'r+');

        // scrivo tutte le righe nel buffer
        foreach( $d as $r ) {
            fputcsv( $b, $r, $s, $c, $e );
        }

        // leggo il buffer
        rewind( $b );

        // leggo tutte le righe
        while( $buf = fgets( $b ) ) {
            $a[] = trim( $buf );
        }

        // chiudo il buffer
        fclose( $b );

        // restituisco l'array di stringhe
        return $a;

    }

    /**
     * FUNZIONI DI SUPPORTO
     */

    /**
     * individua il separatore di una stringa CSV
     * 
     * Questa funzione riceve in input una stringa e trova il carattere più abbondante fra quelli indicati, e lo
     * restituisce come output.
     * 
     * @param       string      $t      la stringa da analizzare
     * @param       array       $s      un array di caratteri da cercare
     * 
     * @return      string              il carattere più abbondante
     * 
     */
    function guessCsvSeparator( $t, $s = array( ',', ';', '|', "\t" ) ) {

        $r = NULL;
        $m = 0;

        foreach( $s as $x ) {
            $c = substr_count( $t, $x );
            if( $c > $m ) {
                $m = $c;
                $r = $x;
            }
        }

        return $r;

    }

    /**
     * converte una riga contenente una stringa CSV in un array associativo
     * 
     * Questa funzione riceve in input una stringa contenente una riga in formato CSV e la converte in un array associativo,
     * utilizzando le intestazioni date; in caso di discrepanza fra il numero di intestazioni e il numero di campi, la funzione
     * restituisce comunque i campi che è stata in grado di associare, utilizzando guessN (con N progressivo) per le testate
     * mancanti, ma logga un errore. Questa funzione si appoggia a csvRow2matrix() per fare il parsing della stringa CSV.
     * 
     * @param       string      $t      la stringa da convertire
     * @param       array       $h      le intestazioni da utilizzare
     * @param       string      $s      il separatore da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array associativo
     * 
     */
    function csvRow2array( $t, $h, $s = NULL, $c = "\"", $e = '\\' ) {

        if( empty( $s ) ) {
            $s = guessCsvSeparator( $t );
        }

        $t = csvRow2vector( $t, $s, $c, $e );

        // se le intestazioni sono meno dei campi, aggiungo le intestazioni mancanti come guessN...guessN+x
        if( count( $h ) < count( $t ) ) {
            $h = array_merge( $h, array_map( function( $x ) { return 'guess' . $x; }, range( 1, count( $t ) - count( $h ) ) ) );
            logger( 'intestazioni mancanti: ' . print_r( $h, true ) . ' per i dati: ' . print_r( $t, true ), 'csv', LOG_ERR );
        } elseif( count( $h ) > count( $t ) ) {
            $h = array_slice( $h, 0, count( $t ) );
            logger( 'intestazioni in eccesso: ' . print_r( $h, true ) . ' per i dati: ' . print_r( $t, true ), 'csv', LOG_ERR );
        }

        $t = array_combine( $h, $t );

        return $t;

    }

    /**
     * converte una riga contenente una stringa CSV in un array non associativo
     * 
     * Questa funzione riceve in input una stringa contenente una riga in formato CSV e la converte in un array non associativo; se
     * il separatore fornito è NULL o false, la funzione utilizza guessCsvSeparator() per individuarlo autonomamente.
     * 
     * @param       string      $t      la stringa da convertire
     * @param       string      $s      il separatore da utilizzare
     * @param       string      $c      il carattere di delimitazione dei campi
     * @param       string      $e      il carattere di escape
     * 
     * @return      array               l'array non associativo
     * 
     */
    function csvRow2vector( $t, $s = NULL, $c = "\"", $e = '\\' ) {

        if( $s == NULL ) {
            $s = guessCsvSeparator( $t );
        }

        $t = clean_string( $t );
        $t = str_getcsv( $t, $s, $c, $e );
        $t = array_map( 'trim', $t );

        return $t;

    }

    /**
     * ALIAS DI FUNZIONI INSERITI PER RETROCOMPATIBILITÀ
     */

    // csv2array() -> csvArray2array()
    function csv2array( $data, $s = ",", $c = "\"", $e = '\\' ) {
        return csvArray2array( $data, $s, NULL, $c, $e );
    }

    // array2csv() -> array2csvArray()
    function array2csv( $data, $s = ",", $c = "\"", $e = '\\' ) {
        return array2csvArray( $data, $s, NULL, $c, $e );
    }
