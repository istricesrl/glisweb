<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // verifico se è presente una pagina
	if( isset( $cf['contents']['page']['metadata']['id_notizia'] ) && ! empty( $cf['contents']['page']['metadata']['id_notizia'] ) && isset( $cf['localization']['language']['id'] ) ) {

		    // array delle immagini
			$pub = mysqlQuery( $cf['mysql']['connection'],
			    'SELECT pubblicazione.* FROM pubblicazione '
			    .'WHERE pubblicazione.id_notizia = ? ORDER BY pubblicazione.timestamp_pubblicazione ',
			    array( array( 's' => $cf['contents']['page']['metadata']['id_notizia'] ) ) );

		    // ciclo per le immagini
			foreach( $pub as $p ) {
			    $cf['contents']['page']['pubblicazione'][ $p['ordine'] ][ $p['id'] ] = $p;
			}


    }
