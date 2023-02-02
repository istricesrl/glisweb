<?php

    /**
     * server e profili openai
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
	$cf['openai']['profile']			= &$cf['openai']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( ! empty( $cf['openai']['profile']['servers'] ) ) {
	    $cf['openai']['server']		= &$cf['openai']['servers'][ current( $cf['openai']['profile']['servers'] ) ];
	} else {
        $cf['openai']['server']			= NULL;
    }
