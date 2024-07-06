<?php

    /**
     * applicazione della configurazione della localizzazione
     *
     *
     *
     * TODO le costanti LINGUE_ATTIVE e LINGUA_CORRENTE dovrebbero diventare IETF_ATTIVI e IETF_CORRENTE?
     * TODO trovare un modo sensato per convertire la lingua corrente del sito
     *
     *
     */

    // lingua corrente
	define( 'LINGUA_CORRENTE'		    , $cf['localization']['language']['ietf'] );
    define( 'ID_LINGUA_CORRENTE'		, $cf['localization']['language']['id'] );

    // codice IETF della lingua
	$ietf = str_replace( '-', '_', LINGUA_CORRENTE );
	$chrs = str_replace( '-', '', $cf['localization']['charset'] );

    // applico la localizzazione corrente
	setlocale( LC_ALL, $ietf . '.' . $chrs );

    // applico la timezone corrente
	date_default_timezone_set( $cf['localization']['timezone']['name'] );

    // log
	logWrite( 'lingua corrente: ' . LINGUA_CORRENTE , 'localization' );

    // debug
	// print_r( $cf['localization']['language'] );
	// echo str_replace( '-', '_', $cf['localization']['language']['ietf'] ) . '.' . str_replace( '-', '_', $cf['localization']['charset'] );
	// die( $cf['localization']['timezone']['name'] );
	// print_r( $cf['localization']['timezone'] );
	// die( date_default_timezone_get() );
    // echo 'OUTPUT';
