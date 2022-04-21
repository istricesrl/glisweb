<?php

    /**
     * libreria di funzioni per la generazione dell'output
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // costanti PHP
	define( 'PHP_2EOL'			, PHP_EOL . PHP_EOL );

    // costanti HTML
	define( 'HTML_EOL'			, '<br>' . PHP_EOL );
	define( 'HTML_2EOL'			, '<br>' . HTML_EOL );

    // costanti XHTML
	define( 'XHTML_EOL'			, '<\br>' . PHP_EOL );
	define( 'XHTML_2EOL'			, '<\br>' . XHTML_EOL );

    /**
     *
     * @todo documentare
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
     *
     * @todo documentare
     *
     */
    function buildXml( $content, $encoding = ENCODING_UTF8, $headers = array() ) {

	// genero l'output
	    build( $content, MIME_APPLICATION_XML, $encoding, $headers );

    }

    /**
     *
     * @todo documentare
     *
     */
    function buildText( $content, $encoding = ENCODING_UTF8, $headers = array() ) {

	// genero l'output
	    build( $content, MIME_TEXT_PLAIN, $encoding, $headers );

    }

    /**
     *
     * @todo documentare
     *
     */
    function dieText( $content ) {

	buildContentHeader( );
	die( $content );

    }

    /**
     *
     * @todo supportare title
     * @todo supportare tag aggiuntivi nell'head
     * @todo modificare per output HTML5
     * @todo documentare
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
     *
     * @todo documentare
     *
     */
    function build( $content, $type = MIME_TEXT_PLAIN, $encoding = ENCODING_UTF8, $headers = array() ) {

	// invio gli headers
	    buildHeaders( $headers );

	// invio l'header per il contenuto
	    buildContentHeader( $type, $encoding );

	// invio l'output
	    echo $content;

    }

    /**
     *
     * @todo documentare
     *
     */
    function buildHeaders( $headers ) {

	// invio gli headers
	    foreach( $headers as $header ) {
		header( $header );
	    }

    }

    /**
     *
     * @todo documentare
     *
     */
    function buildContentHeader( $t = MIME_TEXT_PLAIN, $e = ENCODING_UTF8 ) {

	// invio gli headers
	    buildHeaders( array( 'Content-Type: ' . $t . '; charset=' . $e ) );

    }


    function buildCsv( $t, $f = NULL, $e = ENCODING_UTF8 ) {

        header('Content-Type: text/csv');
        if( ! empty( $f ) ) {
            header('Content-Disposition: attachment; filename=' . $f );
        }

        echo $t;

    }
