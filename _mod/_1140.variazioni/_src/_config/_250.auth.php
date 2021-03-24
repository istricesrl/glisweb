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
            'periodi_variazioni_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'sostituzioni_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'variazioni_attivita' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
	    )
	);
