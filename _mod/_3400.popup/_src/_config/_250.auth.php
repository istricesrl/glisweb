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
//        'pagine' => array(
//            CONTROL_FULL => array( 'roots' ),
//            CONTROL_FILTERED => array( 'staff' )
//        ),
		'popup' => array(
		    CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
		),
		'popup_pagine' => array(
		    CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
//		),
//		'tipologie_popup' => array(
//		    CONTROL_FULL => array( 'roots' )
//		)
		)
	    )
	);
