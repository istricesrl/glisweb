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
            'ticket' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ticket_archiviati' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ticket_attivi' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ticket_gestiti' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ticket_chiusi' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
// NOTA i permessi per le todo sono già definiti nel modulo todo
//            ),
//            'todo' => array(
//                CONTROL_FULL => array( 'roots' ),
//                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);
