<?php

    // NOTA
    // la logica è la seguente, al corso (progetto) è associato un prodotto, gli articoli rappresentano le varie modalità e periodi di iscrizione al corso stesso; l'anagrafica iscritta
    // la ricavo da destinatario_id_anagrafica e i dettagli dell'iscrizione dai metadati dell'articolo

    // debug
    // die( print_r( $_SESSION['carrello'] ) );

    // se è presente un ID carrello
    if( isset( $idCarrello ) && ! empty( $idCarrello ) ) {

        // recupero il carrello
        $carrello = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli WHERE id = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // recupero gli articoli
        $articoli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT carrelli_articoli.*, concat( prodotti.nome, " ", articoli.nome ) AS descrizione '.
            'FROM carrelli_articoli '.
            'LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo '.
            'LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
            'WHERE id_carrello = ? ',
            array(
                array( 's' => $idCarrello )
            )
        );

        // debug
        // print_r( $carrello );
        // print_r( $articoli );

        // aggiungo gli articoli al carrello
        $carrello['articoli'] = $articoli;

        // debug
        // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
        // die( '<pre>' . print_r( $carrello, true ) . '<pre>' );

        // conversione GA4
        ga4purchase(
            $cf['google']['profile']['analytics']['ua'],
            $cf['google']['profile']['analytics']['mp']['secret'],
            $carrello
        );
    
        // TODO conversione Facebook
        // ...

    } else {

        // debug
        // die('nessun carrello trovato!');

    }
