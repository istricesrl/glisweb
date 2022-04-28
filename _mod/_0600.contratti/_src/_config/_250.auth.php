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
        'contratti_anagrafica' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_attivi' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_archiviati' => array(
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
        'rinnovi' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
