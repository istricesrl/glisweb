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
	if( isset( $cf['contents']['page']['metadati']['id_annuncio'] ) && ! empty( $cf['contents']['page']['metadati']['id_annuncio'] ) && isset( $cf['localization']['language']['id'] ) ) {

		    // array delle immagini
			$pub = mysqlQuery( $cf['mysql']['connection'],
			    'SELECT pubblicazioni.* FROM pubblicazioni '
			    .'WHERE pubblicazioni.id_annuncio = ? ORDER BY pubblicazioni.timestamp_inizio ',
			    array( array( 's' => $cf['contents']['page']['metadati']['id_annuncio'] ) ) );

		    // ciclo per le immagini
			foreach( $pub as $p ) {
			    $cf['contents']['page']['pubblicazioni'][ $p['ordine'] ][ $p['id'] ] = $p;
			}


    }
