<?php

    /**
     * libreria per la gestione dei file e del filesystem
     *
     * Questa libreria contiene funzioni utili per le operazioni di I/O su file, per la gestione dei file e delle cartelle, e in
     * generale per la gestione del filesystem. Le funzioni sono state scritte in modo da essere compatibili il più possibile
     * con tutti i sistemi operativi.
     *
     * introduzione
     * ============
     * Questa libreria aiuta nella gestione delle operazioni sui file e sul filesystem e le funzioni sono state scritte in modo
     * tale da essere altamente riusabili. Dal momento che lavorando nel web una delle principali problematiche da risolvere è
     * la corretta contestualizzazione dei percorsi, la libreria inizia con un gruppo di funzioni che consentono proprio di
     * normalizzare i percorsi sia trasformando i percorsi relativi in percorsi assoluti che viceversa.
     * 
     * Successivamente le funzioni sono raggruppate in base al tipo di lavoro che svolgono; si noti che diverse funzioni sono in
     * grado di agire anche su file remoti e sono anche in grado di capire autonomamente se devono farlo.
     * 
     * modalità di apertura dei file
     * -----------------------------
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
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per la trasformazione dei percorsi
     * -------------------------------------------
     * Lavorando con file e cartelle in PHP è necessario fare riferimento alla loro posizione assoluta nel filesystem, tuttavia spesso i percorsi
     * vengono forniti relativi dall'interfaccia utente, o salvati relativi nel database. Gestire percorsi relativi è importante per
     * rendere più facile il deploy del sito in un ambiente diverso da quello di sviluppo, e pertanto il framework fornisce una serie di funzioni
     * adatte a trasformare i percorsi da relativi ad assoluti e viceversa.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * fullPath()               | trasforma in percorso assoluto un percorso relativo
     * getFullPath()            | restituisce un percorso assoluto senza modificare la variabile di partenza
     * shortPath()              | trasforma un percorso assoluto in un percorso relativo
     * getShortPath()           | restituisce un percorso relativo senza modificare la variabile di partenza
     * absolutePath()           | elimina i punti e le doppie barre da un percorso
     * 
     * funzioni per la lettura e la scrittura dei file
     * -----------------------------------------------
     * La lettura e la scrittura di file e cartelle sono funzionalità base necessarie a una quantità di compiti. Il framework fornisce alcune funzioni
     * che semplificano le operazioni più frequenti e mascherano la necessità di convertire i percorsi da relativi ad assoluti e viceversa.
     * 
     * funzione                     | descrizione
     * -----------------------------|---------------------------------------------------------------
     * openFile()                   | apre un handler a un file
     * closeFile()                  | chiude un puntatore a un file
     * writeToFile()                | scrive una stringa su un file
     * overwriteToFile()            | sovrascrive una stringa su un file
     * appendToFile()               | aggiunge una stringa a un file
     * readFromFile()               | legge il contenuto di un file in una stringa o in un array di stringhe
     * readStringFromFile()         | legge una stringa da un file
     * readArrayFromFile()          | legge un array di stringhe da un file
     * writeArrayToFile()           | legge un array di stringhe da un file
     * readKeyValueArrayFromFile()  | legge un array associativo da un file ini
     * writeKeyValueArrayToFile()   | scrive un array associativo su un file ini
     * 
     * funzioni per le operazioni sul contenuto dei file
     * -------------------------------------------------
     * Alcune operazioni frequenti sul contenuto dei file richiedono diversi passaggi e possono complicare il codice, per cui sono state trasformate in funzioni.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * fileTrimLines()          | rimuove n linee da un file
     * 
     * funzioni per le operazioni sul filesystem
     * -----------------------------------------
     * Questo gruppo di funzioni è focalizzato sulla gestione del filesystem vero e proprio, inteso soprattutto come albero di cartelle contenenti file.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * getFolderIterator()      | questa funzione restituisce un oggetto di tipo RecursiveIteratorIterator relativamente a una cartella
     * checkFolder()            | verifica l'esistenza di un path di directory creando quelle mancanti
     * checkFile()              | verifica l'esistenza e la scrivibilità di un file, creando sia il percorso che il file se necessario
     * deleteFolder()           | elimina una directory
     * deleteFile()             | elimina un file
     * recursiveDelete()        | questa funzione cancella un intero albero di cartelle compresa la cartella di partenza
     * emptyFolder()            | svuota una cartella senza cancellarla
     * moveFile()               | sposa un file
     * copyFile()               | copia un file
     * 
     * funzioni per la lettura delle informazioni da file e cartelle
     * -------------------------------------------------------------
     * Leggere le informazioni sulla struttura delle cartelle e sul loro contenuto può risultare anche parecchio complesso; questo insieme di funzioni semplifica
     * grandemente questo compito, presentando le informazioni in forma sintetica e facile da utilizzare.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * dirTreeToarray()                 | questa funzione trasforma un albero di cartelle in un array
     * getFileSize()                    | restituisce la dimensione in byte di un file
     * getFolderSize()                  | calcola ricorsivamente lo spazio occupato da una directory
     * getSize()                        | restituisce la dimensione di un file o di una cartella
     * getRecursiveFileList()           | restituisce una lista di file ricorsiva
     * getFilteredFileList()            | restituisce una lista di file filtrata
     * getFileList()                    | restituisce una lista di file
     * getRecursiveFolderList()         | restituisce una lista di cartelle ricorsiva
     * getFilteredFolderList()          | restituisce una lista di cartelle filtrata
     * getFolderList()                  | restituisce una lista di cartelle
     * getRecursiveFullList()           | restituisce una lista di file e cartelle ricorsiva
     * getFullList()                    | restituisce una lista di file e cartelle
     * getFolderName()                  | restituisce la parte delle directory di un percorso
     * getFileExtension()               | restituisce l'estensione di un file
     * getFileNameWithoutExtension()    | restituisce il nome di un file senza estensione
     * globRecursive()                  | restituisce un elenco ricorsivo filtrato di file
     * findFileType()                   | restituisce il mime type di un file
     * isBinaryFile()                   | restituisce true se il file è binario
     * fileExists()                     | verifica se un file esiste
     * getFileModifiedTime()            | restituisce la timestamp di modifica di un file
     * 
     * funzioni per le verifiche speciali sui file
     * -------------------------------------------
     * In questo gruppo si trovano funzioni che svolgono particolari operazioni di controllo e verifica sui file. Sono molto utili per rendere il codice più
     * snello e leggibile.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * checkFileConsistency()           | verifica se un file esiste ed è stato aggiornato entro un certo intervallo di tempo
     * 
     * alias di funzioni inseriti per retrocompatibilità
     * -------------------------------------------------
     * Nel corso del tempo sono state effettuate diverse operazioni di refactoring che hanno portato alla modifica di nomi di funzioni utilizzate in passato;
     * per garantire la retrocompatibilità con le versioni precedenti del framework sono state create delle funzioni wrapper che richiamano le nuove funzioni.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * deleteDir()                      | alias di deleteFolder()
     * fileModifiedTime()               | alias di getFileModifiedTime()
     * findFileExtension()              | alias di getFileExtension()
     * getDirIterator()                 | alias di getFolderIterator()
     * emptyDir()                       | alias di emptyFolder()
     * getDirSize()                     | alias di getFolderSize()
     * getRecursiveDirList()            | alias di getRecursiveFolderList()
     * getFilteredDirList()             | alias di getFilteredFolderList()
     * getDirList()                     | alias di getFolderList()
     * getDirName()                     | alias di getFolderName()
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
     * Inoltre, per funzionare correttamente, la libreria richiede che siano valorizzate le
     * seguenti costanti globali.
     *
     * costante                  | spiegazione
     * --------------------------|--------------------------------------------------------------
     * DIR_BASE                  | il percorso base dove lavorare (ad es. /var/www/)
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-02-05       | Fabio Mosti          | refactoring completo della libreria
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    // definizione delle costanti della libreria
    if( ! defined( 'FILE_READ_AS_ARRAY' ) )     { define( 'FILE_READ_AS_ARRAY'      , 'READ_ARRAY' ); }
    if( ! defined( 'FILE_READ_AS_STRING' ) )    { define( 'FILE_READ_AS_STRING'     , 'READ_STRING' ); }
    if( ! defined( 'FILE_WRITE_OVERWRITE' ) )   { define( 'FILE_WRITE_OVERWRITE'    , 'w+' ); }
    if( ! defined( 'FILE_WRITE_APPEND' ) )      { define( 'FILE_WRITE_APPEND'       , 'a+' ); }
    if( ! defined( 'TRIM_LINES_FROM_TOP' ) )    { define( 'TRIM_LINES_FROM_TOP'     , 1 ); }
    if( ! defined( 'TRIM_LINES_FROM_BOTTOM' ) ) { define( 'TRIM_LINES_FROM_BOTTOM'  , -1 ); }

    // funzioni richieste
    if( ! function_exists( 'logger' ) ) {
        die( 'la funzione core logger() non è definita, definirla per utilizzare la libreria' );
    }

    // costanti richieste
    if( ! defined( 'DIR_BASE' ) ) {
        die( 'la costante core DIR_BASE non è definita, definirla per utilizzare la libreria' );
    }

    /**
     * FUNZIONI PER LA TRASFORMAZIONE DEI PERCORSI
     */

    /**
     * trasforma in percorso assoluto un percorso relativo
     * 
     * Spesso abbiamo a disposizione un percorso relativo per un file o una cartella (ad esempio src/config.json) e ci serve
     * il percorso assoluto per manupolare l'oggetto in questione; per percorso assoluto si intende il percorso del file
     * comprensivo della document root (ad esempio /var/www/src/config.json)
     * 
     * @param   string      &$f     contiene il percorso da elaborare
     * 
     * @return  string              il percorso assoluto ricavato unendo DIR_BASE e $f
     *
     */
    function fullPath( &$f ) {

        // se DIR_BASE non è contenuto in $f, lo aggiungo
        if( strpos( $f, DIR_BASE ) === false ) {
            $f = DIR_BASE . $f;
        }

        // valore di ritorno
        return $f;

    }

    /**
     * questa funzione restituisce un percorso assoluto senza modificare la variabile di partenza
     * 
     * Può capitare che si abbia la necessità di ricevere il percorso assoluto come valore di ritorno senza
     * modificare la variabile di partenza. In questo caso è possibile utilizzare la funzione getFullPath()
     * che lavorando su una copia della variabile di partenza restituisce il percorso assoluto senza modificarla.
     * 
     * @param   string      $f      contiene il percorso da elaborare
     * 
     * @return  string              il percorso assoluto ricavato unendo DIR_BASE e $f
     *
     */
    function getFullPath( $f ) {

        // copia della variabile
        $f1 = $f;

        // valore di ritorno
        return fullPath( $f1 );

    }

    /**
     * trasforma un percorso assoluto in un percorso relativo
     * 
     * A volte abbiamo la necessità di ricavare il percorso relativo (ad esempio src/config.json) da un percorso assoluto
     * (ad esempio /var/www/src/config.json) inteso come percorso relativo rispetto alla document root.
     * 
     * @param   string      &$f     contiene il percorso da elaborare
     * 
     * @return  string              il percorso relativo ricavato sottraendo DIR_BASE da $f
     *
     */
    function shortPath( &$f ) {

        // se DIR_BASE è contenuto in $f, lo elimino, poi rimuovo lo slash iniziale
        $f = ltrim( str_replace( DIR_BASE, '', $f ), '/' );

        // valore di ritorno
        return $f;

    }

    /**
     * questa funzione restituisce un percorso relativo senza modificare la variabile di partenza
     * 
     * Può capitare che si abbia la necessità di ricevere il percorso relativo come valore di ritorno senza
     * modificare la variabile di partenza. In questo caso è possibile utilizzare la funzione getFullPath()
     * che lavorando su una copia della variabile di partenza restituisce il percorso relativo senza modificarla.
     *
     * @param   string      $f      contiene il percorso da elaborare
     * 
     * @return  string              il percorso relativo ricavato sottraendo DIR_BASE da $f
     *
     */
    function getShortPath( $f ) {

        // copia della variabile
        $f1 = $f;

        // valore di ritorno
        return shortPath( $f1 );

    }

    /**
     * elimina i punti e le doppie barre da un percorso
     * 
     * Questa funzione elimina i punti e le doppie barre da un percorso, rendendolo più leggibile e pulito, oltre
     * a evitare che un eventuale attacker possa sfruttare un percorso non correttamente formattato.
     * 
     * @param       string      $p      il percorso da pulire
     * 
     * @return      string              il percorso pulito
     *
     */
    function absolutePath( $p ) {

        // elimino punti e barre dal percorso e restituisco il risultato
        return array_reduce( explode( '/', $p ), function( $a, $b ) {

            if( $a === 0 ) {
                $a = "/";
            }

            if( $b === '' || $b === '.' ) {
                return $a;
            }

            if( $b === '..' ) {
                return dirname( $a );
            }

            return preg_replace( "/\/+/", '/', $a . '/' . $b );

        }, 0 );

    }

    /**
     * FUNZIONI PER LA LETTURA E LA SCRITTURA DEI FILE
     */

    /**
     * apre un handler a un file
     *
     * La funzione apre un file e restituisce il relativo handler. Prima di aprire il file, verifica
     * il percorso tramite checkFolder().
     *
     * @param   string      $f        il nome del file da aprire
     * @param   string      $m        la modalita' con cui si desidera aprire il file
     *
     * @return  resource            il puntatore al file
     *
     */
    function openFile( $f, $m = FILE_WRITE_APPEND ) {

        // creo il percorso se non esiste
        checkFolder( dirname( $f ) );

        // valore di ritorno
        return fopen( getFullPath( $f ), $m );

    }

    /**
     * chiude un puntatore a un file
     * 
     * Chiudere le risorse inutilizzate è una buona pratica per evitare di appesantire l'esecuzione dello script.
     * Le funzioni di questa libreria che aprono un file solitamente utilizzano questa funzione per chiudere il file.
     *
     * @param   resource    $h      il puntatore al file da chiudere
     * 
     * @return  boolean             restituisce true se la chiusura è andata a buon fine
     *
     */
    function closeFile( $h ) {

        // valore di ritorno
        return fclose( $h );

    }

    /**
     * scrive una stringa su un file
     *
     * Questa funzione scrive una stringa su un file; di default il contenuto originario viene sovrascritto
     * ma questo comportamento può essere modificato specificando il parametro $m.
     *
     * @param   string      $t      la stringa da scrivere
     * @param   string      $f      il nome del file su cui scrivere comprensivo di percorso
     * @param   string      $m      la modalita' con cui si desidera aprire il file
     *
     * @return  boolean             restituisce true se la scrittura è andata a buon fine, false altrimenti
     * 
     */
    function writeToFile( $t, $f, $m = FILE_WRITE_OVERWRITE ) {

        // apro il file
        $h = openFile( $f, $m );

        // se l'apertura è andata a buon fine
        if( $h ) {

            // se la scrittura è andata a buon fine
            if( fwrite( $h, $t ) ) {

                // chiudo il file
                return closeFile( $h );

            }

        }

        // log
        logger( 'impossibile scrivere ' . $f, 'filesystem' );

        // restituisco false di default
        return false;

    }

    /**
     * sovrascrive una stringa su un file
     * 
     * Questa funzione apre un file in modalità sovrascrittura e ci scrive sopra la stringa data.
     * 
     * @param   string      $t      la stringa da scrivere
     * @param   string      $f      il nome del file su cui scrivere comprensivo di percorso
     * 
     * @return  boolean             restituisce true se la scrittura è andata a buon fine, false altrimenti
     *
     */
    function overwriteToFile( $t, $f ) {

        // sovrascrivo il file e restituisco il risultato
        return writeToFile( $t, $f, FILE_WRITE_OVERWRITE );

    }

    /**
     * aggiunge una stringa a un file
     *
     * La funzione apre il file, inserisce la stringa di testo alla fine di esso e poi lo rihciude.
     *
     * @param   string      $t      la stringa da scrivere
     * @param   string      $f      il nome del file su cui scrivere comprensivo di percorso
     * 
     * @return  boolean             restituisce true se la scrittura è andata a buon fine, false altrimenti
     * 
     */
    function appendToFile( $t, $f ) {

        // aggiungo al file e restituisco il risultato
        return writeToFile( $t, $f, FILE_WRITE_APPEND );

    }

    /**
     * legge il contenuto di un file in una stringa o in un array di stringhe
     *
     * @param string        $f    il nome del file dal quale leggere comprensivo di percorso
     * @param string        $m    la modalita' con cui si desidera aprire il file
     *
     * TODO documentare
     *
     */
    function readFromFile( $f, $m = FILE_READ_AS_ARRAY ) {

        // debug
        // var_dump( $f );

        // prelevo il percorso completo
        $f = getFullPath( $f );

        // se il file esiste e si può leggere
        if( file_exists( $f ) && is_readable( $f ) ) {
            if( $m == FILE_READ_AS_ARRAY ) {
                return array_map( 'trim', file( $f ) );
            } elseif( $m == FILE_READ_AS_STRING ){
                return file_get_contents( $f );
            }
        }

        // restituisco false di default
        return false;

    }

    /**
     * legge una stringa da un file
     * 
     * Questa funzione utilizza la funzione readFromFile() per leggere il contenuto di un file e restituirlo come stringa.
     * 
     * @param       string      $f      il nome del file dal quale leggere comprensivo di percorso
     * @param       boolean     $trim   se true, la stringa letta viene trimmata
     * 
     * @return      string              la stringa letta
     * 
     * 
     * TODO documentare
     *
     */
    function readStringFromFile( $f, $trim = false ) {

        // leggo dal file
        $t = readFromFile( $f, FILE_READ_AS_STRING );

        // faccio il trim se richiesto
        if( $trim === true ) { $t = trim( $t ); }

        // restituisco il risultato
        return $t;

    }

    /**
     * legge un array di stringhe da un file
     * 
     * Questa funzione utilizza la funzione readFromFile() per leggere il contenuto di un file e restituirlo come array.
     * 
     * @param       string      $f      il nome del file dal quale leggere comprensivo di percorso
     * 
     * @return      array               l'array di stringhe letto
     *
     */
    function readArrayFromFile( $f ) {

        // leggo dal file e restituisco il risultato
        return readFromFile( $f, FILE_READ_AS_ARRAY );

    }

    /**
     * scrive un array di stringhe su un file
     * 
     * Questa funzione utilizza la funzione writeToFile() per scrivere un array di stringhe su un file.
     * 
     * @param       string      $f      il nome del file su cui scrivere comprensivo di percorso
     * @param       array       $a      l'array di stringhe da scrivere
     * 
     * @return      boolean             restituisce true se la scrittura è andata a buon fine, false altrimenti
     *
     */
    function writeArrayToFile( $a, $f ) {

        // scrivo sul file e restituisco il risultato
        return writeToFile( trim( implode( PHP_EOL, str_replace( PHP_EOL, '', $a ) ) ), $f );

    }

    /**
     * legge un array associativo da un file ini
     * 
     * Questa funzione legge un file in stile ini e restituisce un array associativo.
     * 
     * @param       string      $f      il nome del file dal quale leggere comprensivo di percorso
     * 
     * @return      array               l'array associativo letto
     *
     */
    function readKeyValueArrayFromFile( $f ) {

        // leggo dal file
        $a = readArrayFromFile( $f );

        // inizializzo l'array
        $j = array();

        // aggiungo all'array
        foreach( $a as $r ) {
            $s = explode( '=', $r );
            if( count( $s ) == 2 ) {
                $j[ $s[0] ] = trim( $s[1], " \n\r\t\v\0\"");
            }
        }

        // restituisco l'array
        return $j;

    }

    /**
     * scrive un array associativo su un file ini
     * 
     * Questa funzione scrive un array associativo su un file in stile ini.
     * 
     * @param       string      $f      il nome del file su cui scrivere comprensivo di percorso
     * @param       array       $a      l'array associativo da scrivere 
     * 
     * @return      boolean             restituisce true se la scrittura è andata a buon fine, false altrimenti
     *
     */
    function writeKeyValueArrayToFile( $a, $f ) {

        // inizializzo la stringa
        $t = '';

        // aggiungo alla stringa
        foreach( $a as $k => $v ) {
            $t .= $k . '="' . trim( $v, " \n\r\t\v\0\"") . '"' . PHP_EOL;
        }

        // scrivo sul file e restituisco il risultato
        return writeToFile( $t, $f );

    }

    /**
     * FUNZIONI PER LE OPERAZIONI SUL CONTENUTO DEI FILE
     */

    /**
     * rimuove n linee da un file
     * 
     * @param       string      $f      il nome del file da cui rimuovere le linee
     * @param       int         $n      il numero di linee da rimuovere
     * @param       int         $l      1 per rimuovere le righe dall'inizio del file, -1 per rimuovere le righe dalla fine del file
     * 
     * @return      boolean             restituisce true se la rimozione è andata a buon fine, false altrimenti
     * 
     * TODO implementare due costanti per dire alla funzione se togliere le righe dall'inizio o dalla fine e aggiungere il parametro alla funzione
     * 
     */
    function fileTrimLines( $f, $n, $l = TRIM_LINES_FROM_TOP ) {

        // leggo dal file
        $a = readArrayFromFile( $f );

        // rimuovo le linee
        $a = array_slice( $a, $n * $l );

        // scrivo sul file e restituisco il risultato
        return writeArrayToFile( $a, $f );
    
    }

    /**
     * FUNZIONI PER LE OPERAZIONI SUL FILESYSTEM
     */

    /**
     * questa funzione restituisce un oggetto di tipo RecursiveIteratorIterator relativamente a una cartella
     * 
     * Un oggetto di tipo RecursiveIteratorIterator consente l'attraversamento ricorsivo di un intero albero
     * di cartelle (vedi https://www.php.net/manual/en/class.recursiveiteratoriterator.php).
     * 
     * @param       string                          $d          il percorso per cui ottenere l'iteratore
     * 
     * @return      RecursiveIteratorIterator                   l'iteratore
     *
     */
    function getFolderIterator( $d ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // se il percorso è una cartella
        if( is_dir( $d ) ) {
            return new RecursiveIteratorIterator(
                new RecursiveDirectoryIterator( $d, FilesystemIterator::SKIP_DOTS ),
                RecursiveIteratorIterator::CHILD_FIRST
            );
        }

        // restituisco false di default
        return false;

    }

    /**
     * verifica l'esistenza di un path di directory creando quelle mancanti
     * 
     * Questa funzione è una vecchia implementazione, che potrebbe ora essere sostituita da mkdir() con il flag di
     * ricorsione attivo (https://www.php.net/manual/en/function.mkdir.php). Attualmente è molto utilizzata e non
     * c'è motivo di sostituirla ma la cosa va considerata in futuro.
     *
     * @param   string      $p        il percorso da verificare
     * @param   string      $r        i permessi da usare per la creazione delle cartelle del percorso
     * 
     * @return  boolean             restituisce true se la creazione è andata a buon fine
     * 
     */
    function checkFolder( $p, $r = 0775 ) {

        // prelevo il percorso completo
        $p = getFullPath( $p );

        // creo il percorso e restituisco il risultato
        return ( is_dir( $p ) ) ? true : mkdir( $p, $r, true );

    }

    /**
     * verifica l'esistenza e la scrivibilità di un file, creando sia il percorso che il file se necessario
     * 
     * Questa funzione controlla che il file passato come parametro e il suo percorso esistano e siano scrivibili;
     * se necessario, il percorso viene creato con la funzione checkFolder() e il file creato con openFile(). Per come è
     * implementata ora, questa funzione è sostanzialmente un doppione della openFile() che però restituisce un
     * booleano anziché una risorsa.
     * 
     * @param   string      $f      il percorso del file da creare
     * 
     * @return  boolean             restituisce true se il file esiste ed è scrivibile
     *
     */
    function checkFile( $f ) {

        // controllo il percorso e l'esistenza del file
        if( checkFolder( dirname( $f ) ) ) {
            return closeFile( openFile( $f ) );
        }

        // valore di ritorno di default
        return false;

    }

    /**
     * elimina una directory
     * 
     * Questa funzione elimina una directory se esiste.
     * 
     * @param   string      $f      il percorso della directory da eliminare
     * 
     * @return  boolean             restituisce true se la cartella non esiste o è stata eliminata, false altrimenti
     *
     */
    function deleteFolder( $f ) {

        // prelevo il percorso completo
        $f = getFullPath( $f );

        // se la cartella esiste
        if( file_exists( $f ) ) {
            if( is_writeable( $f ) ) {
                return rmdir( $f );
            } else {
                return false;
            }
        }

        // restituisco true se la cartella non esiste
        return true;

    }

    /**
     * elimina un file
     * 
     * Questa funzione elimina un file se esiste.
     *
     * @param   string      $f      il percorso del file da eliminare
     * 
     * @return  boolean             restituisce true se il file non esiste o è stato cancellato, false altrimenti
     *
     */
    function deleteFile( $f ) {

        // prelevo il percorso completo
        $f = getFullPath( $f );

        // se il file esiste
        if( file_exists( $f ) ) {
            if( is_writeable( $f ) ) {
                return @unlink( $f );
            } else {
                return false;
            }
        }

        // restituisco true se il file non esiste
        return true;

    }

    /**
     * questa funzione cancella un intero albero di cartelle
     * 
     * Per cancellare una cartella che non è vuota, è necessario svuotarla prima e quindi utilizziamo
     * un oggetto di tipo RecursiveIteratorIterator in modo da eliminare ricorsivamente tutto il
     * contenuto prima di procedere alla cancellazione.
     * 
     * @param       string          $d          il percorso da cancellare
     * @param       boolean         $p          se true (default) elimina anche la cartella $d altrimenti la svuota soltanto
     * 
     * @return      boolean                     true se è andato tutto bene, false altrimenti
     * 
     * TODO implementare i controlli (vedi deleteFolder)
     *
     */
    function recursiveDelete( $d, $p = true ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // prelevo l'iteratore per la cartella
        foreach( getFolderIterator( $d ) as $f ) {

            // elimino il contenuto
            if( $f->isFile() ) {
                $e = deleteFile( $f->getRealPath() );
            } elseif( $f->isDir() ) {
                $e = deleteFolder( $f->getRealPath() );
            }

            // se la cancellazione di un qualsiasi nodo fallisce restituisco false
            if( $e !== true ) {
                return false;
            }

        }

        // elimino la cartella se richiesto
        if( $p === true ) {
            return deleteFolder( $d );
        } else {
            return true;
        }

        // restituisco false di default
        return false;

    }

    /**
     * svuota una cartella
     * 
     * Questa funzione svuota una cartella eliminando tutto il suo contenuto.
     * 
     * @param       string      $d      il percorso della cartella da svuotare
     * 
     * TODO non è un doppione di recursiveDelete()?
     * TODO documentare
     *
     */
    function emptyFolder( $d, $p = false ) {

        return recursiveDelete( $d, $p );

    }

    /**
     * sposta un file
     * 
     * Questa funzione sposta un file da una posizione all'altra.
     * 
     * @param       string      $f1     il percorso del file da spostare
     * @param       string      $f2     il percorso di destinazione del file
     * 
     * @return      boolean             restituisce true se il file è stato spostato, false altrimenti
     *
     */
    function moveFile( $f1, $f2 ) {

        // prelevo i percorsi completi
        $f1 = getFullPath( $f1 );
        $f2 = getFullPath( $f2 );

        // verifico che la cartella di destinazione esista
        checkFolder( dirname( $f1 ) );

        // preparo lo spostamento
        if( substr( $f2, -1 ) == '/' ) {
            checkFolder( $f2 );
            $f2 .= basename( $f1 );
        } else {
            checkFolder( dirname( $f2 ) );
        }

        // sposto il file e restituisco il risultato
        return rename( $f1, $f2 );

    }

    /**
     * copia un file
     * 
     * Questa funzione copia un file da una posizione all'altra. Se il file di provenienza è remoto,
     * utilizza cURL per scaricarlo.
     * 
     * @param       string      $f1     il percorso del file da copiare
     * @param       string      $f2     il percorso di destinazione del file
     * 
     * @return      boolean             restituisce true se il file è stato copiato, false altrimenti
     * 
     * TODO per la copia da remoto utilizzare la funzione betterUrlEncode() sulla stringa prima di passarla
     *
     */
    function copyFile( $f1, $f2 ) {

        // prelevo il percorso completo
        $f2 = getFullPath( $f2 );

        // preparo la copia
        if( substr( $f2, -1 ) == '/') {
            checkFolder( $f2 );
            $f2 .= basename( $f1 );
        } else {
            checkFolder( dirname( $f2 ) );
        }

        // copio $f1 in $f2
        if( filter_var( $f1, FILTER_VALIDATE_URL ) ) {

            // log
            logger( 'copio da URL: ' . $f1 . ' su ' . $f2, 'filesystem' );

            // scarico il file
            $ch = curl_init();
            curl_setopt( $ch, CURLOPT_URL, $f1 );
            curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
            curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 1 ); 
            curl_setopt( $ch, CURLOPT_TIMEOUT, 2 );
            $data = curl_exec( $ch );
            $error = curl_error( $ch );
            curl_close( $ch );

            // se il download è andato a buon fine
            if( empty( $error ) ) {

                // log
                logger( 'download corretto di ' . $f1, 'filesystem' );

                // scrivo il file in locale e restituisco il risultato
                return overwriteToFile( $data, $f2 );

            } else {

                // log
                logger( 'impossibile scaricare ' . $f1 . ' (' . $error . ')', 'filesystem' );

            }

        } else {

            // prelevo i percorsi completi
            $f1 = getFullPath( $f1 );

            // log
            logger( 'copio: ' . $f1 . ' su ' . $f2, 'filesystem' );

            // copio il file e restituisco il risultato
            return copy( $f1, $f2 );

        }

        // restituisco false di default
        return false;

    }

    /**
     * FUNZIONI PER LA LETTURA DELLE INFORMAZIONI DA FILE E CARTELLE
     */
    
    /**
     * questa funzione trasforma un albero di cartelle in un array
     * 
     * La fuonzione prende in imput una cartella e ne fa la scansione ricorsiva, restituendo un array
     * contenente l'elenco delle cartelle nell'albero.
     * 
     * @param       string      $d      il percorso della cartella da trasformare in array
     * 
     * @return      array               l'array contenente l'elenco delle cartelle
     *
     */
    function dirTreeToarray( $d ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // inizializzo l'array
        $a = array();

        // se la cartella esiste
        if( file_exists( $d ) ) {
    
            // aggiungo la cartella all'array
            $a[] = $d;

            // per ogni sotto cartella
            foreach( getFolderIterator( $d ) as $fileinfo ) {
                if( $fileinfo->isDir() ) {
                    $a[] = $fileinfo->getRealPath();
                }
            }

            // restituisco l'array
            return $a;
    
        }

        // restituisco false di default
        return false;

    }
    
    /**
     * restituisce la dimensione in byte di un file
     * 
     * Questa funzione calcola la dimensione in byte di un file.
     *
     * @param       string      $f      il nome del file da controllare comprensivo di percorso
     *
     * @return      int                 la dimensione del file in byte
     * 
     * TODO verificare che il file esista e sia un file
     * TODO verificare di avere i permessi per leggere il file
     *
     */
    function getFileSize( $f ) {

        // restituisco la dimensione del file
        return filesize( getFullPath( $f ) );

    }

    /**
     * calcola ricorsivamente lo spazio occupato da una directory
     *
     * Questa funzione utilizza getFolderIterator() per calcolare ricorsivamente lo spazio occupato da una directory.
     * 
     * @param       string      $d      la directory da controllare
     *
     * @return      int                 la dimensione della cartella
     *
     */
    function getFolderSize( $d ) {

        // inizializzo il totale
        $t = 0;

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            $t += $f->getSize();
        }

        // restituisco il totale
        return $t;

    }

    /**
     * restituisce la dimensione di un file o cartella
     * 
     * Questa funzione utilizza le funzioni getFileSize() e getFolderSize() per restituire la dimensione di un file o di una cartella.
     * 
     * @param       string      $p      il percorso del file o della cartella di cui si desidera conoscere la dimensione
     * 
     * @return      int                 la dimensione del file o della cartella
     * 
     */
    function getSize( $p ) {

        // prelevo il percorso completo
        $p = getFullPath( $p );

        // se $p è una cartella
        if( is_dir( $p ) ) {
            return getFolderSize( $p );
        } else {
            return getFileSize( $p );
        }

    }

    /**
     * restituisce una lista di file ricorsiva
     * 
     * Questa funzione utilizza getFolderIterator() per ottenere una lista di file ricorsiva.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco dei file
     * @param       boolean     $s      se true, restituisce solo il nome del file senza il percorso
     * 
     * @return      array               l'array contenente l'elenco dei file
     *
     */
    function getRecursiveFileList( $d, $s = false ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // inizializzo l'array
        $r = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            if( $f->isFile() ) {
                $r[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
            }
        }

        // restituisco l'array
        return $r;

    }

    /**
     * restituisce una lista di file filtrata
     * 
     * Questa funzione utilizza la funzione glob() per ottenere una lista di file filtrata.
     * 
     * @param       string      $d      il percorso della cartella da esaminare
     * @param       string      $f      il filtro da applicare
     * @param       boolean     $s      se true, restituisce solo il nome del file senza il percorso
     * 
     * @return      array               l'array contenente l'elenco dei file
     *
     */
    function getFilteredFileList( $d , $f = '*', $s = false, $k = false ) {

        // percorso completo di ricerca
        $p = getFolderName( $d ) . $f;

        // se $k è una funzione
        if( function_exists( $k ) ) {
            $p = $k( $p );
        }

        // prelevo il contenuto della cartella
        $a = glob( $p, GLOB_BRACE );

        // inizializzo l'array
        $r = array();

        // ciclo sul contenuto
        foreach( $a as $t ) {
            if( is_file( $t ) ) {
                shortPath( $t );
                if( $s !== false ) {
                    $t = basename( $t );
                }
                $r[] = $t;
            }
        }

        // restituisco l'array
        return array_unique( $r );

    }

    /**
     * restituisce una lista di file
     * 
     * Questa funzione utilizza la funzione getFolderIterator() per ottenere una lista di file.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco dei file
     * @param       boolean     $s      se true, restituisce solo il nome del file senza il percorso
     * 
     * @return      array               l'array contenente l'elenco dei file
     *
     */
    function getFileList( $d, $s = false ) {

        // inizializzo l'array
        $t = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            if( $f->isFile() ) {
                $t[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
            }
        }

        // restituisco l'array
        return $t;

    }

    /**
     * restituisce una lista di cartelle ricorsiva
     * 
     * Questa funzione utilizza getFolderIterator() per ottenere una lista di cartelle ricorsiva.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco delle cartelle
     * @param       boolean     $s      se true, restituisce solo il nome della cartella senza il percorso
     * 
     * @return      array               l'array contenente l'elenco delle cartelle
     *
     */
    function getRecursiveFolderList( $d, $s = false) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // inizializzo l'array
        $r = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            if( $f->isDir() ) {
                $r[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
            }
        }

        // restituisco l'array
        return $r;

    }

    /**
     * restituisce una lista di cartelle filtrata
     * 
     * Questa funzione utilizza la funzione glob() per ottenere una lista di cartelle filtrata.
     * 
     * @param       string      $d      il percorso della cartella da esaminare
     * @param       string      $f      il filtro da applicare
     * 
     * @return      array               l'array contenente l'elenco delle cartelle
     * 
     */
    function getFilteredFolderList( $d, $f = '*', $s = false ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // prelevo il contenuto della cartella
        $a = glob( $d . $f , GLOB_BRACE );

        // inizializzo l'array
        $r = array();

        // ciclo sul contenuto
        foreach( $a as $t ) {
            if( is_dir( $t ) ) {
                shortPath( $t );
                if( $s !== false ) {
                    $t = basename( $t );
                }
                $r[] = $t;
            }
        }

        // restituisco l'array
        return $r;

    }

    /**
     * restituisce una lista di cartelle
     * 
     * Questa funzione utilizza la funzione getFolderIterator() per ottenere una lista di cartelle.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco delle cartelle
     * @param       boolean     $s      se true, restituisce solo il nome della cartella senza il percorso
     * 
     * @return      array               l'array contenente l'elenco delle cartelle
     *
     * 
     * 
     */
    function getFolderList( $d, $s = false ) {

        // inizializzo l'array
        $t = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            if( $f->isDir() ) {
                $t[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
            }
        }

        // restituisco l'array
        return $t;

    }

    /**
     * restituisce una lista di file e cartelle ricorsiva
     * 
     * Questa funzione utilizza getFolderIterator() per ottenere una lista di file e cartelle ricorsiva.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco dei file
     * @param       boolean     $s      se true, restituisce solo il nome del file senza il percorso
     * 
     * @return      array               l'array contenente l'elenco dei file
     *
     */
    function getRecursiveFullList( $d, $s = false ) {

        // prelevo il percorso completo
        $d = getFullPath( $d );

        // inizializzo l'array
        $r = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            $r[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
        }

        // restituisco l'array
        return $r;

    }

    /**
     * restituisce una lista di file e cartelle
     * 
     * Questa funzione utilizza la funzione getFolderIterator() per ottenere una lista di file e cartelle.
     * 
     * @param       string      $d      il percorso della cartella di cui si desidera ottenere l'elenco delle cartelle
     * @param       boolean     $s      se true, restituisce solo il nome della cartella senza il percorso
     * 
     * @return      array               l'array contenente l'elenco delle cartelle
     *
     * 
     * 
     */
    function getFullList( $d, $s = false ) {

        // inizializzo l'array
        $t = array();

        // ciclo sul contenuto
        foreach( getFolderIterator( $d ) as $f ) {
            $t[] = ( $s === true ) ? $f->getRealPath() : $f->getFileName();
        }

        // restituisco l'array
        return $t;

    }

    /**
     * restituisce la parte delle directory di un percorso
     * 
     * La funzione dirname() ha il problema di non considerare la natura dell'ultimo elemento del percorso, quindi se
     * le viene dato in pasto un percorso fatto di sole cartelle, considera l'ultima cartella come un nome di file e la
     * elimina. Questa funzione migliora il comportamento di dirname() ragionando sulla presenza di uno slash
     * alla fine del percorso considerato
     * 
     * @param       string      $p      il percorso dal quale ricavare la parte delle directory
     * 
     * @return      string              la parte del percorso relativa alle directory
     * 
     */
    function getFolderName( $p ) {

        // prelevo il percorso completo
        $p = getFullPath( $p );

        // se il percorso termina con uno slash è una cartella
        if( substr( $p, -1, 1 ) == '/' ) {
            return $p;
        } elseif( is_dir( $p ) ) {
            return $p . '/';
        }

        // restituisco la parte delle directory del percorso
        return dirname( $p );

    }

    /**
     * restituisce l'estensione del file
     *
     * Questa funzione considera l'ultimo elemento di un percorso come un file e ne restituisce l'estensione.
     * 
     * @param       $f          il file da esaminare
     * @return      string      l'estensione del file
     *
     * TODO questa va testata
     * TODO documentare
     * TODO questa funzione non è un doppione?
     *
     */
    function getFileExtension( $f ) {

        // restituisco l'estensione del file
        return substr( basename( $f ) , strrpos( basename( $f ) , '.' ) + 1 );

    }

    /**
     * restituisce il nome di un file senza l'estensione
     * 
     * Questa funzione utilizza la funzione pathinfo() per ottenere il nome del file senza l'estensione
     * partendo da un percorso relativo o assoluto.
     *
     * @param   string      $f      contiene il percorso del file di cui si desidera sapere il nome
     * 
     * @return  string              il nome del file $f senza l'estensione e senza il percorso
     * 
     */
    function getFileNameWithoutExtension( $f ) {

        // ottengo le informazioni sul file
        $i = pathinfo( getFullPath( $f ) );

        // restituisco il nome del file senza l'estensione
        return $i['filename'];

    }

    /**
     * restituisce un elenco ricorsivo filtrato di file
     * 
     * Questa funzione chiama ricorsivamente sé stessa per costruire un elenco di file filtrati tramite la funzione
     * fnmatch() (https://www.php.net/manual/en/function.fnmatch.php).
     * 
     * @param       string      $path       il percorso della cartella da esaminare
     * @param       string      $find       il filtro da applicare
     * 
     * @return      array                   l'array contenente l'elenco dei file
     *
     */
    function globRecursive( $path, $find ) {

        // inizializzo l'array
        $r = array();

        // apro la cartella
        $dh = opendir( $path );

        // se sono riuscito ad aprire la cartella
        if( $dh ) {

            // ciclo sul contenuto
            while( ( $file = readdir( $dh ) ) !== false ) {

                // ignoro la cartella corrente
                if( substr( $file, 0, 1) == '.' ) continue;

                // costruisco il percorso
                $rfile = "{$path}/{$file}";

                // se il percorso è una cartella
                if ( is_dir( $rfile ) ) {

                    // chiamo ricorsivamente la funzione
                    array_merge( $r , globRecursive( $rfile , $find ) );

                } else {

                    // se il file corrisponde al filtro
                    if( fnmatch( $find, $file ) ) {

                        // aggiungo il file all'array
                        $r[] = $file;

                    }

                }

            }

            // chiudo la cartella
            closedir( $dh );

        } else {

            // restituisco false se non sono riuscito ad aprire la cartella
            $r = false;
        
        }

        // restituisco l'array
        return $r;

    }

    /**
     * restituisce il mime type di un file
     * 
     * Questa funzione utilizza la funzione mime_content_type() per ottenere il mime type di un file oppure
     * false se il file non esiste.
     * 
     * @param       string      $f      il file di cui si desidera conoscere il mime type
     * 
     * @return      string              il mime type del file
     *
     */
    function findFileType( $f ) {

        // restituisco il mime type del file
        return ( file_exists( getFullPath( $f ) ) ) ? mime_content_type( getFullPath( $f ) ) : false;

    }

    /**
     * restituisce true se il file è binario
     * 
     * Questa funzione utilizza la funzione isBinaryString() della libreria _string.tools.php per verificare
     * se un file è binario.
     * 
     * @param       string      $f      il file da esaminare
     * 
     * @return      boolean             true se il file è binario, false altrimenti
     *
     */
    function isBinaryFile( $f ) {

        // verifico se il contenuto del file è binario e restituisco il risultato
        return ! mb_check_encoding( readFromFile( $f, FILE_READ_AS_STRING ), 'UTF-8' );

    }

    /**
     * verifica se un file esiste
     * 
     * Questa funzione verifica se un file esiste, sia esso locale o remoto.
     * 
     * @param       string      $f      il file da verificare
     * 
     * @return      boolean             true se il file esiste, false altrimenti
     *
     */
    function fileExists( $f ) {

        // se il file è remoto
        if( filter_var( $f, FILTER_VALIDATE_URL ) ) {

            // prelevo le informazioni sul file
            $ch = curl_init( $f);
            curl_setopt( $ch, CURLOPT_NOBODY, true );
            curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 1 ); 
            curl_setopt( $ch, CURLOPT_TIMEOUT, 2 );
            curl_exec( $ch );
            $code = curl_getinfo( $ch, CURLINFO_HTTP_CODE );
            $status = ( $code == 200 ) ? true : false;
            curl_close( $ch );

            // restituisco il risultato
            return $status;

        } else {

            // prelevo il percorso completo
            $f = getFullPath( $f );

            // restituisco il risultato
            return file_exists( $f );

        }

    }

    /**
     * restituisce la timestamp di modifica di un file
     * 
     * Questa funzione utilizza la funzione filemtime() per ottenere il tempo di modifica di un file. Se il file
     * è remoto, utilizza cURL per ottenere l'header HTTP e da esso l'informazione sulla data e ora di modifica
     * del file.
     * 
     * @param       string      $f      il file di cui si desidera conoscere il tempo di modifica
     * 
     * @return      int                 la timestamp di modifica del file
     *
     */
    function getFileModifiedTime( $f ) {

        // se il file è remoto
        if( filter_var( $f, FILTER_VALIDATE_URL ) ) {

            // prelevo le informazioni sul file
            $ch = curl_init();
            curl_setopt( $ch, CURLOPT_URL , $f );
            curl_setopt( $ch, CURLOPT_HEADER , 1 );
            curl_setopt( $ch, CURLOPT_NOBODY , 1 );
            curl_setopt( $ch, CURLOPT_RETURNTRANSFER , 1 );
            curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 1 ); 
            curl_setopt( $ch, CURLOPT_TIMEOUT, 2 );
            $result = curl_exec( $ch );

            // se ho recuperato le informazioni
            if ( $result !== false && strpos( $result, '200 OK' ) !== false ) {
                $headers = explode( "\n" , $result );
                $last_modified = explode( 'Last-Modified: ' , $headers[3] );
                return strtotime( $last_modified[1] );
            } else {
                return false;
            }

        } else {

            // prelevo il percorso completo
            $f = getFullPath( $f );

            // restituisco il tempo di modifica del file
            return filemtime( $f );

        }

    }

    /**
     * FUNZIONI PER LE VERIFICHE SPECIALI SUI FILE
     */

    /**
     * verifica se un file esiste ed è stato aggiornato entro un certo intervallo di tempo
     * 
     * Questa funzione verifica se un file esiste tramite la funzione fileExists() e se è stato aggiornato
     * entro un dato lasso di tempo combinando le funzioni filemtime() e strtotime().
     * 
     * @param       string      $f      il file da verificare
     * @param       string      $t      il tempo entro il quale il file deve essere stato aggiornato
     * 
     * @return      boolean             true se il file esiste ed è stato aggiornato entro un certo intervallo di tempo, false altrimenti
     * 
     */
    function checkFileConsistency( $f, $t = '-1 day' ) {

        // prelevo il percorso completo
        $f = getFullPath( $f );

        // verifico che il file esista e sia stato aggiornato entro un certo intervallo di tempo
        if( ! file_exists( $f ) ) {
            return false;
        } elseif( filesize( $f ) == 0 ) {
            return false;
        } elseif( filemtime( $f ) < strtotime( $t ) ) {
            return false;
        }

        // restituisco true di default
        return true;

    }

    /**
     * ALIAS DI FUNZIONI INSERITI PER RETROCOMPATIBILITÀ
     */

    // file2array() -> readArrayFromFile()
    function file2array( $f ) {
        return readArrayFromFile( $f );
    }

    // array2file() -> writeArrayToFile()
    function array2file( $f, $a ) {
        return writeArrayToFile( $a, $f );
    }

    // array2keyValueFile() -> writeKeyValueArrayToFile()
    function array2keyValueFile( $f, $a ) {
        return writeKeyValueArrayToFile( $a, $f );
    }

    // keyValueFile2array() -> readKeyValueArrayFromFile()
    function keyValueFile2array( $f ) {
        return readKeyValueArrayFromFile( $f );
    }

    // deleteDir() -> deleteFolder()
    function deleteDir( $d ) {
        return deleteFolder( $d );
    }

    // fileModifiedTime() .> getFileModifiedTime()
    function fileModifiedTime( $f ) {
        return getFileModifiedTime( $f );
    }

    // findFileExtension() -> getFileExtension()
    function findFileExtension( $f ) {
        return getFileExtension( $f );
    }

    // getDirIterator() -> getFolderIterator()
    function getDirIterator( $d ) {
        return getFolderIterator( $d );
    }

    // emptyDir() -> emptyFolder()
    function emptyDir( $d, $p = false ) {
        return emptyFolder( $d, $p );
    }

    // dirTreeToArray() -> dirTreeToarray()
    function dirTree2Array( $d ) {
        return dirTreeToarray( $d );
    }

    // getDirSize() -> getFolderSize()
    function getDirSize( $d ) {
        return getFolderSize( $d );
    }

    // getRecursiveDirList() -> getRecursiveFolderList()
    function getRecursiveDirList( $d, $s = false ) {
        return getRecursiveFolderList( $d, $s );
    }

    // getFilteredDirList() -> getFilteredFolderList()
    function getFilteredDirList( $d, $f = '*', $s = false ) {
        return getFilteredFolderList( $d, $f, $s );
    }

    // getDirList() -> getFolderList()
    function getDirList( $d, $s = false ) {
        return getFolderList( $d, $s );
    }

    // getDirName() -> getFolderName()
    function getDirName( $p ) {
        return getFolderName( $p );
    }
