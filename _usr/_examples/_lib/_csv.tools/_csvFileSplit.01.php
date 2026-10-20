<?php

    /**
     * file di esempio per la funzione csvFileSplit()
     *
     *
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $d = 'tmp/example/' . microtime( true ) . '/';
    $f = $d . 'esempio.csv';

    // scrivo un CSV con intestazione e cinque righe
    checkFolder( $d );
    overwriteToFile( "col1;col2\nval1;a\nval2;b\nval3;c\nval4;d\nval5;e\n", $f );

    // lo spezzo in parti da due righe
    $p = csvFileSplit( $f, 2 );

    // output: tre parti, nell'ordine, ognuna con l'intestazione
    var_dump( count( $p ) === 3 );
    var_dump( basename( $p[0] ) === 'esempio.parte.0001.csv' );
    var_dump( basename( $p[2] ) === 'esempio.parte.0003.csv' );
    var_dump( csvFile2array( $p[0] ) == array( array( 'col1' => 'val1', 'col2' => 'a' ), array( 'col1' => 'val2', 'col2' => 'b' ) ) );
    var_dump( csvFile2array( $p[2] ) == array( array( 'col1' => 'val5', 'col2' => 'e' ) ) );

    // output: l'originale resta dov'era
    var_dump( file_exists( getFullPath( $f ) ) );
