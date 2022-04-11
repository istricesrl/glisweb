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
		'risorse' => array(
		    CONTROL_FULL => array( 'roots' )
        ),
        'categorie_risorse' => array(
			CONTROL_FULL => array( 'roots' )
	    ),
        'risorse_categorie' => array(
		    CONTROL_FULL => array( 'roots' )
		)
	    )
	);
