<?php

    if( isset( $_REQUEST['__ricerca__'] ) && ! empty( $_REQUEST['__ricerca__'] ) ) {

        $tokens = explode( ' ', $_REQUEST['__ricerca__'] );

        $whr = '';
        $cnd = array();

        foreach( $tokens as $token ) {

            $whr .= '
            AND ( 
                articoli.id LIKE ?
                OR
                prodotti.id LIKE ?
                OR
                articoli.nome LIKE ?
                OR
                articoli.note LIKE ?
                OR
                prodotti.nome LIKE ?
            )
            ';

            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );

        }

        $query = 'SELECT articoli.*, prodotti.nome AS prodotto,
            mastri.prefisso_modula, mastri.codice_modula, mastri.id AS id_mastro_provenienza,
            __report_giacenza_magazzini__.totale_proprio AS giacenza, __report_giacenza_magazzini__.nome AS magazzino
            FROM articoli
            INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
            LEFT JOIN __report_giacenza_magazzini__ ON articoli.id = __report_giacenza_magazzini__.id_articolo 
            LEFT JOIN mastri ON mastri.id = __report_giacenza_magazzini__.id_mastro
            WHERE ( __report_giacenza_magazzini__.se_foglia IS NOT NULL OR __report_giacenza_magazzini__.id IS NULL )
            '.$whr.'
            ORDER BY articoli.nome ASC';

        $ct['risultati'] = mysqlQuery(
            $cf['mysql']['connection'],
            $query,
            $cnd
        );

        // die( $query );
        // die( print_r( $ct['risultati'], true ) );

    }
