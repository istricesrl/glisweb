<?php

    /**
     * server e profili Google
     *
     *
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

    // link al profilo corrente
	$cf['google']['profile']			= &$cf['google']['profiles'][ $cf['site']['status'] ];

    // CSP
    if( ! empty( $cf['google']['profile']['recaptcha'] ) ) {
        $ct['page']['csp']['script-src'][] = 'www.gstatic.com';
    }