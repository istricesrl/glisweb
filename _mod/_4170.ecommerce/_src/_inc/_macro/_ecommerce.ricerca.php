<?php

    if( isset( $_REQUEST['__ricerca__'] ) && ! empty( $_REQUEST['__ricerca__'] ) ) {

        $tokens = explode( ' ', $_REQUEST['__ricerca__'] );

        $whr = '';
        $cnd = array();

        foreach( $tokens as $token ) {

            $whr .= '
            AND ( 
                articoli.id = ?
                OR
                prodotti.id = ?
                OR
                articoli.nome LIKE ?
                OR
                articoli.note LIKE ?
                OR
                prodotti.nome LIKE ?
            )
            ';

            $cnd[] = array( 's' => $token );
            $cnd[] = array( 's' => $token );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );

        }

        $ct['risultati'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT articoli.*, prodotti.nome AS prodotto,
                mastri.prefisso_modula, mastri.codice_modula,
                __report_giacenza_magazzini__.totale_proprio AS giacenza
            FROM articoli
            INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
            INNER JOIN __report_giacenza_magazzini__ ON articoli.id = __report_giacenza_magazzini__.id_articolo 
            INNER JOIN mastri ON mastri.id = __report_giacenza_magazzini__.id_mastro
            WHERE __report_giacenza_magazzini__.se_foglia IS NOT NULL
            '.$whr.'
            ORDER BY articoli.nome ASC',
            $cnd
        );

        // die( print_r( $ct['risultati'], true ) );

    }
