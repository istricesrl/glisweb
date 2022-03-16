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
            'progetti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_archivio' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_commerciale' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_commerciale_archivio' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_amministrazione' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_amministrazione_archivio' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_produzione' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_produzione_archivio' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'categorie_progetti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'pause_progetti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_categorie' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
