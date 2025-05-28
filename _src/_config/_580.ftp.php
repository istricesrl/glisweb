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
     * TODO documentare
     *
     *
     */

    /**
     * definizione dei server
     * ======================
     * 
     * 
     */

    // server disponibili
	$cf['ftp']['servers']				= array();

    /**
     * definizione dei profili
     * =======================
     * 
     * 
     */

    // profili di funzionamento
	$cf['ftp']['profiles'][ DEVELOPEMENT ]		=
	$cf['ftp']['profiles'][ TESTING ]		=
	$cf['ftp']['profiles'][ PRODUCTION ]		= array();

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r( $cf['contents']['page'] );
	// print_r( $ct['page'] );
