<?php

    /**
     * applicazione della configurazione della localizzazione
     *
     *
     *
     * @todo trovare un modo sensato per convertire la lingua corrente del sito
     *
     * @file
     *
     */

    // codice IETF della lingua
	$ietf = str_replace( '-', '_', $cf['localization']['language']['ietf'] );
	$chrs = str_replace( '-', '', $cf['localization']['charset'] );

    // applico la localizzazione corrente
	setlocale( LC_ALL, $ietf . '.' . $chrs );

    // applico la timezone corrente
	date_default_timezone_set( $cf['localization']['timezone']['name'] );

    // log
	logWrite( 'lingua corrente: ' . $cf['localization']['language']['ietf'] , 'localization' );

    // debug
	// print_r( $cf['localization']['language'] );
	// echo str_replace( '-', '_', $cf['localization']['language']['ietf'] ) . '.' . str_replace( '-', '_', $cf['localization']['charset'] );
	// die( $cf['localization']['timezone']['name'] );
	// print_r( $cf['localization']['timezone'] );
	// die( date_default_timezone_get() );

?>
