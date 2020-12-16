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
        'contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'costi_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'orari_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_costi_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
