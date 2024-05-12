<?php

    /**
     * generazione della sitemap
     *
     *
	 *
	 * - https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap?hl=it
     * - https://developers.google.com/search/docs/advanced/sitemaps/image-sitemaps?hl=it
     *
     * TODO la generazione della sitemap dovrebbe essere un task a parte
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // timer
	timerCheck( $cf['speed'], 'verifiche preliminari per la sitemap' );

    // sitemap file
    // TODO testare come si comporta con www e non www
	$sitemapFile = DIR_VAR_SITEMAP . 'sitemap.' . $cf['site']['fqdn'] . '.xml';

    // debug
	// echo $sitemapFile;

    // controllo il percorso
	checkFolder( dirname( $sitemapFile ) );

    // timestamp di modifica della sitemap
	if( file_exists( $sitemapFile ) ) {
	    $cf['sitemap']['updated'] = filemtime( $sitemapFile );
	} else {
	    $cf['sitemap']['updated'] = 0;
	}

    // timer
	timerCheck( $cf['speed'], 'fine verifiche preliminari per la sitemap' );

    // verifico se la sitemap va aggiornata
	if( $cf['sitemap']['updated'] < $cf['contents']['updated'] || defined( 'MEMCACHE_REFRESH' ) ) {

	    // timer
		timerCheck( $cf['speed'], 'inizio scrittura sitemap' );

	    // log
		logWrite( 'sitemap scritta in quanto ' . $cf['contents']['updated'] . ' > ' . $cf['sitemap']['updated'], 'sitemap' );

	    // latest
		writeToFile( 'inizio scrittura sitemap' . PHP_EOL, FILE_LATEST_SITEMAP );

	    // inizializzo l'array degli URL
		$url = array();

	    // inizializzo l'oggetto XML
		$xml = new XMLWriter();

	    // specifico il file di destinazione
		$xml->openURI( $sitemapFile );

	    // inizio il documento
		$xml->startDocument( '1.0', 'UTF-8' );

	    // attivo l'indentazione
		$xml->setIndent( true );
		$xml->setIndentString( '  ' );

	    // root element
		$xml->startElement( 'urlset' );
		$xml->writeAttribute( 'xmlns', 'http://www.sitemaps.org/schemas/sitemap/0.9' );
		$xml->writeAttribute( 'xmlns:xhtml', 'http://www.w3.org/1999/xhtml' );
//		$xml->writeAttributeNs( 'xhtml', 'xmlns', 'http://www.w3.org/1999/xhtml', 'http://www.sitemaps.org/schemas/sitemap/0.9' );

/*
	    // array della sitemap
		$map = array();

	    // urlset
		$map['urlset']['@'] = array( 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns|xhtml' => 'http://www.w3.org/1999/xhtml' );
*/

	    // scorro l'elenco delle pagine
		foreach( $cf['localization']['languages'] as $lang ) {

		    // latest
			appendToFile( 'lingua elaborata: ' . $lang['ietf'] . PHP_EOL, FILE_LATEST_SITEMAP );

		    // scorro l'elenco delle pagine
			foreach( $cf['contents']['pages'] as $id => $page ) {

			    // latest
				appendToFile( 'pagina elaborata: ' . $id . PHP_EOL, FILE_LATEST_SITEMAP );

			    // verifico se la pagina va nella sitemap
				if( isset( $page['sitemap'] ) && $page['sitemap'] == true ) {

				    // latest
					appendToFile( 'sitemap true per: ' . $id . PHP_EOL, FILE_LATEST_SITEMAP );

				    // verifico se la pagina corrente appartiene al sito corrente
					if( $page['id_sito'] == SITE_CURRENT ) {

					    // latest
						appendToFile( 'match: ' . $page['id_sito'] . '/' . SITE_CURRENT . PHP_EOL, FILE_LATEST_SITEMAP );

					    // inizio l'elemento <url>
						$xml->startElement( 'url' );

					    // scrivo in un solo passaggio l'elemento <loc>
						$xml->writeElement( 'loc', $page['url'][ $lang['ietf'] ] );

					    // aggiungo l'URL
						$url[] = $page['url'][ $lang['ietf'] ];

					    // ciclo sugli altri linguaggi se il sito è multilingua
						if( count( $cf['localization']['languages'] ) > 1 ) {
						    foreach( $cf['localization']['languages'] as $linklang ) {

							// inizio l'elemento <xhtml:link>
							    $xml->startElementNs( 'xhtml', 'link', NULL );

							// attributi di <xhtml:link>
							    $xml->writeAttribute( 'rel', 'alternate' );
							    $xml->writeAttribute( 'hreflang', $linklang['ietf'] );
							    $xml->writeAttribute( 'href', $page['url'][ $linklang['ietf'] ] );

#				    $current = array( 'loc' => $page['url'][ $lang['ietf'] ] );
#				    foreach( $cf['localization']['languages'] as $linklang ) {
#					$current['xhtml|link'][] = array(
#					    '@' => array(
#						'rel' => 'alternate',
#						'hreflang' => $linklang['ietf'],
#						'href' => $page['url'][ $linklang['ietf'] ]
#					    )
#					);
#				    }
#				    $map['urlset']['url'][] = $current;

							// chiudo l'elemento <xhtml:link>
							    $xml->endElement();

						    }

						}

					    // chiudo l'elemento <url>
						$xml->endElement();

					} else {

					    // latest
						appendToFile( 'mismatch: ' . $page['id_sito'] . '/' . SITE_CURRENT . PHP_EOL, FILE_LATEST_SITEMAP );

					}

				} else {

				    // debug
					// echo 'la pagina #' . $id . ' non è candidata per la sitemap' . PHP_EOL;
					// var_dump( $page['sitemap'] );

				    // latest
					appendToFile( 'sitemap false per: ' . $id . PHP_EOL, FILE_LATEST_SITEMAP );

				}

			}	// fine ciclo pagine

	    }			// fine ciclo lingue

	    // debug
		// die( print_r( $map, true ) );
