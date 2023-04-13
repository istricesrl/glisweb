<?php

    /**
     * server e profili SMTP
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
	$cf['smtp']['profile']			= &$cf['smtp']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( isset( $cf['smtp']['profile']['servers'] ) && is_array( $cf['smtp']['profile']['servers'] ) ) {
	    $cf['smtp']['server']		= &$cf['smtp']['servers'][ current( $cf['smtp']['profile']['servers'] ) ];
	}

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r($cf['smtp'] );
