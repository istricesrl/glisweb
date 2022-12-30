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

    // TODO tutta 'sta roba non sta già nei rispettivi moduli?
    // array dei permessi
	$cf['auth']['permissions'] = array_merge_recursive( 
	    $cf['auth']['permissions'],
	    array(
        'contatti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'campagne' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'matricole' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        )
        )
	);
