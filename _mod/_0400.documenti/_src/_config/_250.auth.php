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
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'documenti_articoli' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'relazioni_documenti_articoli' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'pagamenti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'proforma' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fatture_attive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_fatture_attive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_proforma' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fatture' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_fatture' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'fatture_passive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'righe_fatture_passive' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'ddt' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'ddt_attivi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'ddt_passivi' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'note_credito' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'relazioni_documenti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'ordini' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ordini_attivi' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'ordini_passivi' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);
