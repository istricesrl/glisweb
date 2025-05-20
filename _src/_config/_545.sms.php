<?php

    /**
     * server e profili SMS
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
	if( isset( $cx['sms'] ) ) {
	    $cf['sms'] = array_replace_recursive( $cf['sms'], $cx['sms'] );
	}

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

	// link al profilo corrente
	$cf['sms']['profile']			= &$cf['sms']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( isset( $cf['sms']['profile']['servers'] ) && is_array( $cf['sms']['profile']['servers'] ) ) {
	    $cf['sms']['server']		= &$cf['sms']['servers'][ current( $cf['sms']['profile']['servers'] ) ];
	} else {
	    $cf['sms']['server']		= NULL;
	}
