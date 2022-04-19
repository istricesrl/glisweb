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
            'iscrizioni' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'iscrizioni_attivi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'iscrizioni_archiviati' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
