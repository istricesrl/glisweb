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
     * @todo documentare
     *
     * @file
     *
     */

    // array dei permessi
	$cf['auth']['permissions'] = array_merge_recursive( 
	    $cf['auth']['permissions'],
	    array(
            'crediti' => array(
                CONTROL_FULL => array( 'roots' )
            ),

            '__report_movimenti_crediti__' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
