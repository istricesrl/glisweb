<?php

    /**
     * file di esempio per la funzione diskKeyPath()
     *
     * una chiave con barre e punti resta un file solo dentro DIR_VAR_SPOOL_CACHE
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test con caratteri che potrebbero uscire dalla cartella
    $k = '../TEST/../CHIAVE';

    // il percorso deve stare nella cartella della cache, senza barre nel nome del file
    $f = diskKeyPath( $k );
    var_dump( dirname( $f ) . '/' === DIR_VAR_SPOOL_CACHE );
    var_dump( basename( $f ) );
