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
		'banner' => array(
		    CONTROL_FULL => array( 'roots' )
		),
		'banner_pagine' => array(
		    CONTROL_FULL => array( 'roots' )
		)
		'banner_zone' => array(
		    CONTROL_FULL => array( 'roots' )
		)
		)
	    )
	);
