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
            'abbonamenti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'abbonamenti_attivi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'abbonamenti_archiviati' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
