<?php

    /**
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function buildMenu( $menu, $tree, $pages, $active = NULL ) {

	// debug
	    // echo print_r( $pages, true );
	    // echo print_r( $tree, true );
	    // echo 'menu -> ' . $menu . PHP_EOL;

	// array del menu
	    $nav = array();

	// log
	    logWrite( 'elaboro il menu ' . $menu, 'menu' );

	// verifico che il livello richiesto dell'albero sia popolato
	    if( is_array( $tree ) ) {

		// log
		    logWrite( 'voci da elaborare per il menu ' . $menu . ': ' . count( $tree ), 'menu' );

		// costruisco le voci di menù per questo livello
		    foreach( $tree as $k => $v ) {

			// log
			    logWrite( 'elaboro la pagina ' . $k . ' per il menu ' . $menu, 'menu' );

			// debug
			    // echo 'page -> ' . $k . PHP_EOL;
			    // echo print_r( $pages[ $k ], true );

			// se la pagina compare nel menu...
			    if( isset( $pages[ $k ]['menu'][ $menu ] ) ) {

foreach( $pages[ $k ]['menu'][ $menu ] as $ak => $mv ) {

				// se la pagina ha un'etichetta per il menu... oppure?
				    if( ! empty( $mv['label'] ) || ( count( $v ) > 0 && in_array( $k, $pages[ $active ]['parents']['id'] ) ) ) {

					// se l'utente può visualizzare la pagina
					// TODO trovare un modo per visualizzare nel menu con un'opzione anche le pagine per cui è richiesto poi il login
					// @todo if( getPagePermission( $k ) )
					    if( ! isset( $pages[ $k ]['auth']['groups'] ) || ( isset( $_SESSION['account']['gruppi'] ) && count( array_intersect( $pages[ $k ]['auth']['groups'], $_SESSION['account']['gruppi'] ) ) > 0 ) || ( isset( $mv['visualizza'] ) && $mv['visualizza'] == SHOW_ALWAYS ) ) {

						// debug
						    // echo print_r( $mv, true );
						    // echo print_r( $mv['label'], true );
						    // echo $k . '/' . $active . PHP_EOL;
						    // print_r( $pages[ $k ]['parents']['id'] );
						    // echo  $k . '/' . $mv['priority'] . PHP_EOL;
						    // print_r( $pages[ $k ]['url'] );

						// costruisco la chiave per l'ordinamento
						    $key = $mv['priority'] . '|' . $k . '|' . $ak;

						// log
						    if( empty( $mv['label'] ) ) {
							logWrite( 'voce vuota: ' . $k . ' -> ' . $menu . ': ' . $key, 'menu', LOG_ERR );
						    }

						// costruisco la voce corrente
						$nav[ $key ] = array(
							'label' => $mv['label']
							,
							'ancora' => ( isset( $mv['ancora'] ) ) ? $mv['ancora'] : NULL
							,
//							'location' => ( ( isset( $pages[ $k ]['forced'] ) ) ? $pages[ $k ]['url'] : $pages[ $k ]['path'] )
// TODO questa soluzione non è soddisfacente in quanto non tiene conto del fatto che forced potrebbe contenere un valore in una lingua e non in un altra... come si può fare?
							'location' => ( ( isset( $pages[ $k ]['forced'] ) && ! isEmptyArray( $pages[ $k ]['forced'] ) ) ? $pages[ $k ]['url'] : $pages[ $k ]['path'] )
							,
							'target' => ( ( isset( $mv['target'] ) && ! empty( $mv['target'] ) ) ? $mv['target'] : NULL ) 
							,
							'active' => ( $k == $active ) ? true : false
							,
							'current' => ( in_array( $k, $pages[ $active ]['parents']['id'] ) ) ? true : false
						    );

						// log
						    logWrite( $k . ' -> ' . $menu . ': ' . $key, 'menu' );

						// debug
						    // echo $mv['subpages'] . PHP_EOL;

						// contenuto del sottomenù
						    if(
							count( $v ) > 0
							&& (
							    (
								in_array( $k, $pages[ $active ]['parents']['id'] )
								&& (
								    ! isset( $mv['subpages'] )
								    ||
								    $mv['subpages'] != 'NEVER_SHOW'
								)
							    )
							    ||
							    (
								isset( $mv['subpages'] )
								&&
								$mv['subpages'] == 'ALWAYS_SHOW'
							    )
							)
						    ) {
							logWrite( 'vado in ricorsione per ' . $k . ' -> ' . $menu, 'menu' );
							$nav[ $key ]['content'] = buildMenu( $menu, $v, $pages, $active );
						    }

					    } else {

						// log
						    logWrite( 'permessi insufficienti per visualizzare la pagina ' . $k . ' nel menu ' . $menu, 'menu' );

					    }

				    } else {

					// log
					    logWrite( 'la pagina ' . $k . ' non ha label nel menu ' . $menu . ' e non fa parte del path della pagina attiva', 'menu' );

				    }

				}

			    } else {

				// log
				    logWrite( 'la pagina ' . $k . ' non appartiene al menu ' . $menu, 'menu' );

			    }

		    }

	    } else {

		// log
		    logWrite( 'albero malformato (non è un array)', 'menu' );

	    }

	// riordino l'array
	    ksort( $nav, SORT_NATURAL );

	// debug
	    // print_r( $nav );

	// restituisco il risultato
	    return $nav;

    }

    /**
     *
     * @todo documentare
     *
     */
    function buildBreadcrumbs( $page, $active ) {

	// array del menu
	    $nav = array();

	// verifico che la pagina possieda un array dei parents
	    if( is_array( $page['parents'] ) ) {

		// costruisco le briciole di pane
		    foreach( $page['parents']['id'] as $k => $v ) {

			// se la pagina non è la radice
			    if( ! empty( $v ) ) {

				// costruisco la briciola
				    $nav[] = array(
					'location' => $page['parents']['path'][ $k ],
					'label' => $page['parents']['h1'][ $k ],
					'active' => ( $v == $active ) ? true : false
				    );

			    }

		    }

	    }

	// restituisco il risultato
	    return $nav;

    }

    /**
     *
     * @todo documentare
     *
     */
    function buildFlags( $page, $lang ) {

	// array del menu
	    $nav = array();

	// verifico che la pagina possieda un array dei parents
	    if( isset( $page['path'] ) && is_array( $page['path'] ) ) {

		// costruisco le bandiere per la selezione della lingua
		    foreach( $page['path'] as $k => $v ) {

			// costruisco la bandiera
			    $nav[] = array(
				'location' => $page['path'][ $k ],
				'country' => strtolower( substr( $k, strpos( $k, '-' ) + 1 ) ),
				'active' => ( $k == $lang ) ? true : false
			    );

		    }

		// log
		    logWrite( 'generate ' . count( $nav ) . ' bandiere per il cambio lingua', 'localization' );

	    } else {

		// log
		    logWrite( 'impossibile generare le bandiere per il cambio lingua', 'localization' );

	    }

	// restituisco il risultato
	    return $nav;

    }
