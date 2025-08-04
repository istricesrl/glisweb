<?php

    /**
     * generazione della sitemap
     * 
     * Questo file si occupa di generare la sitemap del sito corrente in base ai contenuti presenti nell'array delle pagine.
     * 
     * introduzione
     * ============
     * La sitemap è un file (XML o CSV) che contiene l'elenco delle pagine del sito, utile per i motori di ricerca in ordine
     * all'indicizzazione delle pagine stesse. Le specifiche in base alle quali una sitemap dev'essere realizzata per poter essere
     * utilizzata dai motori di ricerca sono le seguenti:
	 * 
	 * - https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap?hl=it
     * - https://developers.google.com/search/docs/advanced/sitemaps/image-sitemaps?hl=it
     * 
     * Il framework si basa sulla timestamp di ultimo aggiornamento dei contenuti per determinare se la sitemap va aggiornata o meno;
     * inoltre, la generazione della sitemap viene forzata nel caso in cui si stia ricreando la cache (MEMCACHE_REFRESH).
     * 
     * meccanismo di generazione della sitemap
     * =======================================
     * Il meccanismo con cui viene generata la sitemap è abbastanza semplice, tutte le pagine del sito presenti nell'array $cf['contents']['pages']
     * vengono elaborate e, se il flag 'sitemap' è impostato a true, aggiunte alla sitemap. Si noti che questo processo è ripetuto per ognuna delle
     * lingue attive nel sito, il che genera una sitemap multilingua.
     * 
     * Le sitemap elaborate e completate vengono salvate in /var/sitemap/ e fornite ai client su richiesta tramite una regola di .htaccess:
     * 
     * ```
     * RewriteRule ^sitemap.xml var/sitemap/sitemap.%{HTTP_HOST}.xml [L]
     * RewriteRule ^sitemap.csv var/sitemap/sitemap.%{HTTP_HOST}.csv [L]
     * ```
     * 
     * Queste regole si occupano di reindirizzare le richieste alla sitemap appropriata in base al dominio corrente. Questo è molto importante negli
     * scenari di tipo multisito, per evitare confusioni fra le sitemap dei vari siti.
     * 
     */

    /**
     * configurazioni preliminari
     * ==========================
     * 
     * 
     * 
     */

    // timer
	timerCheck( $cf['speed'], 'verifiche preliminari per la sitemap' );

    // sitemap file
    // TODO testare come si comporta con www e non www
	$sitemapFile = DIR_VAR_SITEMAP . 'sitemap.' . $cf['site']['fqdn'] . '.xml';

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

    /**
     * generazione della sitemap
     * =========================
     * 
     * 
     * 
     * 
     */

    // log
    logger( 'verifica stato aggiornamento sitemap', 'sitemap' );

    // verifico se la sitemap va aggiornata
	if( $cf['sitemap']['updated'] < $cf['contents']['updated'] || defined( 'MEMCACHE_REFRESH' ) ) {

	    // timer
		timerCheck( $cf['speed'], 'inizio scrittura sitemap' );

	    // log
		logger( 'sitemap scritta in quanto ' . $cf['contents']['updated'] . ' > ' . $cf['sitemap']['updated'], 'sitemap' );
        loggerLatest( 'inizio scrittura sitemap', FILE_LATEST_SITEMAP );

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

	    // scorro l'elenco delle pagine
		foreach( $cf['localization']['languages'] as $lang ) {

		    // latest
			loggerLatest( 'lingua elaborata: ' . $lang['ietf'], FILE_LATEST_SITEMAP );

		    // scorro l'elenco delle pagine
			foreach( $cf['contents']['pages'] as $id => $page ) {

			    // latest
				loggerLatest( 'pagina elaborata: ' . $id, FILE_LATEST_SITEMAP );

			    // verifico se la pagina va nella sitemap
				if( isset( $page['sitemap'] ) && $page['sitemap'] == true ) {

				    // latest
					loggerLatest( 'sitemap true per: ' . $id, FILE_LATEST_SITEMAP );

				    // verifico se la pagina corrente appartiene al sito corrente
					if( ! isset( $page['id_sito'] ) || $page['id_sito'] == SITE_CURRENT ) {

					    // latest
						loggerLatest( 'match: ' . ( $page['id_sito'] ?? 'nessuno' ) . '/' . SITE_CURRENT, FILE_LATEST_SITEMAP );

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

							// chiudo l'elemento <xhtml:link>
							    $xml->endElement();

						    }

						}

					    // chiudo l'elemento <url>
						$xml->endElement();

					} else {

					    // latest
						loggerLatest( 'mismatch: ' . ( $page['id_sito'] ?? 'nessuno' ) . '/' . SITE_CURRENT, FILE_LATEST_SITEMAP );

					}

				} else {

				    // latest
					loggerLatest( 'sitemap false per: ' . $id, FILE_LATEST_SITEMAP );

				}

			}

	    }

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

	    // pulisco l'array degli URL
		$url = array_unique( $url );

        // ordino l'array degli URL
        sort( $url );

	    // apro la mappa CSV
		$csv = fopen( DIR_VAR_SITEMAP . 'sitemap.' . $cf['site']['fqdn'] . '.csv', 'w+' );

	    // scrivo la sitemap CSV
		foreach( $url as $u ) {
		    fwrite( $csv, $u );
		}

	    // chiudo la mappa CSV
		fclose( $csv );

	    // timer
		timerCheck( $cf['speed'], 'fine scrittura sitemap CSV' );

	} else {

	    // log
		logger( 'sitemap non scritta in quanto ' . $cf['contents']['updated'] . ' < ' . $cf['sitemap']['updated'], 'sitemap' );

	}

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     * 
     */

    // debug
	// echo file_get_contents( DIRECTORY_BASE . 'sitemap.xml' );
	// print_r( xml2array( file_get_contents( DIRECTORY_BASE . 'sitemap.xml' ) ) );
	// print_r( $map );
	// echo array2xml( xml2array( file_get_contents( DIRECTORY_BASE . 'sitemap.xml' ) ) );
	// echo $sitemapFile;
