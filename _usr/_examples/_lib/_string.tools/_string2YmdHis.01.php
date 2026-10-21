<?php

    /**
     * esempio di string2YmdHis()
     *
     * L'output è controllato da _usr/_test/_tests/unit/stringToolsCest.php: i minuti senza zero e quelli a 60 o 61 vanno
     * normalizzati, i valori non interpretabili danno false, e il valore corto non deve più risultare nel passato
     * ( le asserzioni non dipendono dal formato di var_dump(), che cambia con xdebug ).
     *
     */

    require '../../../../_src/_config.php';

    var_dump( string2YmdHis( '2026101315401' ) );
    var_dump( string2YmdHis( '20260604136101' ) );
    var_dump( string2YmdHis( '20231025123000' ) );
    var_dump( string2YmdHis( '20261325120000' ) );
    var_dump( string2YmdHis( 'pippo' ) );
    var_dump( strcmp( string2YmdHis( '2026101315401' ), '20260101000000' ) > 0 );
