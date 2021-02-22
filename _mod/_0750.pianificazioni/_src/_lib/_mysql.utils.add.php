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
    
            if( isset( $flds['§data§'] ) ) {
                return $flds['§data§'];
            } else {
                die('§data§ non presente nel JSON');
            }

        }

        return null;
        
    }

    function pianificazioniGetLatestObjectDate( $id, $e ) {

        $field = pianificazioniGetMatchFieldName( $id, $e );

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max(' . $field . ') FROM ' . $e . ' WHERE id_pianificazione = ?',
            array( array( 's' => $id ) )
        );

    }