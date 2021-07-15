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
                CONTROL_FULL => array( 'roots' )
            ),
            'articoli' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'prezzi' => array(
                CONTROL_FULL => array( 'roots' )
            ),          
            'prodotti_categorie' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'prodotti_caratteristiche' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'articoli_caratteristiche' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'tipologie_prodotti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'udm' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'listini' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'reparti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'matricole' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            )
            )
	);
