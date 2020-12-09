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
	if( isset( $cf['contents']['page']['id'] ) && isset( $cf['localization']['language']['id'] ) ) {

	    // timer
		timerCheck( $cf['speed'], ' -> inizio preparazione contenuti specifici per pagina' );

        // prelevo i contenuti della pagina corrente dal database
        if( empty( $cf['contents']['page']['content'] ) ) {
            $cf['contents']['page']['content'][ $cf['localization']['language']['ietf'] ] =
            "{% import '_bin/_contents.html' as cnt %}\n\n".
            "{% import 'bin/default.html' as def %}\n\n".
            mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT testo FROM contenuti '.
            'WHERE id_pagina = ? AND id_lingua = ?',
            array(
                array( 's' => $cf['contents']['page']['id'] ),
                array( 's' => $cf['localization']['language']['id'] )
            )
            );
        }

    }
