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
            'corsi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'discipline' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fasce' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'livelli' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_iscritti_corsi__' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
