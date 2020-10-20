<?php

    // integro le lingue mancanti
	foreach( array_column( $cf['localization']['languages'], 'id' ) as $l ) {
	    if(
            ! isset( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ] )
            ||
	    	! in_array( $l, array_column( $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ], 'id_lingua' ) ) ) {

            // integro la lingua mancante
                $_REQUEST[ $ct['form']['table'] ][ $ct['form']['subtable'] ][]['id_lingua'] = $l;

	    }
	}

?>
