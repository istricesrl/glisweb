<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo visto che $_SESSION è permanente, questa cosa andrebbe fatta solo se c'è un login in corso!
     * @todo verificare che questa cosa sia effettivamente utile
     * @todo documentare
     *
     * @file
     *
     */

    // TODO a cosa serve questa cosa?

    // array dei permessi per l'utente connesso
    // TODO questo è già valorizzato in _210.auth.php
	// $_SESSION['account']['permissions'] = array();

    // popolo l'array dei permessi
	if( $cf['auth']['status'] == LOGIN_SUCCESS ) {
	    if( isset( $_SESSION['account']['gruppi'] ) ) {
		foreach( $cf['auth']['permissions'] as $t => $w ) {
		    foreach( $w as $k => $j ) {
			if( array_intersect( $_SESSION['account']['gruppi'], $j ) ) {
			    $_SESSION['account']['permissions'][ $t ][] = $k;
			}
		    }
		}
	    }
	} elseif( isset( $_SESSION['account'] ) && ! empty( $_SESSION['account'] ) ) {
	    $cf['auth']['status'] = LOGIN_LOGGED;
	}

    // debug
	// print_r( $_SESSION['account'] );
	// print_r( $_SESSION['account']['permissions'] );
	// print_r( $cf['auth'] );
	// echo $cf['auth']['status'];
