<?php

    /**
     * tabella di traduzione
     *
     *
     *
     *
     *
     *
     * @todo usare glob per trovare i dizionari (non limitarsi a 'generic')
     * @todo ogni modulo dovrebbe avere i suoi dizionari
     * @todo finire di documentare
     * @todo completare l'inserimento dei dizionari
     *
     * @file
     *
     */

    // inizializzazione della tabella di traduzione
	$cf['tr']				= array();

    // ricerca dei files di dizionario
	$arrayDizionariBase			= glob( glob2custom( DIR_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.conf' ), GLOB_BRACE );
	$arrayDizionariModuli		= glob( glob2custom( DIR_MOD_ATTIVI_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.conf' ), GLOB_BRACE );
	$arrayDizionari				= array_merge( $arrayDizionariBase , $arrayDizionariModuli );

    // popolazione della tabella di traduzione
	foreach( $arrayDizionari as $d ) {
	    $cf['tr'] = array_replace_recursive( $cf['tr'], parse_ini_file( $d, true ) );
	    if( file_exists( path2custom( $d ) ) ) {
		$cf['tr'] = array_replace_recursive( $cf['tr'], parse_ini_file( path2custom( $d ), true ) );
	    }
	}

    // rendo le tabelle di traduzione disponibili al template
	$ct['tr']				= &$cf['tr'];

    // debug
	// print_r( $arrayDizionari );
	// echo DIR_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
	// echo DIR_MOD_ATTIVI_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo 'OUTPUT';
