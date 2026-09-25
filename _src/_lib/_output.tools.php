<?php

    /**
     * libreria di funzioni per la generazione dell'output
     * 
     * Questa libreria contiene le funzioni che inviano al client l'output del framework nei vari formati (JSON, XML,
     * testo, HTML, CSV) insieme agli header HTTP corrispondenti.
     * 
     * introduzione
     * ============
     * Le API del framework e dei moduli concludono quasi sempre il loro lavoro chiamando una delle funzioni build*()
     * di questa libreria; la più usata è buildJson(), che codifica in JSON il risultato e lo invia con il content type
     * application/json. Tutte le funzioni di output passano per build(), che invia prima gli header aggiuntivi
     * richiesti dal chiamante, poi l'header Content-Type con il charset, e infine stampa il contenuto.
     * 
     * NOTA le funzioni di questa libreria stampano l'output ma NON terminano lo script (fa eccezione dieText()); se
     * dopo l'output non deve essere eseguito altro codice è il chiamante che deve preoccuparsene.
     * 
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * PHP_2EOL                     | doppio fine riga di PHP
     * HTML_EOL                     | tag br seguito da un fine riga di PHP
     * HTML_2EOL                    | doppio tag br seguito da un fine riga di PHP
     * XHTML_EOL                    | tag br chiuso ( <br /> ) seguito da un fine riga di PHP
     * XHTML_2EOL                   | doppio tag br chiuso seguito da un fine riga di PHP
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di output per formato
     * ------------------------------
     * Le funzioni in questo gruppo servono per inviare l'output in un formato specifico.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * buildJson()                      | invia al client un contenuto codificato in JSON
     * buildXml()                       | invia al client un contenuto XML
     * buildText()                      | invia al client un contenuto in testo semplice
     * dieText()                        | invia al client un testo semplice e termina lo script
     * buildHTML()                      | invia al client un contenuto racchiuso in un documento HTML
     * buildCsv()                       | invia al client un contenuto CSV, eventualmente come file da scaricare
     * 
     * funzioni generiche di output
     * ----------------------------
     * Le funzioni in questo gruppo sono quelle su cui si basano le funzioni di output per formato.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * build()                          | invia al client gli header e un contenuto di tipo dato
     * buildHeaders()                   | invia al client una lista di header HTTP
     * buildContentHeader()             | invia al client l'header Content-Type con il charset
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * string2utf8()                    | _src/_lib/_localization.tools.php
     * logWrite()                       | _src/_lib/_log.utils.php
     * xmlEntities()                    | _src/_lib/_xml.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    // costanti PHP
    define( 'PHP_2EOL'            , PHP_EOL . PHP_EOL );

    // costanti HTML
    define( 'HTML_EOL'            , '<br>' . PHP_EOL );
    define( 'HTML_2EOL'            , '<br>' . HTML_EOL );

    // costanti XHTML
    define( 'XHTML_EOL'            , '<br />' . PHP_EOL );
    define( 'XHTML_2EOL'            , '<br />' . XHTML_EOL );

    /**
     * FUNZIONI DI OUTPUT PER FORMATO
     */

    /**
     * invia al client un contenuto codificato in JSON
     * 
     * Questa funzione ricodifica in UTF-8 il contenuto con string2utf8() (anche ricorsivamente se è un array), lo
     * codifica con json_encode() e lo invia con build() con il content type application/json. Se la codifica fallisce
     * l'errore viene scritto nel log json e al client viene inviata la stringa vuota (json_encode() restituisce false).
     * 
     * Un header Content-Type passato in $headers prende il posto di application/json con il charset; si veda build().
     * 
     * @param       mixed       $content        il contenuto da codificare in JSON
     * @param       string      $encoding       il charset da dichiarare nell'header (default ENCODING_UTF8)
     * @param       array       $headers        gli header HTTP aggiuntivi da inviare (default nessuno)
     * 
     * @return      void
     * 
     */
    function buildJson( $content, $encoding = ENCODING_UTF8, $headers = array() ) {

        // generazione del contenuto
        $json = json_encode( string2utf8( $content ) );

        // log
        if( ! empty( json_last_error() ) ) {
            logWrite( 'errore #'.json_last_error().' '.json_last_error_msg(), 'json', LOG_ERR );
        }

    // genero l'output
        build( $json, MIME_APPLICATION_JSON, $encoding, $headers );

    }

    /**
     * invia al client un contenuto XML
     * 
     * Questa funzione invia con build() il contenuto così com'è, con il content type application/xml; il contenuto
     * deve essere già una stringa XML, la funzione non ne verifica la validità.
     * 
     * @param       string      $content        il contenuto XML
     * @param       string      $encoding       il charset da dichiarare nell'header (default ENCODING_UTF8)
     * @param       array       $headers        gli header HTTP aggiuntivi da inviare (default nessuno)
     * 
     * @return      void
     * 
     */
    function buildXml( $content, $encoding = ENCODING_UTF8, $headers = array() ) {

    // genero l'output
        build( $content, MIME_APPLICATION_XML, $encoding, $headers );

    }

    /**
     * invia al client un contenuto in testo semplice
     * 
     * Questa funzione invia con build() il contenuto così com'è, con il content type text/plain.
     * 
     * @param       string      $content        il testo da inviare
     * @param       string      $encoding       il charset da dichiarare nell'header (default ENCODING_UTF8)
     * @param       array       $headers        gli header HTTP aggiuntivi da inviare (default nessuno)
     * 
     * @return      void
     * 
     */
    function buildText( $content, $encoding = ENCODING_UTF8, $headers = array() ) {

    // genero l'output
        build( $content, MIME_TEXT_PLAIN, $encoding, $headers );

    }

    /**
     * invia al client un testo semplice e termina lo script
     * 
     * Questa funzione invia l'header Content-Type text/plain con charset UTF-8 e termina lo script con die() stampando
     * il contenuto; è usata soprattutto nelle righe di debug per mostrare il contenuto di una variabile in una pagina
     * web senza che il browser lo interpreti come HTML. Se il contenuto è un intero, die() lo usa come codice di uscita
     * e non lo stampa.
     * 
     * @param       string      $content        il testo da stampare
     * 
     * @return      void                        la funzione non ritorna
     * 
     */
    function dieText( $content ) {

    buildContentHeader( );
    die( $content );

    }

    /**
     * invia al client un contenuto racchiuso in un documento HTML
     * 
     * Questa funzione costruisce con DOM un documento HTML 4.01 strict con meta charset utf-8, il titolo $name (o, se
     * vuoto, "documento generato" seguito dalla data corrente) e nel body il contenuto, e lo invia con build() con il
     * content type text/html. Il contenuto viene passato per xmlEntities(), che lo translittera in ASCII (le lettere
     * accentate perdono l'accento) e fa l'escape delle &, e deve essere un frammento XML ben formato perché viene
     * aggiunto con appendXML(); se non lo è il body resta vuoto e PHP emette un warning.
     * 
     * NOTA l'HTML generato viene passato per urldecode() prima dell'invio, per cui i + del contenuto diventano spazi e
     * le sequenze %xx vengono decodificate ("1+1" diventa "1 1"). Al momento della stesura di questa documentazione la
     * funzione non è usata da nessun file.
     * TODO verificare il motivo di urldecode() sull'intero documento e limitarlo agli attributi che ne hanno bisogno
     * 
     * TODO supportare title
     * TODO supportare tag aggiuntivi nell'head
     * TODO modificare per output HTML5
     * 
     * @param       string      $content        il frammento HTML da mettere nel body
     * @param       string      $name           il titolo del documento (default NULL, cioè titolo automatico)
     * @param       string      $encoding       il charset da dichiarare nell'header HTTP (default ENCODING_UTF8; il
     *                                          meta charset del documento è sempre utf-8)
     * @param       array       $headers        gli header HTTP aggiuntivi da inviare (default nessuno)
     * 
     * @return      void
     * 
     */
    function buildHTML( $content, $name = NULL, $encoding = ENCODING_UTF8, $headers = array() ) {

    // preparazione del documento
        $dom = new DOMImplementation;
        $doctype = $dom->createDocumentType( 'html', '-//W3C//DTD HTML 4.01//EN', 'http://www.w3.org/TR/html4/strict.dtd' );
        $document = $dom->createDocument( NULL, 'html', $doctype );

        $document->preserveWhiteSpace = false;
        $document->formatOutput = true;

        $html = $document->documentElement;
        $head = $document->createElement( 'head' );
        $title = $document->createElement( 'title' );

        $meta = $document->createElement( 'meta' );
        $meta->setAttribute( 'charset', 'utf-8' );
        $head->appendChild( $meta );

        $text = $document->createTextNode( ( ! empty( $name ) ) ? $name : 'documento generato ' . date( 'r' ) );
        $body = $document->createElement( 'body' );

        $contentFragment = $document->createDocumentFragment();
        $contentFragment->appendXML( xmlEntities( $content ) );

        $title->appendChild( $text );
        $head->appendChild( $title );
        $html->appendChild( $head );
        $html->appendChild( $body );
        $body->appendChild( $contentFragment );

    // genero l'output
        build( urldecode( $document->saveHTML() ), MIME_TEXT_HTML, $encoding, $headers );

    }

    /**
     * FUNZIONI GENERICHE DI OUTPUT
     */

    /**
     * invia al client gli header e un contenuto di tipo dato
     * 
     * Questa funzione invia gli header aggiuntivi con buildHeaders(), poi l'header Content-Type con tipo e charset con
     * buildContentHeader(), e infine stampa il contenuto; è la funzione su cui si basano tutte le altre funzioni build*()
     * della libreria. Non termina lo script.
     * 
     * Se fra gli header aggiuntivi c'è già un Content-Type ( con chiave stringa, o per intero con chiave numerica, senza
     * distinzione fra maiuscole e minuscole ) la funzione lo invia così com'è e non invia quello costruito con $type ed
     * $encoding. Fino al 2026-09-24 lo sovrascriveva sempre, perché header() sostituisce un header con lo stesso nome e
     * quello di $type veniva inviato dopo; buildJson(), che aggiungeva da sé un Content-Type senza charset, non lo fa più.
     * 
     * @param       string      $content        il contenuto da stampare
     * @param       string      $type           il content type (default MIME_TEXT_PLAIN)
     * @param       string      $encoding       il charset (default ENCODING_UTF8)
     * @param       array       $headers        gli header HTTP aggiuntivi da inviare (default nessuno)
     * 
     * @return      void
     * 
     */
    function build( $content, $type = MIME_TEXT_PLAIN, $encoding = ENCODING_UTF8, $headers = array() ) {

        // invio gli headers
        buildHeaders( $headers );

        // cerco il content type fra gli headers passati dal chiamante
        $passed = false;
        foreach( $headers as $header => $value ) {
            if( strtolower( trim( ( is_string( $header ) ) ? $header : strtok( $value, ':' ) ) ) == 'content-type' ) {
                $passed = true;
            }
        }

        // invio l'header per il contenuto, se il chiamante non l'ha già passato
        if( $passed === false ) {
            buildContentHeader( $type, $encoding );
        }

        // invio l'output
        echo $content;

        // debug
        // var_dump( headers_list() );

    }

    /**
     * invia al client una lista di header HTTP
     * 
     * Questa funzione invia con header() gli header contenuti nell'array; gli elementi con chiave stringa vengono
     * inviati nella forma "chiave: valore", quelli con chiave numerica vengono inviati così come sono, per cui il
     * valore deve contenere l'header completo. Un array vuoto non invia niente. Come header(), non ha effetto se gli
     * header sono già stati inviati (a parte il warning di PHP).
     * 
     * @param       array       $headers        gli header da inviare
     * 
     * @return      void
     * 
     */
    function buildHeaders( $headers ) {

        // invio gli headers
        foreach( $headers as $header => $value ) {
            if( is_string( $header ) ) {
                // removeheader( $header );
                header( $header . ': ' . $value );
            } else {
                header( $value );
            }
        }

    }

    /**
     * invia al client l'header Content-Type con il charset
     * 
     * Questa funzione invia l'header Content-Type nella forma "tipo; charset=encoding"; chiamata senza argomenti
     * invia text/plain in UTF-8.
     * 
     * @param       string      $t      il content type (default MIME_TEXT_PLAIN)
     * @param       string      $e      il charset (default ENCODING_UTF8)
     * 
     * @return      void
     * 
     */
    function buildContentHeader( $t = MIME_TEXT_PLAIN, $e = ENCODING_UTF8 ) {

    // invio gli headers
        buildHeaders( array( 'Content-Type: ' . $t . '; charset=' . $e ) );

    }

    /**
     * invia al client un contenuto CSV, eventualmente come file da scaricare
     * 
     * Questa funzione invia l'header Content-Type text/csv e, se è specificato un nome di file, l'header
     * Content-Disposition che fa scaricare il contenuto come allegato con quel nome; poi stampa il contenuto. Non passa
     * per build() e non invia il charset. Il contenuto deve essere già una stringa CSV.
     * 
     * NOTA il parametro $e non viene usato.
     * 
     * @param       string      $t      il contenuto CSV
     * @param       string      $f      il nome del file da scaricare (default NULL, cioè nessun allegato)
     * @param       string      $e      il charset (default ENCODING_UTF8, attualmente ignorato)
     * 
     * @return      void
     * 
     */
    function buildCsv( $t, $f = NULL, $e = ENCODING_UTF8 ) {

        header('Content-Type: text/csv');
        if( ! empty( $f ) ) {
            header('Content-Disposition: attachment; filename=' . $f );
        }

        echo $t;

    }
