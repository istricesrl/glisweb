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
        'pagine' => array(
            CONTROL_FULL => array( 'roots' )
        ),
		'popup' => array(
		    CONTROL_FULL => array( 'roots' )
		),
		'popup_pagine' => array(
		    CONTROL_FULL => array( 'roots' )
//		),
//		'tipologie_popup' => array(
//		    CONTROL_FULL => array( 'roots' )
//		)
		)
	    )
	);
