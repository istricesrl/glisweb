<?php

    if( isset( $_REQUEST['__ricerca__'] ) && ! empty( $_REQUEST['__ricerca__'] ) ) {

        $tokens = explode( ' ', $_REQUEST['__ricerca__'] );

        $whr = '';
        $cnd = array();

        foreach( $tokens as $token ) {

            // Ogni token deve comparire in almeno uno dei campi ricercabili. Oltre a id e nome di
            // articolo e prodotto si cerca anche fra i nomi delle categorie (articoli_view.categorie):
            // per i corsi GIMBE il titolo "intuitivo" ( es. "Digital Health", "PDTA" ) vive li, non
            // in articoli.nome ne in prodotti.nome, quindi senza questo campo la ricerca per argomento
            // non trovava nulla.
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
                OR
                articoli_view.categorie LIKE ?
            )
            ';

            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );
            $cnd[] = array( 's' => '%'.$token.'%' );

        }

        // La giacenza a magazzino e la provenienza dai mastri sono arricchimenti che esistono solo
        // se e installato il modulo magazzino 0500.mastri, che alimenta la vista-report
        // __report_giacenza_magazzini__ con le colonne se_foglia e totale_proprio. Sui deploy senza
        // magazzino quella vista non ha quelle colonne, quindi interrogarla mandava in errore SQL
        // l'intera ricerca (mysqlQuery ingoia l'eccezione) e la scheda risultati restava sempre
        // vuota. Il join alla giacenza viene percio incluso solo quando il modulo e attivo;
        // altrimenti si cerca sui soli articoli e prodotti. Il template degrada gia da solo sulle
        // colonne di giacenza mancanti.
        if( in_array( '0500.mastri', $cf['mods']['active']['array'] ) ) {

            $query = 'SELECT articoli.*, prodotti.nome AS prodotto,
                mastri.prefisso_modula, mastri.codice_modula, mastri.id AS id_mastro_provenienza,
                __report_giacenza_magazzini__.totale_proprio AS giacenza, __report_giacenza_magazzini__.nome AS magazzino
                FROM articoli
                INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
                LEFT JOIN articoli_view ON articoli_view.id = articoli.id
                LEFT JOIN __report_giacenza_magazzini__ ON articoli.id = __report_giacenza_magazzini__.id_articolo 
                LEFT JOIN mastri ON mastri.id = __report_giacenza_magazzini__.id_mastro
                WHERE ( __report_giacenza_magazzini__.se_foglia IS NOT NULL OR __report_giacenza_magazzini__.id IS NULL )
                '.$whr.'
                ORDER BY articoli.nome ASC';

        } else {

            $query = 'SELECT articoli.*, prodotti.nome AS prodotto,
                NULL AS id_mastro_provenienza, NULL AS giacenza, NULL AS magazzino
                FROM articoli
                INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
                LEFT JOIN articoli_view ON articoli_view.id = articoli.id
                WHERE 1 = 1
                '.$whr.'
                ORDER BY articoli.nome ASC';

        }

        $ct['risultati'] = mysqlQuery(
            $cf['mysql']['connection'],
            $query,
            $cnd
        );

        // die( $query );
        // die( print_r( $ct['risultati'], true ) );

    }
