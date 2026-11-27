<?php

    /**
     * esempio di xls2csv()
     *
     * L'output è controllato da _usr/_test/_tests/unit/xlsToolsCest.php. Si scrive un foglio con l'estensione maiuscola,
     * lo si converte in CSV e si controlla che il CSV sia separato da punto e virgola, che abbia il nome giusto e che il
     * file di partenza sia ancora leggibile: fino al 2026-10-30 il CSV usciva separato da `w+` e un file `.XLSX` veniva
     * sovrascritto dal suo CSV.
     *
     */

    require '../../../../_src/_config.php';

    // cartella di lavoro
    $cartella = DIR_VAR . 'tmp/xls2csv.' . getmypid() . '/';
    @mkdir( $cartella, 0770, true );

    // foglio con l'estensione maiuscola
    array2xlsFile( $cartella . 'Foglio.XLSX', array( array( 'nome' => 'Mario', 'codice' => '001' ), array( 'nome' => 'Anna', 'codice' => '002' ) ) );

    // conversione
    $csv = xls2csv( $cartella . 'Foglio.XLSX' );
    echo 'csv: ' . ( ( $csv === false ) ? 'false' : basename( $csv ) ) . PHP_EOL;
    echo 'contenuto: ' . ( ( $csv === false ) ? 'false' : json_encode( file( $csv, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) ) ) . PHP_EOL;
    echo 'originale: ' . ( ( xlsLoad( $cartella . 'Foglio.XLSX' ) === false ) ? 'rovinato' : 'leggibile' ) . PHP_EOL;

    // pulizia
    array_map( 'unlink', glob( $cartella . '*' ) );
    rmdir( $cartella );
