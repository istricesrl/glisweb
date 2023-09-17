<?php

    /**
     * server e profili FTP
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
	$cf['ftp']['profile']			= &$cf['ftp']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
	if( isset( $cf['ftp']['profile']['servers'] ) && is_array( $cf['ftp']['profile']['servers'] ) ) {
	    $cf['ftp']['server']		= &$cf['ftp']['servers'][ current( $cf['ftp']['profile']['servers'] ) ];
	}

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r($cf['ftp'] );
