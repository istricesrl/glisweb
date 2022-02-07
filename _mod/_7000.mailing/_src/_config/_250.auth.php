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
                CONTROL_FULL => array( 'roots' )
            ),
            'mailing_mail' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'mailing_liste' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'liste' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'liste_mail' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
