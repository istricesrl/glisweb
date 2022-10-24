<?php

    /**
     * configurazione dinamica della localizzazione
     *
     * il concetto di index
     * ====================
     * Per le entità prelevate dal database, occorre spesso una tabella di trascodifica che consenta di risalire all'ID
     * dell'oggetto nel framework partendo dall'ID dello stesso oggetto nel database e viceversa. Per questo molte factory
     * del framework prevedono una chiave 'index' che svolge esattamente questo compito.
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @file
     *
     */

    // indice degli ID delle lingue
	$cf['localization']['index'] = array();

    // dati delle lingue attive in base alla tabella lingue
	if( ! empty( $cf['mysql']['connection'] ) ) {

	    foreach( $cf['localization']['languages'] as &$l ) {

		$c = mysqlSelectCachedRow(
		    $cf['memcache']['connection'],
		    $cf['mysql']['connection'],
		    'SELECT * FROM lingue_view WHERE ietf = ?',
		    array( array( 's' => $l['ietf'] ) )
		);

		if( is_array( $c ) ) {
		    $l = array_replace_recursive( $l, $c );
		    $cf['localization']['index'][ $c['id'] ] = $l['ietf'];
		}

	    }

	    unset( $l );

	}

    /*
     * @todo ha senso questa cosa, visto che poi più avanti $_SESSION viene azzerato?
     * @todo dov'è che viene usata $_SESSION['__view__']['__language__'] e perché?
     */

    // linguaggio gestito di default
	if( empty( $_SESSION['__view__']['__language__'] ) && ! empty( $cf['localization']['language']['id'] ) ) {
	    $_SESSION['__view__']['__lang__'] = $cf['localization']['language']['id'];
	    $_SESSION['__view__']['__ietf__'] = $cf['localization']['language']['ietf'];
	}

    // debug
	// print_r( $cf['localization'] );
	// print_r( $cf['localization']['languages'] );
	// print_r( $cf['localization']['language'] );
    // echo 'OUTPUT';
