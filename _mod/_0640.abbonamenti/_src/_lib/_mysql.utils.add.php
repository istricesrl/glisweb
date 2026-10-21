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

        // senza discipline né corsi collegati non c'è niente da proporre ( e WHERE ( ) sarebbe un errore di sintassi )
        if( empty( $whr ) ) {
            return array();
        }

        $whr = implode( ' OR ', $whr );

        // la statica se c'è: corsi_view ha GROUP BY, il filtro LIKE non entra e la vista si materializza intera
        $rm = getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], 'corsi' );

        $corsi = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM corsi{$rm} WHERE ( $whr )",
            $cnd
        );

        // print_r( $corsi );

        return $corsi;

    }
