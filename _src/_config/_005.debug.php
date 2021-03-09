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
	$cf['debug']['fs']['folders'] = array( DIR_ETC, DIR_ETC_SITEMAP, DIR_VAR, DIR_VAR_LOG, DIR_TMP );
    $cf['debug']['fs']['files'] = array( path2custom( FILE_MYSQL_PATCH ) );

    // verifico le cartelle
    foreach( $cf['debug']['fs']['folders'] as $folder ) {
	    checkFolder( $folder ) or die( 'cartella ' . $folder . ' non scrivibile' );
    }

    // verifico i file
    foreach( $cf['debug']['fs']['files'] as $file ) {
	    checkFile( $file ) or die( 'file ' . $file . ' non scrivibile' );
    }

    // debug
	// error_reporting( E_ALL );
	// ini_set( 'display_errors', TRUE );
