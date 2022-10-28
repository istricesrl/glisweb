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
        'audit' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'controlli' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'questionari' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'questionari_domande' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'risposte' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'opzioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        )
        )
	);