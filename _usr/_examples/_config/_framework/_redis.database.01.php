<?php

    /**
     * file di esempio per l'opzione redis.servers.<n>.db
     * 
     * confronta il database configurato per il server redis corrente ( db0 se l'opzione manca ) con quello su
     * cui la connessione aperta da _src/_config/_045.cache.php lavora davvero, letto dal server con CLIENT LIST
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // database atteso
    $atteso = ( isset( $cf['redis']['server']['db'] ) ) ? (int) $cf['redis']['server']['db'] : 0;

    // id della connessione corrente
    $id = $cf['redis']['connection']->executeRaw( array( 'CLIENT', 'ID' ) );

    // database effettivo della connessione corrente
    $effettivo = NULL;
    foreach( explode( "\n", $cf['redis']['connection']->executeRaw( array( 'CLIENT', 'LIST' ) ) ) as $riga ) {
        if( preg_match( '/^id=' . $id . ' .* db=([0-9]+) /', $riga, $m ) ) {
            $effettivo = (int) $m[1];
        }
    }

    // ...
    var_dump( $atteso, $effettivo );

    // ...
    echo ( $atteso === $effettivo ) ? 'database OK' : 'database KO';
