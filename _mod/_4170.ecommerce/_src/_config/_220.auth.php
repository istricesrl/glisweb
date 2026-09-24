<?php

    /**

     *
     * @todo documentare
     *
     * @file
     *
     */

    // intercetto eventuali tentativi di logout
	if( isset( $_REQUEST['__logout__'] ) ) {

        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE carrelli SET session = NULL WHERE session = ?',
            array(
                array( 's' => $cf['session']['id'] )
            )
        );

	}

    // debug
	// print_r( $cf['localization']['language'] );
