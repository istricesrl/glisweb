<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // configurazione extra
	if( isset( $cx['ecommerce'] ) ) {
	    $cf['ecommerce'] = array_replace_recursive( $cf['ecommerce'], $cx['ecommerce'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['ecommerce'] ) ) {
	    $cf['ecommerce'] = array_replace_recursive( $cf['ecommerce'], $cf['site']['ecommerce'] );
	}

    // collegamento all'array $ct
	$ct['ecommerce']					            = &$cf['ecommerce'];

    // link al profilo corrente
	$cf['ecommerce']['profile']			        = &$cf['ecommerce']['profiles'][ $cf['site']['status'] ];

    // provider di pagamento ammessi
    if( isset( $cf['ecommerce']['profile']['provider'] ) && is_array( $cf['ecommerce']['profile']['provider'] ) ) {
        $cf['ecommerce']['fields']['carrello']['provider_pagamento']['values'] = array_keys( $cf['ecommerce']['profile']['provider'] );
    }
