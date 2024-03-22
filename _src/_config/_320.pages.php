<?php

    /**
     * elaborazione dei dati delle pagine
     *
     * elaborazione della struttura dei contenuti
     * ==========================================
     * 
     *
     *
     *
     *
     *
     * l'albero delle pagine
     * ---------------------
     * 
     *
     *
     *
     * l'indice dei riferimenti
     * ------------------------
     * 
     *
     *
     *
     *
     *
     *
     * briciole di pane e percorsi
     * ---------------------------
     * 
     *
     *
     *
     *
     *
     *
     * logica della cache per la struttura dei contenuti
     * -------------------------------------------------
     * 
     *
     *
     *
     *
     *
     * @todo documentare
     * @todo documentare bene come funziona la cache relativamente alle pagine
     * @todo salvare in cache il rewriteIndex e il tree
     * @todo la funzione rewritePath() viene chiamata per pagine che hanno già un path!
     *
     * @file
     *
     */

    // scrittura della cache
    // TODO perché questa cosa viene fatta qui? vedi _320.pages.php
    /* NOTA 30/01/2019 per ora provo a commentarla, poi vediamo
	if( $cf['contents']['cacheable']['pages'] == true ) {
	    $cf['contents']['cacheable']['pages'] = false;
	    memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_DATA, $cf['contents']['pages'] );
	}
    */

    // tento di leggere i valori dalla cache
#11	$cf['contents']['tree']			= memcacheRead( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
#11	$cf['contents']['index']		= memcacheRead( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
#11	$cf['contents']['shortcuts']		= memcacheRead( $cf['memcache']['connection'], CONTENTS_SHORTCUTS_KEY );

    // controllo se la cache è aggiornata in base a $cf['contents']['updated']
	// TODO

    // debug
	// echo '310 STANDARD BEFORE' . PHP_EOL;
	// print_r( $cf['contents']['pages'][ NULL ] );

    // elaboro l'albero dei contenuti
