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
            'menu' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'pubblicazioni' => array(
                CONTROL_FULL => array( 'roots' )
    //		),
    //		'pagine_macro' => array(
    //		    CONTROL_FULL => array( 'roots' )
    //		),
    //		'pagine_metadati' => array(
    //		    CONTROL_FULL => array( 'roots' )
    //		),
    //		'pagine_gruppi' => array(
    //		    CONTROL_FULL => array( 'roots' )
            )
	    )
	);
