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

    // verifico la cartella temporanea
	checkFolder( DIR_TMP );

    // debug
	// error_reporting( E_ALL );
	// ini_set( 'display_errors', TRUE );
