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
             'prodotti' => array(
                CONTROL_FULL => array( 'roots' ),              
                CONTROL_FILTERED => array( 'staff' )
            ),
            'articoli' => array(
                CONTROL_FULL => array( 'roots' ),              
                CONTROL_FILTERED => array( 'staff' )
            ),
#            'coupon' => array(
#                CONTROL_FULL => array( 'roots' ),
#                CONTROL_FILTERED => array( 'staff' )
#            ),
            'prezzi' => array(
                CONTROL_FULL => array( 'roots' )
            ),          
            'prodotti_categorie' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'prodotti_caratteristiche' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'articoli_caratteristiche' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            'tipologie_prodotti' => array(
                CONTROL_FULL => array( 'roots' ),
                METHOD_GET => array( 'staff' )
            ),
            'udm' => array(
                CONTROL_FULL => array( 'roots' ),
                METHOD_GET => array( 'staff' )
            ),
            'listini' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);
