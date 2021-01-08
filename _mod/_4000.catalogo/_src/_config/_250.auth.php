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
		'categorie_prodotti' => array(
            CONTROL_FULL => array( 'roots' )
		),
		'categorie_prodotti_caratteristiche' => array(
		    CONTROL_FULL => array( 'roots' )
#		),
#		'marchi' => array(
#		    CONTROL_FULL => array( 'roots' )
#		),
#		'coupon' => array(
#		    CONTROL_FULL => array( 'roots' )
#		),
#		'coupon_prodotti' => array(
#		    CONTROL_FULL => array( 'roots' )
#		),
#		'coupon_categorie_prodotti' => array(
#		    CONTROL_FULL => array( 'roots' )
        )
	    )
	);
