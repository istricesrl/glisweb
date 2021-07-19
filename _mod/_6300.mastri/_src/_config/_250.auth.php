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
        '__report_mastri__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenza_mastri__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_mastri_orari__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenza_mastri_orari__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        )
        )
	);