<?php

    function pianificazioniGetMatchEntityName( $id ) {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT entita FROM pianificazioni WHERE id = ?',
            array( array( 's' => $id ) )
        );

    }

    function pianificazioniGetMatchFieldName( $id, $e ) {

        global $cf;

        $wsp = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT workspace FROM pianificazioni WHERE id = ?',
            array( array( 's' => $id ) )
        );

        if( ! empty( $wsp ) ) {

            $a = json_decode( $wsp, true );

            $flds = array_flip( $a[ $e ] );
    
            return $flds['§data§'];

        }

        return null;
        
    }