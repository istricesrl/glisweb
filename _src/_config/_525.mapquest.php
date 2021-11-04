<?php

    /**
     * server e profili Mapquest
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
	$cf['mapquest']['profile']			= &$cf['mapquest']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( ! empty( $cf['mapquest']['profile']['servers'] ) ) {
	    $cf['mapquest']['server']		= &$cf['mapquest']['servers'][ current( $cf['mapquest']['profile']['servers'] ) ];
	} else {
        $cf['mapquest']['server']			= NULL;
    }
