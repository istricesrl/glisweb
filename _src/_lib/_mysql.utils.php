<?php

    function trovaIdComune( $c, $p = NULL ) {

        global $cf;

        $comuni = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM comuni WHERE nome = ?',
            array( array( 's' => $c ) )
        );

    }
