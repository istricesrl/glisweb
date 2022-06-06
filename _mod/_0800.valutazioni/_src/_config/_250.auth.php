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
        'valutazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'valutazioni_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
