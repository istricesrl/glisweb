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
            'corrispondenza' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' ),
                METHOD_GET => array( 'users' )
            ),
            'atti' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' ),
                METHOD_GET => array( 'users' )
            ),
            'pesi' => array(
                CONTROL_FULL => array( 'roots' ),
                METHOD_GET => array( 'staff' )
            ),
            'formati' => array(
                CONTROL_FULL => array( 'roots' ),
                METHOD_GET => array( 'staff' )
            )
	    )
	);
