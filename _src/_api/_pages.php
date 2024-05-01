<?php

    /**
     * API per l'erogazione delle pagine del sito
     *
     * questo script ha il compito di erogare le pagine del sito dopo aver svolto le necessarie operazioni di rendering
     * 
     * introduzione
     * ============
     * Questa API si occupa di ricevere le richieste di contenuti e di trasformarle in pagine HTML. Questo implica unire i dati dell'array
     * dei contenuti ($ct) con un template (tipicamente Twig) e inviare al browser il risultato.
     *
     * logiche di render ed erogazione dei contenuti
     * =============================================
     * Ogni volta che si chiama il framework richiedendo una pagina (ad es. /cartella/pagina.html) il file .htaccess, dopo aver verificato
     * che il file richiesto non esista, dopo aver passato tutti i check per percorsi speciali come task, cartelle protette, eccetera,
     * passa a questo file il compito di erogare la pagina richiesta.
     * 
     * Le regole che nel file .htaccess si occupano di gestire questa parte sono:
     * 
     * \code{.htaccess}
     * # gestione delle pagine
     * RewriteCond %{REQUEST_FILENAME} !-f
     * RewriteRule ^([a-zA-Z0-9_\-\/]+)*[\.]*([a-zA-Z0-9_\-\/]+)* _src/_api/_pages.php?__rw__=$1&__lg__=$2 [L,QSA]
     * \endcode
     *
     * Come si vede, il file .htaccess passa a questo script due parametri GET, __rw__ e __lg__. Il primo contiene il percorso della pagina,
     * mentre il secondo contiene l'eventuale specifica della lingua ricavata dall'elaborazione dell'estensione del file richiesto (ad es.
     * /cartella/pagina.it-IT.html). Queste due informazioni vengono elaborate sia qui che nell'esecuzione del framework come spiegato nei
     * paragrafi successivi. Si supponga ad esempio di chiamare il framework indicando il seguente percorso:
     * 
     * /cartella/pagina.html
     * 
     * Secondo la regola di rewriting vista prima, si otterrà che il mod_rewrite assegni le variabili nel modo seguente:
     * 
     * - __rw__ = cartella/pagina
     * - __lg__ = html
     * 
     * Più comunemente le pagine del framework vengono chiamate con un percorso del tipo:
     * 
     * /cartella/pagina.it-IT.html
     * 
     * Il che si traduce nella seguente assegnazione:
     * 
     * - __rw__ = cartella/pagina
     * - __lg__ = it-IT
     * 
     * Per capire come queste due variabili sono elaborate dal framework, si veda la documentazione relativa rispettivamente ai file
     * _src/_config/_400.rewrite.php e _src/_config/_085.localization.php oltre alla documentazione di questo stesso file. In breve, il file
     * _src/_config/_400.rewrite.php si occupa di identificare, in base al percorso richiesto, la pagina da mostrare all'utente.
     * 
     * Per pagina si intende, nel gerdo del framework, un paragrafo di configurazione dell'array $cf['contents']['pages'] che contiene
     * le informazioni base per la costruzione di una pagina di contenuto e quindi title, h1, testo, headers, e così via. Per maggiori dettagli
     * sui campi che definiscono una pagina si veda la documentazione del file _src/_config/_310.pages.php.
     * 
     * Si tenga presente infine che, sebbene la creazione di pagine tramite la popolazione diretta dell'array $cf['contents']['pages'] sia
     * l'opzione più ovvia, il framework offre alcune alternative interessanti che vale la pena di analizzare in dettaglio, cosa che faremo
     * nel prossimo paragrafo.
     *
     * altri modi di erogare contenuti
     * ===============================
     * Si parta dal presupposto che, per come è costruito il file .htaccess del framework, la richiesta di una risorsa esistente (tipicamente,
     * un file) è di solito trasparente e viene gestita in maniera diretta, senza che il codice del framework sia chiamato in causa in nessun
     * modo. Questo consente di creare siti statici, eventualmente perfino siti completamente realizzati in HTML, all'interno della stessa
     * cartella dove si trova GlisWeb e, al netto di alcuni percorsi particolari, questo non interferirà in alcun modo con la navigazione.
     * 
     * Sebbene si tratti di un caso limite, possono darsi alcuni scenari in cui questa caratteristica del framework è necessaria, quindi sebbene
     * sia nata nelle sue versioni più antiche, è stata sempre mantenuta in quelle successive. Se possibile, è consigliabile raggruppare i
     * contenuti statici nell'apposita sotto cartella usr/pages/ come si vedrà fra poco.
     * 
     * directory ad accesso diretto
     * ----------------------------
     * Le cartelle _usr/_pages/ e usr/pages/ sono dette ad accesso diretto perché, per tutto ciò che vi è contenuto, l'esecuzione del framework
     * non viene punto invocata. In questo modo è possibile includervi qualsiasi tipo di contenuto che non venendo processato dal framework
     * verrà servito agli utenti da Apache senza alcuna elaborazione. Questa caratteristica di GlisWeb è intesa per usi particolari, in cui il
     * framework deve convivere con altri contenuti o addirittura con altri CMS.
     *
     */

    // debug
    // var_dump( $_REQUEST );

    /**
     * tokenizzazione di __rw__
     * ========================
     * Il file _src/_config/_400.rewrite.php richiede che il contenuto della variabile __rw__ sia tokenizzato in un array. Questo viene fatto
     * tramite la funzione explode() che divide la stringa in base al carattere / dopodiché eventuali spazi in eccesso vengono rimossi
     * con l'aiuto della funzione trim(). Il risultato è un array di stringhe contenente i vari livelli del percorso richiesto.
     * 
     */

    // tokenizzazione di __rw__
    if( isset( $_REQUEST['__rw__'] ) ) {
        $_REQUEST['__rp__'] = explode( '/', trim( $_REQUEST['__rw__'], '/' ) );
        unset( $_REQUEST['__rw__'] );
    }

    // debug
    // var_dump( $_REQUEST );

    /**
     * inclusione del framework
     * ========================
     * Come tutti i file del framework, anche questo script inizia con l'inclusione del file /_src/_config.php.
     * 
     */

    // inclusione del framework
    require '../_config.php';

    // debug
    // print_r( $ct['page'] );
	// die('inizio api pages');
	// ini_set( 'display_errors', 1 );
	// ini_set( 'display_startup_errors', 1 );
	// error_reporting( E_ALL );

    // timer
	timerCheck( $cf['speed'], 'inizio eleborazione API pages' );

    // log
	logger( 'avvio API pages per ' . $_SERVER['REDIRECT_URL'] . ' -> ' . $_SERVER['REQUEST_URI'], 'pages' );

    // log
	loggerLatest( 'inizio caricamento file INI del template' );

    /**
     * parsing del file di configurazione del template
     * ===============================================
     * Ogni template deve contenere necessariamente una sottocartella etc/ contenente a sua volta un file di configurazione chiamato
     * template.conf. Questo file contiene le direttive di configurazione del template stesso e deve rispettare il formato INI, in
     * quando viene letto tramite la funzione parse_ini_file().
     * 
     * Le direttive principali che occorre specificare nel file di configurazione del template sono:
     * 
     * campo                    | descrizione
     * -------------------------|---------------------------------------------------
     * template.type            | l'unico valore ammesso per ora è twig, ma in futuro potrebbero essere implementati altri template manager
     * template.menu.<m>        | un array contenente le chiavi <m> dei menu da generare
     * template.login           | il nome del file di schema da utilizzare in caso di permessi insufficienti
     * template.default         | il nome del file di schema da utilizzare in caso di schema non specificato
     * css.external             | un array contenente i percorsi dei file CSS esterni (ossia quelli che vengono caricati da un URL esterno)
     * css.internal             | un array contenente i percorsi dei file CSS interni (ossia quelli che vengono prelevati dal framework)
     * css.template             | un array contenente i percorsi dei file CSS interni (ossia quelli che vengono prelevati dalla cartella del template)
     * js.external              | un array contenente i percorsi dei file Js esterni (ossia quelli che vengono caricati da un URL esterno)
     * js.internal              | un array contenente i percorsi dei file Js interni (ossia quelli che vengono prelevati dal framework)
     * js.template              | un array contenente i percorsi dei file Js interni (ossia quelli che vengono prelevati dalla cartella del template)
     * 
     * TODO i CSS andrebbero ulteriormente suddivisi per media (screen, print, eccetera) mentre per i JavaScript sarebbe utile specificare
     * altri parametri come la firma (per i Js esterni), il caricamento differito, eccetera. Si può quindi pensare di affiancare al file
     * di configurazione in formato INI un file di configurazione in formato JSON o YAML che consenta di specificare le informazioni in
     * modo più strutturato e che si possa sovrapporre in maniera lineare con l'array $cf. In prospettiva si potrebbe poi rendere
     * deprecato l'utilizzo del file INI in favore del JSON o dello YAML.
     * 
     */

    // file di configurazione del template
	$ct['page']['template']['ini'] = DIR_BASE . $ct['page']['template']['path'] . 'etc/template.conf';
	$ct['page']['template']['yaml'] = DIR_BASE . $ct['page']['template']['path'] . 'etc/template.yaml';

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

        // debug
        // print_r( $ct['page'] );
        // print_r( $ct['page']['template'] );
        // die('lettura file INI del template completata');

	} elseif( file_exists( $ct['page']['template']['yaml'] ) ) {

        // debug
        // var_dump( $ct['page']['template']['yaml'] );
        // print_r( yaml_parse( file_get_contents( $ct['page']['template']['yaml'] ) ) );

        // sostituisco il file di configurazione del template con la controparte custom se presente
        if( file_exists( path2custom( $ct['page']['template']['yaml'] ) ) ) {
            $ct['page']['template']['yaml'] = path2custom( $ct['page']['template']['yaml'] );
        }

        // unisco le direttive di configurazione del file a quelle già esistenti
        $ct['page'] = array_merge_recursive(
            $ct['page'],
            yaml_parse( file_get_contents( $ct['page']['template']['yaml'] ) )
        );

        // includo i file di configurazione aggiuntivi del template
        foreach( glob( DIR_BASE . glob2custom( $ct['page']['template']['path'] ) . 'etc/template.add.yaml', GLOB_BRACE ) as $addCnf ) {
            $ct['page'] = array_merge_recursive(
                $ct['page'],
                yaml_parse( file_get_contents( $addCnf ) )
            );
        }

        // debug
        // print_r( $ct['page'] );
        // print_r( $ct['page']['template'] );
        // var_dump( $ct['page']['template']['yaml'] );
        // die('lettura file YAML del template completata');

    } else {

        // log
        logger( 'il file ' . $ct['page']['template']['ini'] . ' non esiste', 'template', LOG_CRIT );

        // debug
        die( 'file di configurazione del template (' . $ct['page']['template']['ini'] . ') dannaeggiato o mancante' );

    }

    // timer
	timerCheck( $cf['speed'], 'fine caricamento file INI del template' );

    // log
	loggerLatest( 'fine caricamento file INI del template' );

    // debug
	// print_r( $ct['page'] );
    // print_r( $ct['page']['template'] );
    // die();

    /**
     * template e tema
     * ===============
     * Fra le varie opzioni di customizzazione che offrono i template di GlisWeb c'è la possibilità di specificare un tema, ovvero
     * un CSS aggiuntivo da caricare per personalizzare ulteriormente l'aspetto del sito. Il file CSS indicato viene cercato
     * in ordine nelle cartelle css/ e css/themes/ del template. Come di consueto viene data la priorità alla versione custom
     * del tema (se presente). Se per qualche motivo si specifica un tema inesistente, il parametro theme viene ignorato.
     * 
     * Si noti che il tema viene cercato solo nel modulo base, in quanto riguarda l'intero template e non avrebbe senso pensare
     * a temi inseriti nei moduli.
     * 
     */

    // aggiunta del tema ai CSS da caricare
	if( isset( $ct['page']['template']['theme'] ) ) {
		foreach( array( 'css/', 'css/themes/' ) as $tDir ) {
			$tFile = $ct['page']['template']['path'] . $tDir . $ct['page']['template']['theme'];
			$tcFile = path2custom( $tFile );
			if( file_exists( DIR_BASE . $tcFile ) ) {
				$ct['page']['css']['custom'][] = $tcFile;
			} elseif( file_exists( DIR_BASE . $tFile ) ) {
				$ct['page']['css']['template'][] = $tDir . $ct['page']['template']['theme'];
			}
		}
	}

    // timer
	timerCheck( $cf['speed'], 'fine caricamento tema del template' );

    // log
	loggerLatest( 'fine caricamento tema del template' );

    /**
     * Content Security Policy
     * =======================
     * 
     * TODO vedi https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
     * 
     * TODO finire di implementare e documentare tutta la parte su CSP che è molto interessante.
     * 
     */

    // ...
	foreach( array( 'external', 'preload' ) as $type ) {
		if( isset( $ct['page']['css'][ $type ] ) && is_array( $ct['page']['css'][ $type ] ) ) {
			foreach( $ct['page']['css'][ $type ] as $k => $v ) {
				$ct['page']['csp']['style-src'][] = domainFromURL( $v );
			}
			$ct['page']['csp']['style-src'] = array_unique( $ct['page']['csp']['style-src'] );
		} else {
			$ct['page']['csp']['style-src'] = array();
		}
	}

	// ...
	foreach( array( 'external' ) as $type ) {
		if( isset( $ct['page']['js'][ $type ] ) && is_array( $ct['page']['js'][ $type ] ) ) {
			foreach( $ct['page']['js'][ $type ] as $k => $v ) {
				$ct['page']['csp']['script-src'][] = domainFromURL( $v );
			}
			$ct['page']['csp']['script-src'] = array_unique( $ct['page']['csp']['script-src'] );
		} else {
			$ct['page']['csp']['script-src'] = array();
		}
	}

    // ...
	if( isset( $ct['page']['csp']['default-src'] ) ) {

        // ...
		$ct['page']['csp']['default-src'] = array_merge(
			array( "'self'" ),
			array_intersect(
				$ct['page']['csp']['script-src'],
				$ct['page']['csp']['style-src']
			)
		);
	
        // ...
		$ct['page']['csp']['style-src'] = array_diff(
			$ct['page']['csp']['style-src'],
			$ct['page']['csp']['default-src']
		);

        // ...
        $ct['page']['csp']['script-src'] = array_diff(
			$ct['page']['csp']['script-src'],
			$ct['page']['csp']['default-src']
		);
	
	}

	// timer
	timerCheck( $cf['speed'], 'fine elaborazione dati per CSP' );

    // log
	loggerLatest( 'fine elaborazione dati per CSP' );

	// debug
	// print_r( array_intersect( $ct['page']['csp']['script-src'], $ct['page']['csp']['style-src'] ) );
    // print_r( $ct['page'] );
    // print_r( $ct['page']['css'] );
    // print_r( $ct['page']['csp'] );
    // die();

    /**
     * controllo permessi
     * ==================
     * 
     * 
     * 
     * 
     */

    // log
	loggerLatest( 'inizio controllo permessi' );

    // switch dello schema in caso di permessi insufficienti
	if( getPagePermission( $ct['page'] ) !== true ) {
	    $ct['page']['template']['schema'] = ( isset( $ct['page']['template']['login'] ) ) ? $ct['page']['template']['login'] : 'login.html';
	} 

    // switch dello schema in caso di schema non specificato
    if( ! isset( $ct['page']['template']['schema'] ) ) {
	    $ct['page']['template']['schema'] = ( isset( $ct['page']['template']['default'] ) ) ? $ct['page']['template']['default'] : 'default.html';
	}

	// debug
	// print_r( $ct['page']['template'] );

    // timer
	timerCheck( $cf['speed'], 'fine controllo permessi' );

    // log
	loggerLatest( 'fine controllo permessi' );

    /**
     * macro di pagina
     * ===============
     * 
     * 
     */

    // debug
	$includes = array();

    // se ci sono macro richieste per la pagina corrente
	if( isset( $ct['page']['macro'] ) && is_array( $ct['page']['macro'] ) ) {

        // per ogni macro richiesta
        foreach( $ct['page']['macro'] as $macro ) {

            // cerco le macro alternative
			$macroAlternative = path2custom( str_replace( '.php', '.alt.php', $macro ) );

            // se ci sono macro alternative...
			if( file_exists( fullPath( $macroAlternative ) ) ) {

                // includo la macro alternativa
				loggerLatest( 'avvio inclusione macro -> ' . $macroAlternative );
				require fullPath( $macroAlternative );
				timerCheck( $cf['speed'], $macroAlternative );
				loggerLatest( 'fine inclusione macro -> ' . $macroAlternative );
				$includes[] = $macroAlternative;

			} else {

                // cerco la macro custom
				$macroLocal = path2custom( $macro );

                // se esiste la macro custom
				if( file_exists( fullPath( $macroLocal ) ) && $macro !== $macroLocal ) {

                    // includo la macro custom
					loggerLatest( 'avvio inclusione macro -> ' . $macroLocal );
					require fullPath( $macroLocal );
					timerCheck( $cf['speed'], $macroLocal );
					loggerLatest( 'fine inclusione macro -> ' . $macroLocal );
					$includes[] = $macroLocal;

				} elseif( file_exists( fullPath( $macro ) ) ) {

                    // includo la macro standard
					loggerLatest( 'avvio inclusione macro -> ' . $macro . PHP_EOL );
					require fullPath( $macro );
					timerCheck( $cf['speed'], fullPath( $macro ) );
					loggerLatest( 'fine inclusione macro -> ' . $macro . PHP_EOL );
					$includes[] = $macro;

				} else {

                    // debug
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
	loggerLatest( 'fine inclusione macro' );

    /**
     * contenuti statici
     * =================
     * 
     * 
     */

    // inclusione dei contenuti statici
    // TODO usare glob() per prendere anche i contenuti statici dai moduli
    // TODO gli ID delle pagine dovrebbero già contenere . anziché _
    // NOTA solo un contenuto statico alla volta può essere incluso, quindi individuare il criterio con cui sceglierlo
	$ctName = str_replace( '_', '.', $ct['page']['id'] );
	$ctFile = DIR_SRC_INC_CONTENTS . '_' . $ctName . '.' . $cf['localization']['language']['ietf'] . '.html';
	$ctFileLocal = str_replace( '_', '', $ctFile );
	if( file_exists( $ctFileLocal ) ) {
	    $ct['page']['content'][ $cf['localization']['language']['ietf'] ] = '<!-- contenuto incluso: ' . $ctFileLocal . ' -->' . PHP_EOL . readStringFromFile( $ctFileLocal );
	} elseif( file_exists( $ctFile ) ) {
	    $ct['page']['content'][ $cf['localization']['language']['ietf'] ] = '<!-- contenuto incluso: ' . $ctFile . ' -->' . PHP_EOL . readStringFromFile( $ctFile );
	}

	// debug
	// var_dump( $ctFile );
    // var_dump( $ct['page']['content'] );

    // timer
	timerCheck( $cf['speed'], 'fine inclusione contenuti statici' );

	// log
	loggerLatest( 'fine inclusione contenuti statici' );

    /**
     * scrittura dell'indice della cache
     * =================================
     * 
     * NOTA questa cosa viene fatta qui perché l'index potrebbe essere modificato dalle macro
     * 
     */

	// scrittura dell'indice della cache
	memcacheWrite( $cf['memcache']['connection'], 'CACHE_INDEX', $cf['memcache']['index'] );
	// memcacheWrite( $cf['memcache']['connection'], 'CACHE_REGISTRY', $cf['memcache']['registry'] );

    // timer
	timerCheck( $cf['speed'], 'fine salvataggio indice cache' );

    /**
     * ricerca delle favicons
     * ======================
     *
     * 
     */

    // ricerca favicons
	$favicons = glob( DIR_BASE . glob2custom( $ct['page']['template']['path'] ) . 'img/favicons/*.png', GLOB_BRACE );
	if( empty( $favicons ) ) {
		$favicons = glob( DIR_BASE . glob2custom( $ct['page']['template']['path'] ) . 'img/favicons/'.$cf['site']['id'].'/*.png', GLOB_BRACE );
	}

	// preparazione favicons
	$ct['page']['template']['favicons'] = array();
	foreach( $favicons as $favicon ) {
		$path = shortPath( dirname( $favicon ) );
	    $favicon = basename( $favicon );
	    preg_match_all( '/([a-z\-]*)\-([0-9x]*)\.([a-z]*)/', $favicon, $details );
	    if( ! empty( $details[0][0] ) ) {
			switch( $details[1][0] ) {
				case 'apple-icon':
					$ct['page']['template']['favicons'][] = array(
						'rel' => 'apple-touch-icon',
						'sizes' => $details[2][0],
						'file' => $details[0][0],
						'path' => $path
					);
				break;
				case 'android-icon':
				case 'favicon':
					$ct['page']['template']['favicons'][] = array(
						'rel' => 'icon',
						'sizes' => $details[2][0],
						'file' => $details[0][0],
						'type' => 'image/png',
						'path' => $path
					);
				break;
			}
	    }
	}

    // debug
	// print_r( $ct['page']['template']['favicons'] );
	// print_r( $ct['contatti'] );

    // timer
	timerCheck( $cf['speed'], 'fine ricerca favicons' );

	// log
	loggerLatest( 'fine ricerca favicons' );

    /**
     * costruzione degli elementi di navigazione
     * =========================================
     * 
     * 
     * costruzione dei menu
     * --------------------
     * 
     * 
     * costruzione delle briciole di pane
     * ----------------------------------
     * 
     * 
     * costruzione del selettore multilingua
     * -------------------------------------
     * 
     * 
     * 
     */

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
	loggerLatest( 'fine generazione elementi secondari di navigazione' );

    /**
     * ricerca delle risorse minificate
     * ================================
     * 
     * 
     * 
     */

    // debug
	// print_r( $ct['page']['template'] );
	// $tms = array_keys( $cf['speed'] );
	// $run = end( $tms );
	// echo 'corsa: ' . $run;
	// die( 'float: ' . floatval( str_replace( ',', '.', $run ) ) );
    // die( print_r( $ct['page']['css'], true ) );

    // ricerca delle risorse CSS minificate
	if( isset( $ct['page']['css'] ) && is_array( $ct['page']['css'] ) ) {
	    foreach( $ct['page']['css'] as $tier => $media ) {
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
            if( is_array( $media ) ) {
                foreach( $media as $sheets ) {
                    if( is_array( $sheets ) ) {
                        foreach( $sheets as $css ) {
                            if( strpos( $css, '.min.css' ) === false ) {
                                $new = str_replace( '.css', '.min.css', $css );
                                if( fileCachedExists( $cf['memcache']['connection'], $pre . $new ) ) {
                                    logger( $new . ' trovato, consolidarlo nella configurazione', 'speed', LOG_WARNING );
                                    $css = $new;
                                }
                            }
                        }
                    } else {
                        // echo $sheets . PHP_EOL;
                    }
                }
            }
	    }
	}

    // debug
    // die( print_r( $ct['page']['css'], true ) );

    // timer
	timerCheck( $cf['speed'], 'fine ricerca CSS minificati' );

	// log
	loggerLatest( 'fine ricerca CSS minificati' );

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
                        logger( $new . ' trovato, consolidarlo nella configurazione', 'speed', LOG_WARNING );
                        $js = $new;
                    }
				}
			}
	    }
	}

    // timer
	timerCheck( $cf['speed'], 'fine ricerca JS minificati' );

	// log
	loggerLatest( 'fine ricerca JS minificati' );

    // debug
    // die( print_r( $ct['page']['css'], true ) );

    /**
     * caching locale delle risorse esterne
     * ====================================
     * 
     * 
     * 
     * 
     */

    // caching locale dei CSS esterni
    if( isset( $ct['page']['css']['external'] ) && is_array( $ct['page']['css']['external'] ) ) {
        foreach( $ct['page']['css']['external'] as $media => $sheets ) {
            if( is_array( $sheets ) ) {
                foreach( $sheets as $css ) {
                    $content = file_get_contents( $css );
                    $cachefile = DIR_VAR_CACHE . 'css/' . str_replace( array( 'http://', 'https://' ), '', $css );
                    writeToFile( $content, $cachefile );
                    $ct['page']['css']['internal']['media'][] = shortPath( $cachefile );
                    unset( $css );
                }
            }
        }
    }

    /**
     * censura dell'array $ct
     * ======================
     * 
     * 
     */

    // debug
	// print_r( $ct['page'] );
	// print_r( $ct['contatti'] );
	// print_r( $ct['view']['open'] );
	// print_r( $cf['contents'] );
    // die( print_r( $ct['page']['css'], true ) );

    // censuro l'array $ct per evitare fughe accidentali di informazioni sensibili
	array2censored( $ct );

    // riordino l'array $ct ricorsivamente
	rksort( $ct );

    // timer
	timerCheck( $cf['speed'], 'fine censura e ordinamento array $ct' );

    /**
     * rendering del template
     * ======================
     * 
     * 
     * 
     */

    // inizio le operazioni di rendering del template se è specificato il tipo di template
	if( isset( $ct['page']['template']['type'] ) ) {

        // aggiungo all'output le informazioni su GlisWeb
		echo PHP_EOL . '<!-- sito realizzato tramite GlisWeb framework (https://glisweb.istricesrl.it) -->' . PHP_EOL;

        // aggiungo all'output l'ID della pagina
        echo PHP_EOL . '<!-- ID pagina: ' . $ct['page']['id'] . ' -->' . PHP_EOL;

        // aggiungo all'output il percorso del template
        if( ! empty( $ct['page']['template']['path'] ) ) {
			echo PHP_EOL . '<!-- template: ' . $ct['page']['template']['path'] . ' -->' . PHP_EOL;
		}

        // aggiungo all'output lo schema del template
		if( ! empty( $ct['page']['template']['schema'] ) ) {
			echo PHP_EOL . '<!-- schema: ' . $ct['page']['template']['schema'] . ' -->' . PHP_EOL;
		}

        // aggiungo all'output il tema del template
		if( ! empty( $ct['page']['template']['theme'] ) ) {
			echo PHP_EOL . '<!-- tema: ' . $ct['page']['template']['theme'] . ' -->' . PHP_EOL;
		}

        // aggiungo all'output l'uso della cache
        if( ! empty( $cf['contents']['cached'] ) ) {
            echo '<!-- struttura delle pagine trovata in cache -->';
        } else {
            echo '<!-- struttura delle pagine NON trovata in cache -->';
        }

        // aggiungo all'output una riga vuota
		echo PHP_EOL;

        // aggiungo all'output le macro incluse
        foreach( $includes as $include ) {
			echo '<!-- macro: ' . $include . ' -->' . PHP_EOL;
		}

        // rendering del template in base al tipo
		switch( $ct['page']['template']['type'] ) {

            case 'twig':

                // timer
                timerCheck( $cf['speed'], '-> inizio operazioni di rendering' );

                // log
                logger( 'template per la pagina ' . $ct['page']['template']['path'], 'template' );

                // avvio di Twig
                $loader = new \Twig\Loader\FilesystemLoader( DIR_BASE . $ct['page']['template']['path'] );

                // timer
                timerCheck( $cf['speed'], '-> -> caricamento template' );

                // log
                loggerLatest( 'fine caricamento template Twig ' . $ct['page']['template']['path'] );

                // debug
                // print_r( $cf['twig']['profile'] );
                // print_r( $ct['page']['template']['path'] );
                // print_r( $ct['page']['template']['paths'] );

                // altri file da includere
                $ct['page']['template']['paths'] = array_replace_recursive(
                    ( isset( $ct['page']['template']['paths'] ) ) ? $ct['page']['template']['paths'] : array(),
                    array_unique( glob( glob2custom( DIR_MOD_ATTIVI . $ct['page']['template']['path'] ), GLOB_BRACE ) )
                );

                // aggiungo la versione locale del template
                if( file_exists( DIR_BASE . path2custom( $ct['page']['template']['path'] ) ) ) {
                    $ct['page']['template']['paths'][] = DIR_BASE . path2custom( $ct['page']['template']['path'] );
                }

                // ordinamento degli elementi aggiunti
                // TODO questo ordinamento serve a qualcosa?
                sort( $ct['page']['template']['paths'] );

                // aggiungo i percorsi al template manager
                foreach( $ct['page']['template']['paths'] as $add ) {
                    $loader->prependPath( $add );
                }

                // log
                logger( 'path dei template aggiuntivi: ' . implode( ', ', $ct['page']['template']['paths'] ), 'twig' );

                // log
                loggerLatest( 'fine inserimento dei path aggiuntivi in Twig: ' . implode( ', ', $ct['page']['template']['paths'] ) );

                // debug
                // print_r( $cf['twig']['profile'] );
                // print_r( $ct['page']['template']['path'] );
                // print_r( $ct['page']['template']['paths'] );

                // aggiungo il percorso con le macro standard e custom
                // TODO considerare anche 'src/html/' e '_mod/.../_src/_html/' e 'mod/.../src/html/'
                if( file_exists( DIR_SRC_HTML ) ) {
                    $loader->addPath( DIR_SRC_HTML );
                    if( file_exists( path2custom( DIR_SRC_HTML ) ) ) {
                        $loader->addPath( path2custom( DIR_SRC_HTML ) );
                    }
                }

                // aggiungo il percorso con le macro standard e custom
                // TODO considerare anche 'src/twig/' e '_mod/.../_src/_twig/' e 'mod/.../src/twig/'
                if( file_exists( DIR_SRC_TWIG ) ) {
                    $loader->addPath( DIR_SRC_TWIG );
                    if( file_exists( path2custom( DIR_SRC_TWIG ) ) ) {
                        $loader->addPath( path2custom( DIR_SRC_TWIG ) );
                    }
                }

                // log
                loggerLatest( 'fine inserimento dei path custom aggiuntivi in Twig' );

                // ambiente
                $twig = new \Twig\Environment( $loader, $cf['twig']['profile'] );

                // timer
                timerCheck( $cf['speed'], '-> -> creazione ambiente Twig' );

                // log
                loggerLatest( 'fine creazione ambiente Twig' );

                // estensioni
                $twig->addExtension( new \Twig\Extension\StringLoaderExtension() );

                // timer
                timerCheck( $cf['speed'], '-> -> estensioni Twig' );

                // log
                loggerLatest( 'fine inclusione estensioni Twig' );

                // debug
                // print_r( $ct['page'] );
                // print_r( $ct['contatti'] );

                // renderizzo lo schema corrente
                try {
                    $html = $twig->render( $ct['page']['template']['schema'], $ct );
                } catch( \Exception $e ) {
                    die( $e->getMessage() );
                }

                // timer
                timerCheck( $cf['speed'], '-> fine render template' );

                // log
                loggerLatest( 'fine render template Twig' );

                // headers
                if( isset( $ct['page']['headers'] ) ) {
                    foreach( $ct['page']['headers'] as $header ) {
                        header( $header );
                    }
                }

                // output
                build( $html, MIME_TEXT_HTML, ENCODING_UTF8, ( ( isset( $ct['page']['headers'] ) ) ? $ct['page']['headers'] : array() ) );

                // timer
                timerCheck( $cf['speed'], '-> fine build output' );

            break;

            default:

                // log
                logger( 'tipo di template sconosciuto: ' . $ct['page']['template']['type'], 'template', LOG_CRIT );

            break;

	    }

	} elseif( empty( $ct['page']['template']['type'] ) ) {

	    // log
		logger( 'tipo di template non specificato', 'template' );

        // debug
        die( 'tipo di template non specificato' );

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
    // die( print_r( $ct['page']['css'], true ) );

    /**
     * invio del codice di stato HTTP
     * ==============================
     * 
     * 
     */

    // codice di stato HTTP
	// TODO verificare che questa funzione possa essere effettivamente chiamata qui
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
	loggerLatest( 'fine invio headers HTTP' );

    /**
     * gestione dei parametri di una lettera
     * =====================================
     * 
     * 
     * TODO documentare i parametri a una sola lettera (sono nei Google Docs?)
     * 
     * 
     */

	// i parametri di una lettera sono riservati a DEV e TEST
	if( SITE_STATUS != PRODUCTION ) {

		// rivelazione dei dati
		if( isset( $_REQUEST['u'] ) && is_array( $_REQUEST['u'] ) ) {
            $blocks = $_REQUEST['u'];
        } elseif( isset( $_REQUEST['u'] ) ) {
            $blocks = explode( '/', $_REQUEST['u'] );
        }

        // ...
        if( isset( $blocks ) && is_array( $blocks ) ) {
            $tpu = $ct;
			foreach( $blocks as $tu ) {
				if( isset( $tpu[ $tu ] ) ) {
					$tpu = $tpu[ $tu ];
				}
			}
			echo '<!-- DUMP CT: ' . implode( ' / ', $blocks ) . PHP_EOL . print_r( $tpu, true ) . ' -->';
		}

		// debug
		// print_r( $cf );

	}

    // timer
	timerCheck( $cf['speed'], 'fine gestione parametri di una lettera' );

	// log
	loggerLatest( 'fine gestione parametri di una lettera' );

    /**
     * pulizia dell'output
     * ===================
     * 
     * 
     * 
     * 
     */

    // fine del buffer
    $html = ob_get_clean();

    // specifiche di formattazione
    $config = array(
        'indent'                 => true,
        'drop-empty-elements'    => false,
        'output-html'            => true,
        'wrap'                   => 0
    );
    
    // Tidy
    // https://api.html-tidy.org/tidy/quickref_5.6.0.html
    $tidy = new tidy;
    $tidy->parseString( $html, $config, 'utf8' );
    $tidy->cleanRepair();

    // output
    echo $tidy;

    // output
	echo PHP_EOL;

    /**
     * gestione cache statica delle pagine
     * ===================================
     * 
     * NOTA per Nginx si veda https://www.ryadel.com/nginx-reverse-proxy-cache-wordpress-apache-iis-windows/
     * 
     */

    // se è attiva la cache delle pagine
    if( isset( $cf['cache']['profile']['pages'] ) && $cf['cache']['profile']['pages'] === true ) {

        // cache del buffer
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
        echo PHP_EOL . '<!-- sessione: ' . session_id() . ' -->' . PHP_EOL;


        // timer
        timerCheck( $cf['speed'], 'fine gestione cache statica delle pagine' );

        // log
        loggerLatest( 'fine gestione cache statica delle pagine' );

    }

    // output
    echo PHP_EOL;

    /**
     * flush dell'output buffer
     * ========================
     * 
     * 
     */

    // fine del buffer
	ob_end_flush();

    // timer
	timerCheck( $cf['speed'], 'fine esecuzione framework' );

	// log
	loggerLatest( 'fine esecuzione framework' );

    // debug
    // print_r( $ct['page']['css'] );

    /**
     * chiusura del monitoraggio tempi
     * ===============================
     * 
     * 
     */

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
