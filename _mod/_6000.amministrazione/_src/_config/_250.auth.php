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
            'proforma' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fatture' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fatture_passive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_proforma' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_fatture' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_fatture_passive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_amministrazione' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_amministrazione_archivio' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
