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

    // controllo cache
    if( $cf['contents']['cached'] === false ) {

        // log
        if( ! empty( $cf['memcache']['connection'] ) ) {
            logWrite( 'struttura delle pagine NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le pagine dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT pagine.* FROM pagine '.
            'INNER JOIN pubblicazione ON pubblicazione.id_pagina '.
            'WHERE id_sito = ? '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY pagine.id ',
            array(
                array( 's' => $cf['site'] ),
                array( 's' => time() )
            )
        );


    }
