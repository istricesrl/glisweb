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
            'attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'tipologie_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
