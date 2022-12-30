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
            'attivita' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            // TODO questa va nel modulo cartellini
            'cartellini' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'tipologie_attivita' => array(
                CONTROL_FULL => array( 'roots' ),
                METHOD_GET => array( 'staff' )
            )
        )
	);
