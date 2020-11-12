<?php

    function trovaIdComune( $c, $p = NULL ) {

        global $cf;

        $comuni = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM comuni WHERE nome = ?',
            array( array( 's' => $c ) )
        );

        if( ! empty( $comuni[0]['id'] ) ) {
            return $comuni[0]['id'];
        } else {
            return NULL;
        }

    }
