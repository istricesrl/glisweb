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
            'tesseramenti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'tesseramenti_attivi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'tesseramenti_archiviati' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
