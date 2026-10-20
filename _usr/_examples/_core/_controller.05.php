<?php

    /**
     * file di esempio per la funzione controller()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // array dati
    $d = array();

    // dati
    for( $i = 0; $i < 20; $i++ ) {
        $d[] = array(
            'id' => $i + 1,
            'codice' => 'TEST-0' . ($i + 1),
            'nome' => 'test #' . ($i + 1)
        );
    }

    // scrivo n riga su test
    $r = controller(
        $cf['mysql']['connection'],             // connessione al database
        $cf['memcache']['connection'],          // connessione a memcache
        $d,                                     // blocco dati di lavoro
        'test',                                 // nome dell'entità su cui lavorare
        'POST'                                  // metodo da applicare
    );

    // dati
    $d = array();

    // scrivo una riga su test
    $r = controller(
        $cf['mysql']['connection'],             // connessione al database
        $cf['memcache']['connection'],          // connessione a memcache
        $d,                                     // blocco dati di lavoro
        'test',                                 // nome dell'entità su cui lavorare
        'GET'                                   // metodo da applicare
    );

    // stampo il risultato
    print_r( $d );

    // pulisco il database
    $r = mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE FROM test WHERE 1'
    );
