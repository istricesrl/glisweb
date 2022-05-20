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
            CONTROL_FULL => array( 'roots' )
        ),
        'certificazioni_archiviati' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'certificazioni_completa' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
		'anagrafica_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'progetti_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'valutazioni_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
