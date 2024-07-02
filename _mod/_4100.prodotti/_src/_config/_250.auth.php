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
                CONTROL_FILTERED => array( 'staff' ),
                METHOD_GET => array( 'users' )
            ),
            'articoli' => array(
                CONTROL_FULL => array( 'roots' ),              
                CONTROL_FILTERED => array( 'staff' ),
                METHOD_GET => array( 'users' )
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
            'relazioni_prodotti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'relazioni_articoli' => array(
                CONTROL_FULL => array( 'roots' )
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
            ),
            'modalita_spedizione' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
        )
	);
