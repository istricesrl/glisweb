<?php

    /**
     * tabella di traduzione
     *
     *
     *
     *
     * TODO documentare meglio sia i file dei dizionari sia il modo in cui si può utilizzare l'array $cf['tr']
     *
     * TODO usare glob per trovare i dizionari (non limitarsi a 'generic')
     * TODO ogni modulo dovrebbe avere i suoi dizionari
     * TODO documentare
     * TODO completare l'inserimento dei dizionari
     *
     * TODO salvare in cache i dizionari
     *
     *
     */

    // inizializzazione della tabella di traduzione
    $cf['tr'] = array();

    // ricerca dei files di dizionario
    $arrayDizionariBase = glob( glob2custom( DIR_ETC_DICTIONARIES . '_*.{' . LINGUE_ATTIVE . '}.conf' ), GLOB_BRACE );
    $arrayDizionariModuli = glob( glob2custom( DIR_MOD_ATTIVI_ETC_DICTIONARIES . '_*.{' . LINGUE_ATTIVE . '}.conf' ), GLOB_BRACE );
    $arrayDizionari = array_merge( $arrayDizionariBase, $arrayDizionariModuli );

    // popolazione della tabella di traduzione
    foreach( $arrayDizionari as $d ) {
        $cf['tr'] = array_replace_recursive( $cf['tr'], parse_ini_file( $d, true ) );
        if( file_exists( path2custom( $d ) ) ) {
            $cf['tr'] = array_replace_recursive( $cf['tr'], parse_ini_file( path2custom( $d ), true ) );
        }
    }

    // debug
    // die( print_r( $cf['tr'], true ) );
    // die( print_r( $arrayDizionari, true ) );
    // die( print_r( $arrayDizionariBase, true ) ); 
    // die( print_r( $arrayDizionariModuli, true ) ); 
    // echo DIR_ETC_DICTIONARIES . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo DIR_MOD_ATTIVI_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo 'OUTPUT';
