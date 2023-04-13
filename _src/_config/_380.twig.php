<?php

    /**
     * configurazione di Twig
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * nota sulla struttura dei profili
     * ================================
     * Questo è un ottimo esempio di come la struttura standard dei profili operi correttamente anche in mancanza
     * di alcuni elementi; Twig ad esempio funziona a profili ma non ha server né connessioni, quindi alcuni passaggi
     * dello schema standard dei profili sono assenti, ma gli altri sono ancora al loro posto e nell'ordine consueto:
     *
     * -# dichiarazione dei server disponibili (NO)
     * -# dichiarazione dei profili per ogni status
     * -# inizializzazione dell'array delle connessioni (NO)
     * -# applicazione della configurazione extra
     * -# collegamento di $ct (NO)
     *
     * Nel secondo file, quello esecutivo, la sequenza è:
     *
     * -# collegamento del profilo corrente
     * -# collegamento della connessione corrente (NO)
     * -# collegamento del server corrente (NO)
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // profili di funzionamento di Twig per DEV/TEST
	$cf['twig']['profiles'][ DEVELOPEMENT ]		=
	$cf['twig']['profiles'][ TESTING ]		= array(
	    'debug' => true
	);

    // profilo di funzionamento di Twig per PROD
	$cf['twig']['profiles'][ PRODUCTION ]		= array(
	    'cache' => DIR_VAR_CACHE_TWIG
	);

    // configurazione extra
	if( isset( $cx['twig'] ) ) {
	    $cf['twig'] = array_replace_recursive( $cf['twig'], $cx['twig'] );
	}
