<?php

    function tendinaCorsiAbbonamento( $idAbbonamento ) {

        global $cf;

        $whr = array();
        $cnd = array();

        $discipline = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM metadati WHERE id_tipologia_contratti = ? AND nome = ?",
            array(
                array( 's' => $idAbbonamento ),
                array( 's' => 'abbonamento|discipline' )
            )
        );

        // print_r( $discipline );

        foreach( $discipline as $d ) {
            $whr[] = "id_discipline LIKE ?";
            $cnd[] = array( 's' => '%|'.$d['testo'].'|%' );
        }

        $corsi = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM metadati WHERE id_tipologia_contratti = ? AND nome = ?",
            array(
                array( 's' => $idAbbonamento ),
                array( 's' => 'abbonamento|corsi' )
            )
        );

        // print_r( $corsi );

        foreach( $corsi as $c ) {
            $whr[] = "id = ?";
            $cnd[] = array( 's' => $c['id'] );
        }

        $whr = implode( ' OR ', $whr );

        $corsi = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM corsi_view WHERE ( $whr )",
            $cnd
        );

        // print_r( $corsi );

        return $corsi;

    }
