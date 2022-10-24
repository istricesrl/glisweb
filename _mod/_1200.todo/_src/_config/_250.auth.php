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
            'todo' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'todo_categorie' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'tipologie_todo' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_backlog_todo__' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_sprint_todo__' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_planned_todo__' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_done_todo__' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
