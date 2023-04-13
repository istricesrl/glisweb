<?php

    function pianificazioniGetMatchEntityName( $id ) {

        global $cf;

    // TODO
    // foreach( $cf['pianificazioni']['chiavi'] AS $chiave ) {
    // if( ! emtpy( $current[ $chiave ] ) ) {
    // $current['entita'] = trovaTabellaDestinazioneConstraint( 'pianificazioni', $chiave );
    // }
    // }

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

            $flds = array_flip( $a['sostituzioni'][ $e ] );
    
            if( isset( $flds['§data§'] ) ) {
                return $flds['§data§'];
            } else {
                die('§data§ non presente nel JSON');
            }

        }

        return null;
        
    }


    // funzione che riceve in ingresso l'id di una pianificazione e ritorna le tabelle con view statiche coinvolte
    function pianificazioniGetStatic( $id ) {

        global $cf;

        $s = array();

        $wsp = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT workspace FROM pianificazioni WHERE id = ?',
            array( array( 's' => $id ) )
        );

        if( ! empty( $wsp ) ) {
            $w = json_decode( $wsp, true );
            if( !empty( $w['sostituzioni'] ) ){
                foreach( $w['sostituzioni'] as $k => $v ){
                    $t = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like "' . $k . '_view_static"' );
                    if( !empty( $t ) ){
                         $s[] = $k;
                    }              
                }               
            }
        }       
        return $s;                
    }
    

    function pianificazioniGetLatestObjectDate( $id, $e, $r=NULL ) {

        $field = pianificazioniGetMatchFieldName( $id, $e );

        global $cf;

        $d = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max(' . $field . ') FROM ' . $e . ' WHERE id_pianificazione = ?',
            array( array( 's' => $id ) )
        );

        if( empty( $d ) && !empty( $r ) ){
            $d = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT ' . $field . ' FROM ' . $e . ' WHERE id = ?',
                array( array( 's' => $r ) )
            );
        }

        return $d;

    }

    // funzione che verifica se una data è attiva (non compresa in un periodo di pausa)
    // $d = data
    // $t = tabella di pausa in cui cercare
    // $fn = nome del campo su cui filtrare
    // $fv = valore del filtro
    // NOTA: la funzione presume che i campi di confronto si chiamino sempre data_inizio e data_fine
    function seDataAttiva( $d, $t, $fn, $fv ){

        global $cf;

        $attiva = 1;

        $pause = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count(*) FROM ' . $t . ' WHERE data_inizio <= ? AND ( data_fine >= ? OR data_fine IS NULL ) AND ' . $fn . '= ?',
            array(
                array( 's' => $d ),
                array( 's' => $d ),
                array( 's' => $fv )
            )
        );

        if( $pause > 0 ){
           $attiva = 0;
        }

        return $attiva;
    }