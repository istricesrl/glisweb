<?php

    /**
     * configurazione dinamica della localizzazione
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

    // linguaggio gestito di default
    // TODO ha senso questa cosa, visto che poi più avanti $_SESSION viene azzerato?
    // TODO dov'è che viene usata $_SESSION['__view__']['__language__'] e perché?
	if( empty( $_SESSION['__view__']['__language__'] ) && ! empty( $cf['localization']['language']['id'] ) ) {
	    $_SESSION['__view__']['__language__'] = $cf['localization']['language']['id'];
#	    $_SESSION['__view__']['__ietf__'] = $cf['localization']['language']['ietf'];
	}

    // debug
	// print_r( $cf['localization'] );
	// print_r( $cf['localization']['languages'] );
	// print_r( $cf['localization']['language'] );

?>
