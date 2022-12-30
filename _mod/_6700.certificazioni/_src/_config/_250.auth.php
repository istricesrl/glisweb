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
            'certificazioni' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'certificazioni_archiviati' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'certificazioni_completa' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'tipologie_certificazioni' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'anagrafica_certificazioni' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'progetti_certificazioni' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'valutazioni_certificazioni' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
	    )
	);
