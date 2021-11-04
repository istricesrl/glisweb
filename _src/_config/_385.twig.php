<?php

    /**
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
	$cf['twig']['profile']				= &$cf['twig']['profiles'][ $cf['site']['status'] ];

    // controllo la cartella per la cache di Twig
	if( isset( $cf['twig']['profile']['cache'] ) ) {
	    fullPath( $cf['twig']['profile']['cache'] );
	    checkFolder( $cf['twig']['profile']['cache'] );
	}