#11	if( $cf['contents']['tree'] === false || $cf['contents']['index'] === false || $cf['contents']['shortcuts'] === false || defined( 'MEMCACHE_REFRESH' ) ) {
	if( $cf['contents']['cached'] === false || defined( 'MEMCACHE_REFRESH' ) ) {

	    // inizializzo l'albero
		$cf['contents']['tree']			= array();

	    // inizializzo l'indice
		$cf['contents']['index']		= array();

	    // inizializzo le shortcuts
		$cf['contents']['shortcuts']		= array();

	    // preparo le pagine
		foreach( $cf['contents']['pages'] as $k => &$v ) {

		    // aggiungo l'id pagina
			$v['id'] = $k;

		    // aggiungo l'id sito
			if( ! isset( $v['id_sito'] ) ) { $v['id_sito'] = SITE_DEFAULT; }

		    // controllo preliminare parent
			if( isset( $v['parent'] ) && is_array( $v['parent'] ) && array_key_exists( 'id', $v['parent'] ) ) {

# echo $v['id'].PHP_EOL;

			    // controllo parent
				if( ! isset( $cf['contents']['pages'][ $v['parent']['id'] ] ) ) { $v['parent']['id'] = NULL; }

			    // imposto l'array dell'albero locale
				$v['tree'] = array( $k => array() );

			    // aggancio al genitore
				if( isset( $v['parent']['id'] ) ) {
				    $cf['contents']['pages'][ $v['parent']['id'] ]['children']['id'][] = $k;
                    if( isset( $v['ordine'] ) && ! empty( $v['ordine'] ) ) {
                        $cf['contents']['pages'][ $v['parent']['id'] ]['children']['ordered'][ $v['ordine'] ] = $k;
                    }
				}

			    // registro la scorciatoia o l'alias
				if( isset( $v['short'] ) && ! empty( $v['short'] ) ) {
# print_r( $v['short'] );
				    foreach( $v['short'] as $short ) {
					if( ! empty( $short ) ) {
# echo 's->'.$short;
					    $cf['contents']['shortcuts'][ $short ] = $v['id'];
					}
				    }
#X				} elseif( isset( $v['forced'] ) && ! empty( $v['forced'] ) ) {
				}

/*
				if( isset( $v['forced'] ) && ! empty( $v['forced'] ) ) {
# print_r( $v['forced'] );
				    foreach( $v['forced'] as $forced ) {
					if( ! empty( $forced ) ) {
# echo 'f->'.$forced;
					    $cf['contents']['shortcuts'][ $forced ] = $v['id'];
					}
				    }
				}
*/

			    // per ogni lingua attiva
				foreach( $cf['localization']['languages'] as $lk => $lv ) {

				    // defaults
					if( ! isset( $v['title'][ $lk ] ) ) { $v['title'][ $lk ] = NULL; }
					if( ! isset( $v['h1'][ $lk ] ) ) { $v['h1'][ $lk ] = NULL; }

				    // stabilisco quale chiave usare per il rewrite
					if( ! isset( $v['rewrited'] ) || ! is_array( $v['rewrited'] ) || ! array_key_exists( $lk, $v['rewrited'] ) ) {
					    $v['rewrited'][ $lk ] = string2rewrite(
						( isset( $v['custom'][ $lk ] ) && ! empty( $v['custom'][ $lk ] ) )
						?
						$v['custom'][ $lk ]
						:
						$v['title'][ $lk ]
					    );
					}

				    // inserisco la pagina corrente nell'indice
					$cf['contents']['index'][ $lk ][ $v['rewrited'][ $lk ] ][] = $k;

				    // debug
					// echo $v['rewrited'][ $lk ] . PHP_EOL;

				}

			} else {

			    // errore fatale nella struttura delle pagine

			    // log
				logWrite( 'la pagina ' . $k . ' è malformata e blocca la costruzione della struttura', 'pages', LOG_EMERG );

			    // debug
				die( 'PAGINA MALFORMATA: ' . $k . ' -> ' . print_r( $v, true ) );

			}

		}

	    // debug
		// echo '310 STANDARD BEFORE - 1' . PHP_EOL;
		// print_r( $cf['contents']['pages'][ NULL ] );

	    // timer
		timerCheck( $cf['speed'], '-> fine preparazione pagine' );

	    // creo l'albero
		foreach( $cf['contents']['pages'] as $k => &$v ) {

		    // debug
			// echo $k . PHP_EOL;

		    // controllo se tutti i parent hanno gli stessi menu
			$menu = array();
			if( isset( $v['menu'] ) && is_array( $v['menu'] ) ) {
			    $menu = array_keys( $v['menu'] );
			}

		    // risalgo la struttura per creare il percorso fino alla pagina
		    // TODO a cosa serve questo?!?
			do {
			    $k = $cf['contents']['pages'][ $k ]['parent']['id'];
			    $v['tree'] = array( $k => $v['tree'] );
			    $v['parents']['id'][] = $k;
			    $v['parents']['h1'][] = $cf['contents']['pages'][ $k ]['h1'];
			    $v['parents']['title'][] = $cf['contents']['pages'][ $k ]['title'];
			    $v['parents']['rewrited'][] = $cf['contents']['pages'][ $k ]['rewrited'];
			    if( isset( $cf['contents']['pages'][ $k ]['menu'] ) && is_array( $cf['contents']['pages'][ $k ]['menu'] ) ) {
				$parentMenu = array_keys( $cf['contents']['pages'][ $k ]['menu'] );
			    } else {
				$parentMenu = array();
			    }
			    // TODO questa cosa serve a creare le voci vuote di menù che poi diventano elementi di lista vuoti
			    // in cui nidificare le sotto voci (serve nel caso in cui venga piazzata una voce in un menù a livello
			    // superiore al primo, per evitare che debbano essere creati a mano gli elementi superiori
			    // TUTTAVIA la mia sensazione è che generi inefficenze e in alcuni casi bug (fa apparire voci vuote
			    // in menù dove non ha senso che appaiano...) insomma VA TESTATA E DOCUMENTATA MEGLIO
			    if( is_array( $menu ) && is_array( $parentMenu ) ) {
				foreach( array_diff( $menu, $parentMenu ) as $manca ) {
				    $cf['contents']['pages'][ $k ]['menu'][ $manca ][] = array(
					'label' => NULL,
					'priority' => 'AUTO'
				    );
				}
			    }
			} while( $k !== NULL );

		    // capovolgo l'array dei parents
			$v['parents']['id']		= array_reverse( $v['parents']['id'] );
			$v['parents']['h1']		= array_reverse( $v['parents']['h1'] );
			$v['parents']['title']		= array_reverse( $v['parents']['title'] );
			$v['parents']['rewrited']	= array_reverse( $v['parents']['rewrited'] );

		    // aggiungo la pagina corrente al percorso completo della pagina
			$v['parents']['id'][]		= $v['id'];
			$v['parents']['h1'][]		= $v['h1'];
			$v['parents']['title'][]	= $v['title'];
			$v['parents']['rewrited'][]	= $v['rewrited'];

		    // copio i dati del parent
			$v['parent']['title']		= $cf['contents']['pages'][ $v['parent']['id'] ]['title'];
			$v['parent']['h1']		= $cf['contents']['pages'][ $v['parent']['id'] ]['h1'];
			$v['parent']['rewrited']	= $cf['contents']['pages'][ $v['parent']['id'] ]['rewrited'];

		}

	    // debug
		// echo '310 STANDARD BEFORE - 2' . PHP_EOL;
		// print_r( $cf['contents']['pages'][ NULL ] );

	    // timer
		timerCheck( $cf['speed'], '-> fine costruzione albero' );

	    // creo i path
		foreach( $cf['contents']['pages'] as $k => &$v ) {

		    // per ogni lingua attiva
			foreach( $cf['localization']['languages'] as $lk => $lv ) {

			    // colonna
				$col			= array_column( $v['parents']['rewrited'], $lk );

			    // colonna pulita
				$tcol			= trimArray( $col );

			    // percorso
				$path			= implode( '/', $tcol ) . ( ( ! empty( $tcol ) ) ? '.' . $lk . '.html' : NULL );

			    // calcolo il percorso della pagina corrente
				if( isset( $v['forced'][ $lk ] ) ) {
				    $v['path'][ $lk ]	= NULL;
				} elseif( empty( $v['title'][ $lk ] ) ) { // NOTA aggiunta di recente, controllare che non dia problemi
				    $v['path'][ $lk ]	= NULL;
				} else {
				    $v['path'][ $lk ]	= $cf['site']['root'] . $path;
				}

			    // calcolo l'URL della pagina corrente
				if( isset( $v['forced'][ $lk ] ) ) {
				    $v['url'][ $lk ]	= $v['forced'][ $lk ];
				} else {
// TODO anziché usare genericamente $cf['site']['url'], usare (se specificato) il dominio specifico per la lingua del ciclo corrente
// NOTA dovrebbe essere valorizzato ad es. $cf['site']['default']['urls']['it-IT'][PROD] (o qualcosa di simile?)
				    $v['url'][ $lk ]	= $cf['site']['url'] . $path;
#L				    $v['url'][ $lk ]	= $cf['site']['url'][ $lk ] . $path;
				}

			}

		    // aggiungo il percorso della pagina corrente all'albero
			$cf['contents']['tree']		= array_replace_recursive( $cf['contents']['tree'], $v['tree'] );

		}

	    // aggiungo i path dei parent
		foreach( $cf['contents']['pages'] as $k => &$v ) {

		    // risalgo la struttura per creare il percorso fino alla pagina
			do {
			    $k = $cf['contents']['pages'][ $k ]['parent']['id'];
			    $v['parents']['path'][] = $cf['contents']['pages'][ $k ]['path'];
			} while( $k !== NULL );

		    // capovolgo l'array dei parents
			$v['parents']['path']		= array_reverse( $v['parents']['path'] );

		    // aggiungo la pagina corrente al percorso completo della pagina
			$v['parents']['path'][]		= $v['path'];

		    // copio i dati del parent
			$v['parent']['path']		= $cf['contents']['pages'][ $v['parent']['id'] ]['path'];

		}

	    // scrittura della cache
#11		memcacheWrite( $cf['memcache']['connection'], CONTENTS_TREE_KEY, $cf['contents']['tree'] );
#11		memcacheWrite( $cf['memcache']['connection'], CONTENTS_INDEX_KEY, $cf['contents']['index'] );
#11		memcacheWrite( $cf['memcache']['connection'], CONTENTS_SHORTCUTS_KEY, $cf['contents']['shortcuts'] );
#		memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_KEY, $cf['contents']['pages'] );
#11		$cf['pages']['cacheable'] = true;

#11	} else {

#	    // lettura delle pagine dalla cache
#		$cf['contents']['pages']		= memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
#11		$cf['pages']['cacheable'] = false;

	    // log
#11		logWrite( 'contents (pages, tree e index) letti dalla cache', 'memcache', LOG_INFO );

	    // timer
		timerCheck( $cf['speed'], '-> fine generazione dei path dei parent' );

	}

    // debug
	// echo '310 STANDARD' . PHP_EOL;
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
	// print_r( $cf['localization']['language'] );
	// print_r( $cf['contents']['index'] );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// echo $cf['contents']['updated'];
	// print_r( $cf['contents']['pages'] );
	// print_r( $cf['contents']['pages'][ NULL ] );
