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
        'cartellini' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'righe_cartellini' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
