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
//            'prodotti_stagioni' => array(
//                CONTROL_FULL => array( 'roots' )
//            ),
            'tipologie_prodotti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'udm' => array(
                CONTROL_FULL => array( 'roots' )
            )
            )
	);
