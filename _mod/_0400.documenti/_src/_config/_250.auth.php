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
            'documenti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'mastri' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'documenti_articoli' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'pagamenti' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
