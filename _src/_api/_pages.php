<?php

    /**
     *
     *
     *
     *
     * logiche di render ed erogazione dei contenuti
     * =============================================
     *
     *
     *
     * tokenizzazione di __rw__ e inclusione del framework
     * ---------------------------------------------------
     *
     *
     * configurazione del template
     * ---------------------------
     *
     *
     *
     * controllo permessi
     * ------------------
     *
     *
     *
     * macro di pagina
     * ---------------
     *
     *
     *
     * contenuti statici
     * -----------------
     *
     *
     *
     * costruzione degli elementi di navigazione
     * -----------------------------------------
     *
     *
     *
     * renderizzazione del template
     * ----------------------------
     *
     *
     *
     * headers e codici di stato HTTP
     * ------------------------------
     *
     *
     *
     *
     * gestione dei comandi di una lettera
     * -----------------------------------
     *
     *
     *
     * cache statica
     * -------------
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // debug
	// var_dump( $_REQUEST );

    // tokenizzazione di __rw__
	if( isset( $_REQUEST['__rw__'] ) ) {
	    $_REQUEST['__rp__'] = explode( '/', trim( $_REQUEST['__rw__'], '/' ) );
	    unset( $_REQUEST['__rw__'] );
	}

    // inclusione del framework
	require '../_config.php';

    // debug
	// die('inizio api pages');
	// ini_set( 'display_errors', 1 );
	// ini_set( 'display_startup_errors', 1 );
	// error_reporting( E_ALL );

    // timer
	timerCheck( $cf['speed'], 'inizio eleborazione API pages' );

    // debug
	// print_r( $ct['page'] );
	// print_r( $ct['page']['macro'] );
	// print_r( $ct['contatti'] );

    // log
	logWrite( 'avvio API pages', 'pages' );

    // log
	appendToFile( 'inizio caricamento file INI del template' . PHP_EOL, FILE_LATEST_RUN );

    // file di configurazione del template
	$ct['page']['template']['ini'] = DIR_BASE . $ct['page']['template']['path'] . 'etc/template.conf';

    // includo il file di configurazione del template
	if( file_exists( $ct['page']['template']['ini'] ) ) {
		// sostituisco il file di configurazione del template con la controparte custom se presente
		if( file_exists( path2custom( $ct['page']['template']['ini'] ) ) ) {
			$ct['page']['template']['ini'] = path2custom( $ct['page']['template']['ini'] );
		}
		// unisco le direttive di configurazione del file a quelle già esistenti
	    $ct['page'] = array_merge_recursive(
			$ct['page'],
			parse_ini_file( $ct['page']['template']['ini'], true, INI_SCANNER_RAW )
	    );
		// includo i file di configurazione aggiuntivi del template
		foreach( glob( DIR_BASE . glob2custom( $ct['page']['template']['path'] ) . 'etc/template.add.conf', GLOB_BRACE ) as $addCnf ) {
			$ct['page'] = array_merge_recursive(
				$ct['page'],
				parse_ini_file( $addCnf, true, INI_SCANNER_RAW )
			);
		}
	} else {
	    logWrite( 'il file ' . $ct['page']['template']['ini'] . ' non esiste', 'template', LOG_CRIT );
	    die( 'file di configurazione del template (' . $ct['page']['template']['ini'] . ') dannaeggiato o mancante' );
	}

    // log
	appendToFile( 'fine caricamento file INI del template' . PHP_EOL, FILE_LATEST_RUN );

	// aggiunta del tema ai CSS da caricare
	// TODO testare cosa fa con i vari css/main.css (standard e custom) css/minchia.css (standard e custom) css/themes/sticazzi.css (standard e custom)
	if( isset( $ct['page']['template']['theme'] ) ) {
		foreach( array( 'css/', 'css/themes/' ) as $tDir ) {
			$tFile = $ct['page']['template']['path'] . $tDir . $ct['page']['template']['theme'];
			$tcFile = path2custom( $tFile );
			if( file_exists( DIR_BASE . $tFile ) ) {
				$ct['page']['css']['template'][] = $tDir . $ct['page']['template']['theme'];
			}
			if( file_exists( DIR_BASE . $tcFile ) ) {
				$ct['page']['css']['custom'][] = $tcFile;
			}
		}
	}

    // log
	appendToFile( 'inizio controllo permessi' . PHP_EOL, FILE_LATEST_RUN );

    // switch dello schema in caso di permessi insufficienti
	if( getPagePermission( $ct['page'] ) !== true ) {
	    $ct['page']['template']['schema'] = 'login.html';
	} elseif( ! isset( $ct['page']['template']['schema'] ) ) {
	    $ct['page']['template']['schema'] = 'default.html';
	}

	// debug
	// print_r( $ct['page']['template'] );

    // log
	appendToFile( 'fine controllo permessi' . PHP_EOL, FILE_LATEST_RUN );

    // log
	appendToFile( 'inizio inclusione macro' . PHP_EOL, FILE_LATEST_RUN );

	// debug
	$includes = array();

    // esecuzione delle macro richieste per la pagina corrente
	if( isset( $ct['page']['macro'] ) && is_array( $ct['page']['macro'] ) ) {
	    foreach( $ct['page']['macro'] as $macro ) {

			$macroAlternative = path2custom( str_replace( '.php', '.alt.php', $macro ) );

			if( file_exists( fullPath( $macroAlternative ) ) ) {

				require fullPath( $macroAlternative );
				timerCheck( $cf['speed'], $macroAlternative );
				appendToFile( 'inclusione macro -> ' . $macroAlternative . PHP_EOL, FILE_LATEST_RUN );
				$includes[] = $macroAlternative;

			} else {

				$macroLocal = path2custom( $macro );

				if( file_exists( fullPath( $macroLocal ) ) && $macro !== $macroLocal ) {

					require fullPath( $macroLocal );
					timerCheck( $cf['speed'], $macroLocal );
					appendToFile( 'inclusione macro -> ' . $macroLocal . PHP_EOL, FILE_LATEST_RUN );
					$includes[] = $macroLocal;

				} elseif( file_exists( fullPath( $macro ) ) ) {

					require fullPath( $macro );
					timerCheck( $cf['speed'], fullPath( $macro ) );
					appendToFile( 'inclusione macro -> ' . $macro . PHP_EOL, FILE_LATEST_RUN );
					$includes[] = $macro;

				} else {

					die( 'impossibile trovare la macro di pagina ' . $macro );

				}

			}
	    }
	}

    // debug
	// print_r( $ct['page']['macro'] );
	// print_r( get_included_files() );

    // timer
	timerCheck( $cf['speed'], 'fine inclusione macro' );

    // log
	appendToFile( 'fine inclusione macro' . PHP_EOL, FILE_LATEST_RUN );

    // inclusione dei contenuti statici
    // TODO usare glob() per prendere anche i contenuti statici dai moduli
    // TODO gli ID delle pagine dovrebbero già contenere . anziché _
    // NOTA solo un contenuto statico alla volta può essere incluso, quindi individuare il criterio con cui sceglierlo
	$ctName = str_replace( '_', '.', $ct['page']['id'] );
	$ctFile = DIR_SRC_INC_CONTENTS . '_' . $ctName . '.' . $cf['localization']['language']['ietf'] . '.html';
	$ctFileLocal = str_replace( '_', NULL, $ctFile );
	if( file_exists( $ctFileLocal ) ) {
	    $ct['page']['content'][ $cf['localization']['language']['ietf'] ] = readStringFromFile( $ctFileLocal );
	} elseif( file_exists( $ctFile ) ) {
	    $ct['page']['content'][ $cf['localization']['language']['ietf'] ] = readStringFromFile( $ctFile );
	}

	// debug
	// var_dump( $ctFile );

    // timer
	timerCheck( $cf['speed'], 'fine inclusione contenuti statici' );

	// log
	appendToFile( 'fine inclusione contenuti statici' . PHP_EOL, FILE_LATEST_RUN );

    // @todo documentare questa cosa delle favicon

	// scrittura dell'indice della cache
	// NOTA questa cosa viene fatta qui perché l'index potrebbe essere modificato dalle macro
	memcacheWrite( $cf['memcache']['connection'], 'CACHE_INDEX', $cf['memcache']['index'] );
	// memcacheWrite( $cf['memcache']['connection'], 'CACHE_REGISTRY', $cf['memcache']['registry'] );

    // timer
	timerCheck( $cf['speed'], 'fine salvataggio indice cache' );

    // ricerca favicons
	$favicons = glob( DIR_BASE . $ct['page']['template']['path'] . 'img/favicons/*.png', GLOB_BRACE );
	$ct['page']['template']['favicons'] = array();
	foreach( $favicons as $favicon ) {
	    $favicon = basename( $favicon );
	    preg_match_all( '/([a-z\-]*)\-([0-9x]*)\.([a-z]*)/', $favicon, $details );
	    if( ! empty( $details[0][0] ) ) {
		switch( $details[1][0] ) {
		    case 'apple-icon':
			$ct['page']['template']['favicons'][] = array(
			    'rel' => 'apple-touch-icon',
			    'sizes' => $details[2][0],
			    'file' => $details[0][0]
			);
		    break;
		    case 'android-icon':
		    case 'favicon':
			$ct['page']['template']['favicons'][] = array(
			    'rel' => 'icon',
			    'sizes' => $details[2][0],
			    'file' => $details[0][0],
			    'type' => 'image/png'
			);
		    break;
		}
	    }
	}
#	asort( $ct['page']['template']['favicons'] );

    // debug
	// print_r( $ct['page']['template']['favicons'] );
	// print_r( $ct['contatti'] );

    // timer
	timerCheck( $cf['speed'], 'fine ricerca favicons' );

	// log
	appendToFile( 'fine ricerca favicons' . PHP_EOL, FILE_LATEST_RUN );

    // debug
	// print_r( $ct['page'] );
	// print_r( $ct['page']['template']['menu'] );
	// print_r( $ct['page']['content'] );
	// if( headers_sent( $file, $line ) ) { echo $file . '->' . $line; } else { echo 'output non iniziato'; }
	// print_r( $ct['page']['css'] );

    // costruzione dei menu
	if( isset( $ct['page']['template']['menu'] ) ) {
	    foreach( $ct['page']['template']['menu'] as $menu => &$nav) {
		$nav = buildMenu( $menu, $cf['contents']['tree'][ NULL ], $cf['contents']['pages'], $ct['page']['id'] );
		timerCheck( $cf['speed'], 'fine generazione menu ' . $menu );
	    }
	}

    // costruzione delle briciole di pane
	$ct['page']['template']['breadcrumbs'] = buildBreadcrumbs( $ct['page'], $ct['page']['id'] );

    // costruzione del selettore lingua
	$ct['page']['template']['flags'] = buildFlags( $ct['page'], $cf['localization']['language']['ietf'] );

    // timer
	timerCheck( $cf['speed'], 'fine generazione elementi secondari di navigazione' );

	// log
	appendToFile( 'fine generazione elementi secondari di navigazione' . PHP_EOL, FILE_LATEST_RUN );

    // debug
	// print_r( $ct['page']['template'] );
	// $tms = array_keys( $cf['speed'] );
	// $run = end( $tms );
	// echo 'corsa: ' . $run;
	// die( 'float: ' . floatval( str_replace( ',', '.', $run ) ) );

    // verifica uso memoria
    // TODO ma è normale questa cosa qua sotto?
	$cf['debug']['mem']['now']['php']	= writeByte( memory_get_usage() );
	$cf['debug']['mem']['now']['sys']	= writeByte( memory_get_usage( true ) );
	$cf['debug']['mem']['peak']['php']	= writeByte( memory_get_usage() );
	$cf['debug']['mem']['peak']['sys']	= writeByte( memory_get_usage( true ) );

    // timer
	timerCheck( $cf['speed'], 'fine check memoria' );

    // ricerca delle risorse CSS minificate
	if( isset( $ct['page']['css'] ) && is_array( $ct['page']['css'] ) ) {
	    foreach( $ct['page']['css'] as $tier => &$rCss ) {
		foreach( $rCss as &$css ) {
		    switch( $tier ) {
			case 'internal':
			    $pre = DIR_BASE;
			break;
			case 'template':
			    $pre = DIR_BASE . $ct['page']['template']['path'];
			break;
			default:
			    $pre = NULL;
			break;
		    }
		    if( strpos( $css, '.min.css' ) === false ) {
			$new = str_replace( '.css', '.min.css', $css );
			if( fileCachedExists( $cf['memcache']['connection'], $pre . $new ) ) {
			    logWrite( $new . ' trovato, consolidarlo nella configurazione', 'speed', LOG_WARNING );
			    $css = $new;
			}
		    }
		}
	    }
	}

    // timer
	timerCheck( $cf['speed'], 'fine ricerca CSS minificati' );

    // ricerca delle risorse JS minificate
	if( isset( $ct['page']['js'] ) && is_array( $ct['page']['js'] ) ) {
	    foreach( $ct['page']['js'] as $tier => &$rJs ) {
		foreach( $rJs as &$js ) {
		    switch( $tier ) {
			case 'internal':
			    $pre = DIR_BASE;
			break;
			case 'template':
			    $pre = DIR_BASE . $ct['page']['template']['path'];
			break;
			default:
			    $pre = NULL;
			break;
		    }
		    if( strpos( $js, '.min.js' ) === false ) {
			$new = str_replace( '.js', '.min.js', $js );
			if( fileCachedExists( $cf['memcache']['connection'], $pre . $new ) ) {
			    logWrite( $new . ' trovato, consolidarlo nella configurazione', 'speed', LOG_WARNING );
			    $js = $new;
			}
		    }
		}
	    }
	}

    // debug
	// print_r( $ct['page'] );
	// print_r( $ct['contatti'] );
	// print_r( $ct['view']['open'] );

    // timer
	timerCheck( $cf['speed'], 'fine ricerca JS minificati' );

    // timer
	timerCheck( $cf['speed'], 'censura e ordinamento array $ct' );

    // censuro l'array $ct per evitare fughe accidentali di informazioni sensibili
	array2censored( $ct );

    // riordino l'array $ct ricorsivamente
	rksort( $ct );

    // timer
	timerCheck( $cf['speed'], 'fine censura e ordinamento array $ct' );

    // renderizzo il template
	if( isset( $ct['page']['template']['type'] ) ) {

		echo PHP_EOL . '<!-- sito realizzato tramite GlisWeb framework (https://glisweb.istricesrl.it) -->' . PHP_EOL;

		echo PHP_EOL . '<!-- ID pagina: ' . $ct['page']['id'] . ' -->' . PHP_EOL;

		if( ! empty( $ct['page']['template']['path'] ) ) {
			echo PHP_EOL . '<!-- template: ' . $ct['page']['template']['path'] . ' -->' . PHP_EOL;
		}

		if( ! empty( $ct['page']['template']['schema'] ) ) {
			echo PHP_EOL . '<!-- schema: ' . $ct['page']['template']['schema'] . ' -->' . PHP_EOL;
		}

		if( ! empty( $ct['page']['template']['theme'] ) ) {
			echo PHP_EOL . '<!-- tema: ' . $ct['page']['template']['theme'] . ' -->' . PHP_EOL;
		}

		echo PHP_EOL;
		foreach( $includes as $include ) {
			echo '<!-- macro: ' . $include . ' -->' . PHP_EOL;
		}

		switch( $ct['page']['template']['type'] ) {

		case 'twig':

		    // timer
			timerCheck( $cf['speed'], '-> inizio operazioni di rendering' );

		    // log
			logWrite( 'template per la pagina ' . $ct['page']['template']['path'], 'template' );

		    // avvio di Twig
#			Twig_Autoloader::register();
			$loader = new \Twig\Loader\FilesystemLoader( DIR_BASE . $ct['page']['template']['path'] );

		    // timer
			timerCheck( $cf['speed'], '-> -> caricamento template' );

			// log
			appendToFile( 'fine caricamento template Twig ' . $ct['page']['template']['path'] . PHP_EOL, FILE_LATEST_RUN );

		    // debug
			// print_r( $cf['twig']['profile'] );
			// print_r( $ct['page']['template']['path'] );
			// print_r( $ct['page']['template']['paths'] );

		    // altri file da includere
			$ct['page']['template']['paths'] = array_replace_recursive(
			    ( isset( $ct['page']['template']['paths'] ) ) ? $ct['page']['template']['paths'] : array(),
#			    array_unique( glob( DIRECTORY_BASE . '{,_}mod/{,_}{' . MODULI_ATTIVI . '}/' . str_replace( '_', '{,_}', $ct['page']['template']['path'] ), GLOB_BRACE ) )
#			    array_unique( glob( DIR_MOD_ATTIVI . glob2custom( $ct['page']['template']['path'] ), GLOB_BRACE ) )
				array_unique( glob( glob2custom( DIR_MOD_ATTIVI . $ct['page']['template']['path'] ), GLOB_BRACE ) )
			);

		    // aggiungo la versione locale del template
			if( file_exists( DIR_BASE . path2custom( $ct['page']['template']['path'] ) ) ) {
			    $ct['page']['template']['paths'][] = DIR_BASE . path2custom( $ct['page']['template']['path'] );
			}

		    // ordinamento degli elementi aggiunti
		    // @todo questo ordinamento serve a qualcosa?
			sort( $ct['page']['template']['paths'] );

		    // aggiungo i percorsi al template manager
			foreach( $ct['page']['template']['paths'] as $add ) {
			    $loader->prependPath( $add );
			}

			// log
			logWrite( 'path dei template aggiuntivi: ' . implode( ', ', $ct['page']['template']['paths'] ), 'twig' );

			// log
			appendToFile( 'fine inserimento dei path aggiuntivi in Twig: ' . implode( ', ', $ct['page']['template']['paths'] ) . PHP_EOL, FILE_LATEST_RUN );

		    // debug
			// print_r( $cf['twig']['profile'] );
			// print_r( $ct['page']['template']['path'] );
			// print_r( $ct['page']['template']['paths'] );

		    // @todo considerare anche 'src/html/' e '_mod/.../_src/_html/' e 'mod/.../src/html/'
		    // aggiungo il percorso con le macro standard e custom
			$loader->addPath( DIR_SRC_HTML );
			if( file_exists( path2custom( DIR_SRC_HTML ) ) ) {
			    $loader->addPath( path2custom( DIR_SRC_HTML ) );
			}

			// log
			appendToFile( 'fine inserimento dei path custom aggiuntivi in Twig' . PHP_EOL, FILE_LATEST_RUN );

		    // ambiente
			$twig = new \Twig\Environment( $loader, $cf['twig']['profile'] );

		    // timer
			timerCheck( $cf['speed'], '-> -> creazione ambiente Twig' );

			// log
			appendToFile( 'fine creazione ambiente Twig' . PHP_EOL, FILE_LATEST_RUN );

		    // estensioni
			$twig->addExtension( new \Twig\Extension\StringLoaderExtension() );
			// $twig->addExtension( new Twig_Extension_Debug() );

		    // timer
			timerCheck( $cf['speed'], '-> -> estensioni Twig' );

			// log
			appendToFile( 'fine inclusione estensioni Twig' . PHP_EOL, FILE_LATEST_RUN );

		    // debug
			// print_r( $ct['page'] );
			// print_r( $ct['contatti'] );

		    // renderizzo lo schema corrente
			$html = $twig->render( $ct['page']['template']['schema'], $ct );

		    // timer
			timerCheck( $cf['speed'], '-> fine render template' );

			// log
			appendToFile( 'fine render template Twig' . PHP_EOL, FILE_LATEST_RUN );

		    // output
			build( $html, MIME_TEXT_HTML );

		    // timer
			timerCheck( $cf['speed'], '-> fine build output' );

		break;

		default:

		    // log
			logWrite( 'tipo di template sconosciuto: ' . $ct['page']['template']['type'], 'template', LOG_CRIT );

		break;

	    }

	} elseif( empty( $ct['page']['template']['type'] ) ) {

	    // log
		logWrite( 'tipo di template non specificato', 'template' );

	}

    // timer
	timerCheck( $cf['speed'], 'fine output' );

    // debug
	// rksort( $cf );
	// echo '<pre>' . print_r( $ct['debug'], true ) . '</pre>';
	// echo '<pre>' . print_r( $ct['pages'], true ) . '</pre>';
	// echo '<pre>' . print_r( $ct['page'], true ) . '</pre>';
	// echo '<pre>' . print_r( $ct['site'], true ) . '</pre>';
	// echo '<pre>' . print_r( $ct, true ) . '</pre>';
	// echo '<pre>' . print_r( $cf['speed'], true ) . '</pre>';
	// echo '<pre>' . print_r( $_REQUEST, true ) . '</pre>';
	// print_r( $ct['page']['headers'] );
	// print_r( $ct['contatti'] );

    // headers
	if( isset( $ct['page']['headers'] ) ) {
	    foreach( $ct['page']['headers'] as $header ) {
			header( $header );
	    }
	}
	
    // codice di stato HTTP
	if( isset( $ct['page']['http']['status'] ) ) {
	    http_response_code( $ct['page']['http']['status'] );
	} else {
	    http_response_code( 200 );
	}

    // debug
	// print_r( get_included_files() );

    // timer
	timerCheck( $cf['speed'], 'fine headers' );

	// log
	appendToFile( 'fine invio headers HTTP' . PHP_EOL, FILE_LATEST_RUN );

    // TODO documentare i parametri a una sola lettera (sono nei Google Docs?)
	// i parametri di una lettera sono riservati a DEV e TEST
	if( SITE_STATUS != PRODUCTION ) {

		// rivelazione dei dati
		if( isset( $_REQUEST['u'] ) && is_array( $_REQUEST['u'] ) ) {
	/*	    array_walk_recursive(
			$ct,
			function( &$v, $k ) {
				if( in_array( $k, array( 'password', 'private', 'key', 'secret' ) ) ) {
				$v = '***';
				}
			}
			);
	*/	    $tpu = $ct;
			foreach( $_REQUEST['u'] as $tu ) {
			if( isset( $tpu[ $tu ] ) ) {
				$tpu = $tpu[ $tu ];
			}
			}
			echo '<pre style="background-color: white;">' . print_r( $tpu, true ) . '</pre>';
		}

		// debug
		// print_r( $cf );

	}

	// TODO qui inserire la formattazione con Tidy?

    // cache del buffer
	echo PHP_EOL;
	if( isset( $ct['page']['cacheable'] ) && $ct['page']['cacheable'] === true ) {
	    writeToFile( ob_get_contents(), DIR_VAR_CACHE_PAGES . basename( FILE_CACHE_PAGE ) );
	    echo '<!-- pagina con autorizzazione al caching -->'				. PHP_EOL;
	    if( FILE_CACHE_PAGE_TIME === NULL ) {
		echo '<!-- page cached for the first time -->'					. PHP_EOL;
	    } else {
		echo '<!-- expired: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_TIME ) . ' -->'	. PHP_EOL;
	    }
	    echo '<!-- expire: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_LIMIT ) . ' -->'	. PHP_EOL;
	    echo '<!-- file: ' . basename( FILE_CACHE_PAGE ) . ' -->'				. PHP_EOL;
	} else {
		header( 'X-Proxy-Cache: BYPASS' );
		header( 'X-GlisWeb-No-Cache: true' );
	    echo PHP_EOL . '<!-- pagina senza autorizzazione al caching -->' . PHP_EOL;
	}
	echo PHP_EOL;

	// NOTA per Nginx si veda https://www.ryadel.com/nginx-reverse-proxy-cache-wordpress-apache-iis-windows/

    // fine del buffer
	ob_end_flush();

    // timer
	timerCheck( $cf['speed'], 'fine esecuzione framework' );

	// log
	appendToFile( 'fine esecuzione framework' . PHP_EOL, FILE_LATEST_RUN );

    // calcolo tempi
	$tms = array_keys( $cf['speed'] );
	$run = end( $tms );
	$flt = floatval( str_replace( ',', '.', substr( $run, 1 ) ) );

    // log
	if( $flt > 0.75 || memory_get_usage( true ) > ( 1024 * 1024 * 15 ) ) {
	    writeToFile(
			$_SERVER['REQUEST_URI'] . PHP_EOL . PHP_EOL .
			'tempo di completamento per gli step di esecuzione del framework:' . PHP_EOL . PHP_EOL .
			print_r( $cf['speed'], true ) . PHP_EOL . 'tempo totale di esecuzione: ' . $flt . PHP_EOL .
			'memoria utilizzata ' . writeByte( memory_get_usage( true ) ) .
			' (picco ' . writeByte( memory_get_peak_usage( true ) ) . ')' . PHP_EOL,
			DIR_VAR_LOG_SLOW . microtime( true ) . '.' . $_SERVER['REMOTE_ADDR'] . '.log'
	    );
	}
