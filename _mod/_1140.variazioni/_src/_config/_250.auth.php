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
            'attivita_scoperte' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'periodi_variazioni_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_scoperti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'sostituzioni_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'tipologie_variazioni_attivita' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'variazioni_attivita' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
	    )
	);
