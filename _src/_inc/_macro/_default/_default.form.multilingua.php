<?php
/*
    // integro le lingue mancanti
    foreach( array_column( $cf['localization']['languages'], 'id' ) as $l ) {
        if(
            in_array( $ct['form']['subtable'], array( 'contenuti' ) )
            && (
                ! isset( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ] )
                ||
                ! in_array( $l, array_column( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ], 'id_lingua' ) )
            )
        ) {

            // integro la lingua mancante
            $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ][]['id_lingua'] = $l;

        }
    }
*/

// ...
if( in_array( $ct['form']['subtable'], array( 'contenuti' ) ) ) {

    /*
        // ...
        $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM contenuti WHERE '
        )
    */
    // die( print_r( $cf['localization']['languages'], true ) );
    // die( print_r( $ct['tr']['languages'], true ) );

    // ...
    if( isset( $ct['tr']['languages'] ) && is_array( $ct['tr']['languages'] ) ) {
        // foreach( array_column( $cf['localization']['languages'], 'id' ) as $l ) {
        foreach( array_column( $ct['tr']['languages'], 'id' ) as $l ) {

            // ...
            if(
                ! isset( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ] )
                ||
                ! in_array( $l, array_column( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ], 'id_lingua' ) )
            ) {

                // integro la lingua mancante
                $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ][]['id_lingua'] = $l;

            }

        }

    }

}