/*
	    // generazione sitemap
		array2xml( $map, 'sitemap.xml' );
*/
	    // fine del root element
		$xml->endElement();

	    // fine del document
		$xml->endDocument();

	    // scrittura su file
		$xml->flush();

	    // timer
		timerCheck( $cf['speed'], 'fine scrittura sitemap XML' );

	    // prelevo le immagini dal database
	    // TODO prelevare solo le immagini relative al sito corrente
		$img = mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM immagini' );

	    // aggiungo le immagini alla mappa CSV
		foreach( $img as $i ) {
		    $url[] = $cf['site']['url'] . $i;
		}

	    // prelevo i file dal database
	    // TODO prelevare solo le immagini relative al sito corrente
		$fls = mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM file' );

	    // aggiungo le immagini alla mappa CSV
		foreach( $fls as $f ) {
		    $url[] = $cf['site']['url'] . dirname( $f ) . '/' . rawurlencode( basename( $f ) );
		}

	    // pulisco e riordino l'array degli URL
		$url = array_unique( $url );
		sort( $url );

	    // apro la mappa CSV
		$csv = fopen( DIR_VAR_SITEMAP . 'sitemap.' . $cf['site']['fqdn'] . '.csv', 'w+' );

	    // scrivo la sitemap CSV
		foreach( $url as $u ) {
		    fwrite( $csv, $u . PHP_EOL );
		}

	    // chiudo la mappa CSV
		fclose( $csv );

	    // timer
		timerCheck( $cf['speed'], 'fine scrittura sitemap CSV' );

	} else {

	    // log
		logWrite( 'sitemap non scritta in quanto ' . $cf['contents']['updated'] . ' < ' . $cf['sitemap']['updated'], 'sitemap', LOG_DEBUG );

	}

    // debug
	// echo file_get_contents( DIRECTORY_BASE . 'sitemap.xml' );
	// print_r( xml2array( file_get_contents( DIRECTORY_BASE . 'sitemap.xml' ) ) );
	// print_r( $map );
	// echo array2xml( xml2array( file_get_contents( DIRECTORY_BASE . 'sitemap.xml' ) ) );
	// echo $sitemapFile;
