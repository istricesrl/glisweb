<?php

    /**
     * server e profili Archivium
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

    // server disponibili
	$cf['archivium']['servers']			= array();

    // profili di funzionamento
	$cf['archivium']['profiles'][ DEVELOPEMENT ]		=
	$cf['archivium']['profiles'][ TESTING ]		=
	$cf['archivium']['profiles'][ PRODUCTION ]	= NULL;

    // configurazione extra
	if( isset( $cx['archivium'] ) ) {
	    $cf['archivium'] = array_replace_recursive( $cf['archivium'], $cx['archivium'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['archivium'] ) ) {
	    $cf['archivium'] = array_replace_recursive( $cf['archivium'], $cf['site']['archivium'] );
	}

    // collegamento all'array $ct
	$ct['archivium']					= &$cf['archivium'];
