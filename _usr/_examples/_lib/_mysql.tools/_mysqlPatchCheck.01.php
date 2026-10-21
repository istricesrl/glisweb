<?php

    /**
     * file di esempio per la funzione mysqlPatchCheck()
     *
     * Usa il database del deploy in sola lettura: col suo livello vero le patch si possono applicare, con un livello
     * finto a zero ( database pieno senza patch ) o sotto il canone no. Non scrive niente.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // dati del database del deploy
    $c = $cf['mysql']['connection'];
    $k = mysqlPatchCanon( DIR_BASE );
    $f = mysqlPatchFiles( DIR_BASE );

    // livello vero: il database del deploy è al canone
    $e = NULL;
    echo 'livello vero: ';
    var_dump( mysqlPatchCheck( $c, mysqlPatchLevel( $c ), $k, $f, $e ) );

    // livello a zero su un database pieno: va ricostruito
    $e = NULL;
    echo 'livello a zero: ';
    var_dump( mysqlPatchCheck( $c, '000000000000', $k, $f, $e ) );
    echo $e . PHP_EOL;

    // livello sotto il canone: va aggiornato passando dal rilascio precedente
    $e = NULL;
    echo 'livello sotto il canone: ';
    var_dump( mysqlPatchCheck( $c, '100000000000', $k, $f, $e ) );
    echo $e . PHP_EOL;
