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
            'progetti_anagrafica' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'anagrafica_progetti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'progetti_categorie' => array(
                CONTROL_FULL => array( 'roots' )
            ),
#            'macro' => array(
#                CONTROL_FULL => array( 'roots' )
#            ),
            'relazioni_progetti' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            'todo' => array(
                CONTROL_FULL => array( 'roots' ),
                CONTROL_FILTERED => array( 'staff' )
            ),
            '__report_avanzamento_progetti__' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_avanzamento_trattative__' => array(
                CONTROL_FULL => array( 'roots' )
            ),
            '__report_status_contratti__' => array(
                CONTROL_FULL => array( 'roots' )
            )
        )
	);
