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
            'mastri' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'magazzini' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'conti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'registri' => array(
                CONTROL_FULL => array( 'roots' ),
            ),
            '__report_mastri__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_giacenza_magazzini__' => array(
                CONTROL_FULL => array( 'roots', 'staff' )
            ),
            '__report_giacenza_magazzini_foglie__' => array(
                CONTROL_FULL => array( 'roots', 'staff' )
            ),
            '__report_giacenza_magazzini_foglie_attive__' => array(
                CONTROL_FULL => array( 'roots', 'staff' )
            ),
            '__report_movimenti_magazzini__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_giacenza_mastri__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_mastri_orari__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_giacenza_ore__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_movimenti_ore__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_giacenze_mastri_quantitativi_gerarchico__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ) ,
            '__report_mastri_articoli__' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);