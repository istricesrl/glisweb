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

    // configurazione extra
	if( isset( $cx['registrazione'] ) ) {
	    $cf['registrazione'] = array_replace_recursive( $cf['registrazione'], $cx['registrazione'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['registrazione'] ) ) {
	    $cf['registrazione'] = array_replace_recursive( $cf['registrazione'], $cf['site']['registrazione'] );
	}

    // collego a $ct
    $ct['registrazione'] = &$cf['registrazione'];

    // debug
    // die( print_r( $cf['registrazione'] ) );