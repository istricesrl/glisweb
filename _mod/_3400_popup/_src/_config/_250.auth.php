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
		'popup' => array(
		    CONTROL_FULL => array( 'roots' )
//		),
//		'popup_pagine' => array(
//		    CONTROL_FULL => array( 'roots' )
//		),
//		'tipologie_popup' => array(
//		    CONTROL_FULL => array( 'roots' )
//		)
		)
	    )
	);

?>
