<?php

    /**
     * server e profili paypal
     *
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

    // configurazione extra
	if( isset( $cx['paypal'] ) ) {
	    $cf['paypal'] = array_replace_recursive( $cf['paypal'], $cx['paypal'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['paypal'] ) ) {
	    $cf['paypal'] = array_replace_recursive( $cf['paypal'], $cf['site']['paypal'] );
	}

    // collegamento all'array $ct
	$ct['paypal']					    = &$cf['paypal'];

    // link al profilo corrente
	$cf['paypal']['profile']			= &$cf['paypal']['profiles'][ $cf['site']['status'] ];
