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
            'immobili' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'immobili_anagrafica' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'edifici' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'menu' => array(
                CONTROL_FULL => array( 'roots' )
            )
	    )
	);
