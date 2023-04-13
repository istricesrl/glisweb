<?php

    /**
     * verifica delle cartelle
     *
     * in questo file viene verificata l'esistenza delle cartelle custom necessarie al funzionamento del framework
     *
     * cartelle necessarie
     * ===================
     * Normalmente le cartelle necessarie al funzionamento del framework vengono controllate al momento del loro
     * utilizzo, tuttavia alcune potrebbero essere utilizzate prima o senza che questo controllo venga effettuato,
     * e per questo vengono controllate in questa sede.
     *
     * verifica delle cartelle dei log
     * -------------------------------
     * @todo documentare questa parte
     *
     *
     * @todo in una futura release questo passaggio dovrebbe diventare superfluo
     * @todo finire di documentare
     *
     * @file
     *
     */

    // directory da controllare
	$cf['debug']['fs']['folders'] = array_fill_keys( array( DIR_ETC_SITEMAP, DIR_VAR, DIR_VAR_LOG, DIR_TMP ), false );
    $cf['debug']['fs']['files'] = array_fill_keys( array( path2custom( FILE_MYSQL_PATCH ) ), false );

    // verifico le cartelle
    foreach( $cf['debug']['fs']['folders'] as $folder => $status ) {
	    $cf['debug']['fs']['folders'][ $folder ] = checkFolder( $folder );
    }

    // verifico i file
    foreach( $cf['debug']['fs']['files'] as $file => $status ) {
	    $cf['debug']['fs']['files'][ $file ] = checkFile( $file );
    }

    // debug
	// error_reporting( E_ALL );
	// ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';
