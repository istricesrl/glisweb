<?php

    /**
     * server e profili MySQL
     *
     * In questo file sono impostati i profili di funzionamento di MySQL
     * e i parametri di configurazione dei server disponibili.
     *
     * introduzione
     * ============
     * Anche per MySQL come visto per Google viene applicata la logica dei profili. Per ulteriori
     * dettagli su questo si vedano i commenti al file _src/_config/_110.google.php.
     * 
     * Alla logica dei profili si aggiunge qui la logica dei server, per cui sotto la chiave $cf['mysql']['servers']
     * vengono dichiarati i server disponibili, che poi verranno referenziati e utilizzati nei vari profili.
     * 
     * array di configurazione dei server
     * ----------------------------------
     * L'array $cf['mysql']['servers'] contiene tutte le informazioni necessarie
     * al framework per utilizzare uno o più server MySQL. Ogni chiave rappresenta un
     * diverso server e deve puntare a un array associativo che riporti i seguenti dati:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * address          | l'indirizzo (nome host o IP) del server
     * port             | la porta del server (default 3306)
     * username         | il nome utente per la connessione
     * password         | la password per la connessione
     * db               | il database da utilizzare sul server
     *
     * array di configurazione dei profili
     * -----------------------------------
     * Ogni profilo di funzionamento del sito può avere associati server diversi; questo
     * consente lo switch veloce da un profilo all'altro senza doversi preoccupare di
     * modificare la configurazione del database. Ogni profilo è descritto da un sottoarray
     * dell'array $cf['mysql']['profiles'] nel quale ogni chiave corrisponde a un diverso
     * livello di funzionamento del framework. L'array di configurazione del profilo deve
     * contenere i seguenti campi:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * servers          | i server attivi per il profilo
     *
     * array di configurazione delle connessioni
     * -----------------------------------------
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
     * TODO implementare bilanciamento del carico
     *
     *
     *
     */

    // server disponibili
    $cf['mysql']['servers']                     = array();

    // connessioni disponibili
    $cf['mysql']['connections']                 = array();

    // profili di funzionamento
    $cf['mysql']['profiles'][ DEVELOPEMENT ]    =
    $cf['mysql']['profiles'][ TESTING ]         =
    $cf['mysql']['profiles'][ PRODUCTION ]      = array();

    // debug
    // echo $cf['site']['status'];
    // die( print_r( $cf['mysql']['profile'], true ) );
    // print_r( $cf['mysql'] );
    // print_r( $cx['mysql'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // die( __FILE__ );
