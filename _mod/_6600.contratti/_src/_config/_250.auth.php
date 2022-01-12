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
        'contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_articoli' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_archiviati' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_completa' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'contratti_produzione' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'costi_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'orari_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_contratti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_attivita_inps' => array(
            CONTROL_FULL => array( 'roots' )
        )
	    )
	);
