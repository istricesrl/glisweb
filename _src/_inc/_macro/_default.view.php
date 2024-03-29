<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );

    // innesco la GET
	// $_REQUEST['__view__'][ $ct['view']['id'] ] = array();

    // debug
	// print_r( $ct['page']['backurl'] );
/*
    // costruisco il backurl dall'id della backpage
	if( isset( $ct['view']['backpage'] ) ) {
	    $ct['view']['backurl'] = urlencode( $ct['pages'][ $ct['view']['backpage'] ]['url'][ $cf['localization']['language']['ietf'] ] . '?' . (
		( isset( $ct['etc']['table'] ) ) 
		? $ct['etc']['table'] . '[id]=' . $_REQUEST[ $ct['etc']['table'] ]['id'] . '&' . $ct['etc']['table'] . '[__method__]=get&__backurl__='
		: NULL
	    ) );
	}
*/

    // contatore per i campi della vista
	$i = 10;

    // campi della vista
	foreach( $ct['view']['cols'] as $field => $label ) {
	    $ct['view']['fields'][ $i ] = $field;
	    $i += 10;
	}

    // id della vista
	if( ! isset( $ct['view']['id'] ) ) {
	    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	    );
	}

	// filtri aggiuntivi
	if( isset( $_REQUEST['__filters__'] )  ) {
		if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = array_replace_recursive(
				$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'],
				$_REQUEST['__filters__']
			);
		} else {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = $_REQUEST['__filters__'];
		}
	}

	// filtri presettati
	if( isset( $ct['view']['__restrict__'] ) ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__restrict__'] = $ct['view']['__restrict__'];
	}

    // aggiungo le colonne da prelevare
	// $_REQUEST['__view__'][ $ct['view']['id'] ]['__fields__'] = array_keys( $ct['view']['cols'] );
	// $ct['view']['data']['__fields__'] = array_keys( $ct['view']['cols'] );
	$_REQUEST['__view__'][ $ct['view']['id'] ]['__fields__'] = array_keys( $ct['view']['cols'] );

#    // aggiungo i campi di filtro
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
#	    $ct['view']['data']['__filters__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'];
#	}

#    // aggiungo la ricerca
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) ) {
#	    $ct['view']['data']['__search__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'];
#	}

#    // aggiungo l'ordinamento
#	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
#	    $ct['view']['data']['__sort__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'];
#	}

    // imposto la paginazione
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['page'] = 0;
	}
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] = 20;
	}

#    // paginazione
#	$ct['view']['data']['__pager__'] = $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__'];

    // debug
	// print_r( $_REQUEST[ $ct['etc']['table'] ]['id'] );
	// print_r( $_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ] );
/*
    // 
	if( isset( $ct['etc']['table'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ] = array_replace_recursive(
		$_REQUEST['__view__'][ $ct['view']['id'] ],
		$_REQUEST['__view__'][ $ct['view']['id'] ][ $ct['page']['id'] . '_' . $_REQUEST[ $ct['etc']['table'] ]['id'] ]
	    );
	}
*/
    // debug
	// print_r( $filters );

    // prelevamento dei dati
	// controller( $cf['mysql']['connection'], $_REQUEST['__view__'][ $ct['view']['id'] ], $ct['view']['table'], METHOD_GET, NULL, $_REQUEST['__err__'][ $k ] );
	controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $ct['view']['data'], $ct['view']['table'], METHOD_GET, NULL, $_REQUEST['__err__'][ $ct['view']['id'] ], $_REQUEST['__view__'][ $ct['view']['id'] ] );
#print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]);
#print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]);
    // debug
	// echo 'dati: ' .  print_r( $ct['view']['data'], true );

    // campo di gestione di default
	if( ! isset( $ct['view']['open']['field'] ) ) {
	    $ct['view']['open']['field'] = 'id';
	}

    // tabella di gestione di default
	if( ! isset( $ct['view']['open']['table'] ) ) {
	    $ct['view']['open']['table'] = $ct['view']['table'];
	}

    // debug
	// echo $ct['view']['open']['table'] . PHP_EOL;

    // pagina di inserimento
	if( ! isset( $ct['view']['insert']['page'] ) && isset( $ct['view']['open']['page'] ) && ! isset( $ct['form']['table'] ) ) {
	    $ct['view']['insert']['page'] = $ct['view']['open']['page'];
	}

    // percorso della pagina di gestione
	if( isset( $ct['view']['open']['page'] ) && ! empty( $ct['view']['open']['page'] ) && ( getAclPermission( $ct['view']['table'], METHOD_PUT ) || getAclPermission( $ct['view']['table'], METHOD_GET ) ) ) {
//	if( isset( $ct['view']['open']['page'] ) && ! empty( $ct['view']['open']['page'] ) ) {
	    $ct['view']['open']['path'] = $cf['contents']['pages'][ $ct['view']['open']['page'] ]['path'][ $cf['localization']['language']['ietf'] ];
	}

    // percorso della pagina di inserimento
	if( isset( $ct['view']['insert']['page'] ) && ! empty( $ct['view']['insert']['page'] ) && getAclPermission( $ct['view']['table'], METHOD_POST ) ) {
//	if( isset( $ct['view']['insert']['page'] ) && ! empty( $ct['view']['insert']['page'] ) ) {
	    $ct['view']['insert']['path'] = $cf['contents']['pages'][ $ct['view']['insert']['page'] ]['path'][ $cf['localization']['language']['ietf'] ];
	}

    // debug
	// print_r( $_REQUEST['__view__'][ $ct['view']['id'] ] );
	// print_r( $_SESSION );
	// print_r( $_REQUEST );
	// var_dump( $ct['view']['table'] );
	// echo 'dati: ' .  print_r( $ct['view']['data'], true );
	// print_r( $_REQUEST['__err__'][ $k ] );
	// print_r( $ct['view']['data'] );
	// print_r( $ct['view']['open'] );
	// print_r( $ct['pages'] );
