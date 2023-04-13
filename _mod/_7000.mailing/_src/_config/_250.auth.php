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
            'mailing' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'mailing_mail' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'mailing_liste' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'liste' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'liste_mail' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);
