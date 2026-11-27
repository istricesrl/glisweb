<?php

    /**
     * libreria per la lettura e la scrittura dei fogli di calcolo
     *
     * Questa libreria contiene le funzioni che il framework usa per leggere e scrivere i fogli di calcolo ( Excel e
     * formati compatibili ) appoggiandosi alla libreria esterna PhpSpreadsheet, e per normalizzare i valori letti dalle
     * celle prima di scriverli nel database.
     *
     * introduzione
     * ============
     * I fogli di calcolo arrivano al framework soprattutto dagli utenti, come file da importare: per questo la funzione
     * centrale della libreria è xlsLoad(), che apre un file da leggere con le difese contro i file costruiti apposta, ed è
     * la funzione da usare ogni volta che si legge un foglio di calcolo, al posto di chiamare direttamente il reader di
     * PhpSpreadsheet. Accanto alla lettura la libreria offre la scrittura di un array in un file `.xlsx`, la conversione
     * di un foglio in CSV e qualche funzione per trattare i valori come Excel li salva: le date, che nelle celle sono
     * numeri seriali, i numeri con i separatori all'italiana o all'inglese, le lettere delle colonne.
     *
     * PhpSpreadsheet è installata da Composer ( `phpoffice/phpspreadsheet` ) in `_src/_lib/_ext/`, come tutte le librerie
     * esterne del framework; le sue classi si usano col namespace completo, senza `use`.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni per le coordinate
     * --------------------------
     * Le funzioni in questo gruppo servono per lavorare con le coordinate delle celle.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * xlsIncrementCol()                | sposta una lettera di colonna di un certo numero di colonne
     *
     * funzioni di lettura
     * -------------------
     * Le funzioni in questo gruppo servono per leggere i fogli di calcolo.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * xlsLoad()                        | apre un foglio di calcolo da leggere, con le difese contro i file costruiti apposta
     * xls2csv()                        | converte il foglio attivo di un file in un file CSV
     *
     * funzioni di scrittura
     * ---------------------
     * Le funzioni in questo gruppo servono per scrivere i fogli di calcolo.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * array2xlsFile()                  | scrive un array di array associativi in un file Excel
     *
     * funzioni di conversione dei valori
     * ----------------------------------
     * Le funzioni in questo gruppo servono per convertire i valori letti dalle celle in valori utilizzabili dal framework.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * xlsDate2timestamp()              | converte una data letta da una cella in un timestamp Unix
     * xlsNumber2mysql()                | converte un numero letto da una cella nel formato numerico di MySQL
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni e classi:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * fullPath()                       | _src/_lib/_filesystem.tools.php
     * matrix2csvFile()                 | _src/_lib/_csv.tools.php
     * PhpOffice\PhpSpreadsheet         | phpoffice/phpspreadsheet ( Composer )
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2022-01-25       | Fabio Mosti          | creazione della libreria
     * 2023-03-09       | Fabio Mosti          | aggiunta xlsDate2timestamp()
     * 2023-03-14       | Fabio Mosti          | aggiunta xlsNumber2mysql()
     * 2026-10-29       | Fabio Mosti          | xlsLoad(), difese contro le CVE-2026-108358/108359/108360
     * 2026-10-30       | Fabio Mosti          | documentazione
     * 2026-10-30       | Fabio Mosti          | correzione di xls2csv() e xlsNumber2mysql()
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI PER LE COORDINATE
     */

    /**
     * sposta una lettera di colonna di un certo numero di colonne
     *
     * Questa funzione prende la lettera di una colonna ( `A`, `Z`, `AA`… ) e restituisce quella che si trova un certo
     * numero di colonne più in là, passando per l'indice numerico della colonna; serve per scrivere celle adiacenti senza
     * fare a mano il conto delle lettere ( `Z` + 1 è `AA` ). Un incremento negativo sposta la colonna verso sinistra.
     *
     * NOTA un incremento che porta prima della colonna `A` non è controllato, e il risultato dipende da PhpSpreadsheet.
     *
     * @param       string      $col    la lettera della colonna di partenza
     * @param       int         $inc    il numero di colonne di cui spostarsi
     *
     * @return      string              la lettera della colonna di arrivo
     *
     */
    function xlsIncrementCol( $col, $inc ) {

        $old = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::columnIndexFromString( $col );
        $new = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex( $old + $inc );

        return $new;

    }

    /**
     * FUNZIONI DI LETTURA
     */

    /**
     * apre un foglio di calcolo da leggere, con le difese contro i file costruiti apposta
     *
     * Il framework legge con PhpSpreadsheet anche file caricati dagli utenti ( importazioni ), e sulle versioni
     * fino alla 1.30.6 un file costruito apposta può fare tre cose: leggere file o chiamare indirizzi interni con
     * un'entità esterna che sfugge al controllo XmlScanner ( CVE-2026-108358 ), esaurire CPU e memoria con un ODS
     * dalle righe ripetute all'infinito ( CVE-2026-108359 ), far chiamare al server un indirizzo qualsiasi con
     * un'immagine collegata ( CVE-2026-108360; fino alla 1.25 senza nessun controllo ). La versione corretta, la
     * 1.30.7, vuole PHP 7.4, quindi sui deploy fermi a PHP 7.3 le difese stanno qui:
     *
     * difesa                                       | contro
     * ---------------------------------------------|--------------------------------------------------------
     * solo i reader Xlsx, Xls e Csv                | il DoS dell'ODS, e i reader Html, Xml, Gnumeric e Slk
     * libxml senza DTD e senza entità esterne      | l'XXE, anche quando XmlScanner viene aggirato
     * http, https, ftp, ftps e phar spenti         | la chiamata di un'immagine collegata, e i phar:// nei
     *   durante la lettura                         | percorsi
     *
     * Le difese valgono anche con la 1.30.7, e non tolgono niente a quello che il framework legge: i dati, gli
     * stili e i formati delle celle. Le impostazioni globali toccate si rimettono com'erano alla fine.
     *
     * Durante la lettura i warning e i notice di PHP non vanno a video ma nel log xls, a LOG_WARNING: un'immagine
     * collegata, coi wrapper di rete spenti, fa sollevare a PhpSpreadsheet un warning di file_get_contents() che con
     * display_errors acceso finirebbe nella risposta.
     *
     * Un file che non si può leggere ( formato non ammesso, file rovinato, difese che scattano ) non solleva
     * eccezioni: la funzione scrive il motivo nel log xls e restituisce false, che il chiamante deve controllare prima
     * di usare il risultato. Le schede delle tre vulnerabilità sono in `_usr/_docs/_cve/`.
     *
     * @param       string      $file           il file da aprire
     *
     * @return      mixed                       lo Spreadsheet, oppure false se il file non si può leggere
     *
     */
    function xlsLoad( $file ) {

        // impostazioni da rimettere alla fine
        $opzioni = \PhpOffice\PhpSpreadsheet\Settings::getLibXmlLoaderOptions();
        $entita = ( PHP_VERSION_ID < 80000 ) ? libxml_disable_entity_loader( true ) : NULL;
        $spenti = array_intersect( array( 'http', 'https', 'ftp', 'ftps', 'phar' ), stream_get_wrappers() );

        // niente DTD, niente entità esterne, niente rete
        \PhpOffice\PhpSpreadsheet\Settings::setLibXmlLoaderOptions( 0 );
        foreach( $spenti as $w ) {
            stream_wrapper_unregister( $w );
        }

        // NOTA con i wrapper di rete spenti PhpSpreadsheet, davanti a un'immagine collegata, solleva il warning di
        // file_get_contents() "Unable to find the wrapper": la difesa regge, ma con display_errors acceso il warning finisce
        // nella risposta e ModSecurity la blocca, quindi durante la lettura warning e notice vanno nel log xls
        set_error_handler( function( $livello, $messaggio, $origine, $riga ) {
            logger( 'avviso durante la lettura: ' . $messaggio . ' in ' . $origine . ':' . $riga, 'xls', LOG_WARNING );
            return true;
        }, E_WARNING | E_NOTICE );

        try {
            $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReaderForFile( $file, array( 'Xlsx', 'Xls', 'Csv' ) );
            $xls = $reader->load( $file );
        } catch( \Throwable $e ) {
            logger( 'impossibile leggere ' . $file . ': ' . $e->getMessage(), 'xls', LOG_ERR );
            $xls = false;
        }

        // impostazioni com'erano
        restore_error_handler();
        foreach( $spenti as $w ) {
            stream_wrapper_restore( $w );
        }
        \PhpOffice\PhpSpreadsheet\Settings::setLibXmlLoaderOptions( $opzioni );
        if( $entita !== NULL ) {
            libxml_disable_entity_loader( $entita );
        }

        return $xls;

    }

    /**
     * converte il foglio attivo di un file in un file CSV
     *
     * Questa funzione apre il file con xlsLoad(), legge il foglio attivo come matrice di valori e lo scrive con
     * matrix2csvFile() in un file CSV separato da punto e virgola, accanto all'originale: il nome è quello del file senza
     * l'estensione `.xlsx` o `.xls`, maiuscola o minuscola, più `.csv`, e un CSV già esistente con quel nome viene
     * sovrascritto. Un file con un'altra estensione si tiene il nome intero ( `foglio.csv` diventa `foglio.csv.csv` ),
     * così il file di partenza non viene mai sovrascritto. Il percorso del file può essere relativo alla root del deploy,
     * perché viene normalizzato con fullPath(). Se il file non si può leggere restituisce false.
     *
     * Fino al 2026-10-30 la funzione chiamava array2csvFile() coi parametri sfasati, e il CSV usciva separato da `w+`;
     * in più l'estensione si sostituiva distinguendo le maiuscole, e un file `.XLSX` veniva sovrascritto dal suo CSV.
     *
     * @param       string      $file           il file da convertire
     *
     * @return      mixed                       il percorso del file CSV creato, oppure false se il file non si può leggere
     *
     */
    function xls2csv( $file ) {

        // normalizzo il percorso
        fullPath( $file );

        // apro il documento per leggere il numero di righe ( vedi xlsLoad() )
        $xls = xlsLoad( $file );
        if( $xls === false ) {
            return false;
        }

        // converto il foglio attivo in un array
        $arr = $xls->getActiveSheet()->toArray();

        // nuovo file
        $nFile = preg_replace( '/\.xlsx?$/i', '', $file ) . '.csv';

        // converto l'array in CSV
        matrix2csvFile( $arr, $nFile, ';' );

        // restituisco il nome del file creato
        return $nFile;

    }

    /**
     * FUNZIONI DI SCRITTURA
     */

    /**
     * scrive un array di array associativi in un file Excel
     *
     * Questa funzione scrive i dati in un file nel formato Xlsx, qualunque sia l'estensione del file indicato, che viene
     * sovrascritto se esiste già. La prima riga del foglio contiene le intestazioni, ricavate dalle chiavi del primo
     * elemento di $data; le righe successive contengono i valori di ogni elemento, nell'ordine in cui compaiono, quindi
     * tutti gli elementi devono avere le stesse chiavi nello stesso ordine. Il percorso del file può essere relativo
     * alla root del deploy, perché viene normalizzato con fullPath().
     *
     * NOTA l'ordine dei parametri è l'inverso di array2csvFile(): qui prima il file, poi i dati.
     *
     * TODO con $data vuoto, o senza l'elemento di chiave 0, le intestazioni non si possono ricavare e la funzione
     * emette un notice.
     *
     * @param       string      $file           il file su cui scrivere
     * @param       array       $data           l'array di array associativi da scrivere
     *
     * @return      void
     *
     */
    function array2xlsFile( $file, $data ) {

        // normalizzo il percorso
        fullPath( $file );

        // nuovo foglio di calcolo
        $spreadSheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
        $workSheet = $spreadSheet->getActiveSheet();

        // prelevo le intestazioni dalla prima riga
        $sheet = array( array_keys( $data[0] ) );

        // debug
        // die( '<pre>' . print_r( $sheet, true ) . '</pre>' );

        // le righe diventano sequenziali, nell'ordine delle intestazioni
        array_walk( $data, function( &$row, $key ) { $row = array_values( $row ); } );

        // debug
        // die( '<pre>' . print_r( $data, true ) . '</pre>' );

        // intestazioni seguite dalle righe
        $sheet = array_merge( $sheet, $data );

        // debug
        // die( '<pre>' . print_r( $sheet, true ) . '</pre>' );

        // scrivo intestazioni e righe a partire dalla cella A1
        $workSheet->fromArray( $sheet, NULL, 'A1' );

        // creo il writer
        // $writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter( $spreadSheet, "Xlsx" );
        $writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx( $spreadSheet );

        // debug
        // header('Content-Disposition: attachment; filename="myfile.xlsx"');
        // header('Cache-Control: max-age=0');
        // $writer->save( 'php://output' );

        // debug
        // die( $file );

        // salvo il file
        $writer->save( $file );

    }

    /**
     * FUNZIONI DI CONVERSIONE DEI VALORI
     */

    /**
     * converte una data letta da una cella in un timestamp Unix
     *
     * Questa funzione accetta le due forme in cui una data arriva da un foglio di calcolo. Se il valore è numerico è il
     * numero seriale con cui Excel salva le date, cioè i giorni trascorsi dal 30/12/1899: la funzione toglie i 25569 giorni
     * che separano quella data dal 01/01/1970 e moltiplica per i secondi di un giorno, quindi la parte decimale diventa
     * l'ora e il risultato è riferito a UTC. Se il valore è una stringa la spezza sulle barre, ricompone la data nella
     * forma `YYYY-mm-dd` secondo il formato indicato e la converte con strtotime(). Ogni passo viene scritto nel log
     * della funzione.
     *
     * I formati riconosciuti sono `dd/mm/YYYY` ( il default ), `YYYY/mm/dd` e `mm/dd/YYYY`.
     *
     * TODO una data non numerica con un separatore diverso dalla barra, o un formato non fra i tre, non viene
     * ricomposta: la funzione emette un notice e restituisce false.
     *
     * @param       mixed       $d              la data letta dalla cella, numero seriale o stringa
     * @param       string      $f              il formato della data se è una stringa ( default `dd/mm/YYYY` )
     *
     * @return      mixed                       il timestamp Unix, oppure false se la stringa non si può convertire
     *
     */
    function xlsDate2timestamp( $d, $f = 'dd/mm/YYYY' ) {

        logger( 'data da elaborare: ' . $d, __FUNCTION__ );

        $r = NULL;

        if( is_numeric( $d ) ) {

            $r = ( $d - 25569 ) * 86400;

        } else {

            $date = explode( '/', $d );

            logger( 'array degli elementi: ' . print_r( $date, true ), __FUNCTION__ );

            if( $f == 'dd/mm/YYYY' ) {
                $rd = $date[2] . '-' . $date[1] . '-' . $date[0];
            } elseif( $f == 'YYYY/mm/dd' ) {
                $rd = $date[0] . '-' . $date[1] . '-' . $date[2];
            } elseif( $f == 'mm/dd/YYYY' ) {
                $rd = $date[2] . '-' . $date[0] . '-' . $date[1];
            }

            logger( 'data riarrangiata: ' . $rd, __FUNCTION__ );

            $r = strtotime( $rd );

        }

        logger( 'data elaborata: ' . $r, __FUNCTION__ );

        return $r;

    }

    /**
     * converte un numero letto da una cella nel formato numerico di MySQL
     *
     * Questa funzione porta un numero scritto con i separatori all'italiana ( `1.234,56` ) o all'inglese ( `1,234.56` )
     * nella forma che MySQL accetta ( `1234.56` ): con la sola virgola la virgola diventa il punto decimale, con entrambi
     * i separatori si toglie quello delle migliaia, cioè il primo dei due; un numero senza virgola resta com'è. Un
     * valore numerico, come lo restituisce una cella di tipo numero, viene restituito come stringa e per il resto
     * invariato.
     *
     * NOTA con un solo tipo di separatore la funzione non può capire se è quello delle migliaia: `1.234` resta `1.234`, e
     * `1,234,567` diventa `1.234.567`, che MySQL non accetta.
     *
     * Fino al 2026-10-30 la funzione non faceva niente: gli argomenti di strpos() erano invertiti e il risultato non
     * veniva restituito.
     *
     * @param       mixed       $d              il numero letto dalla cella
     *
     * @return      string                      il numero nel formato di MySQL
     *
     */
    function xlsNumber2mysql( $d ) {

        // posizione dei separatori
        $d = (string) $d;
        $dot = strpos( $d, '.' );
        $com = strpos( $d, ',' );

        // la virgola diventa il punto decimale, il separatore delle migliaia sparisce
        if( $com !== false && $dot === false ) {
            $d = str_replace( ',', '.', $d );
        } elseif( $com !== false && $dot !== false ) {
            if( $dot < $com ) {
                $d = str_replace( ',', '.', str_replace( '.', '', $d ) );
            } else {
                $d = str_replace( ',', '', $d );
            }
        }

        return $d;

    }
