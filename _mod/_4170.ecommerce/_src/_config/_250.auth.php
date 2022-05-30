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
		'carrelli' => array(
            CONTROL_FULL => array( 'roots' )
		),
		'carrelli_articoli' => array(
            CONTROL_FULL => array( 'roots' )
		)
	    )
	);
