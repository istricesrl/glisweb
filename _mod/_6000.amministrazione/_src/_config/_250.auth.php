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
        'documenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
		'mastri' => array(
		    CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'documenti_articoli' => array(
		    CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        )
        )
	);
