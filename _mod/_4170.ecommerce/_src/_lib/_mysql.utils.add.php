<?php

    function scontaCarrello( &$carrello ) {

        global $cf;

        // contatore degli sconti applicati
        $count = 0;

        if( isset( $carrello['articoli']) ){

            // logiche di sconto
        }

        return $count;
    }

/*
    function aggiornaCarrelloEarticoli() {

        global $cf;

        $_SESSION['carrello']['prezzo_netto_totale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_totale']        = 0;
        $_SESSION['carrello']['prezzo_netto_finale']        = 0;
        $_SESSION['carrello']['prezzo_lordo_finale']        = 0;

        // pulisco eventuali sconti applicati
        $_SESSION['carrello']['sconto_percentuale'] = NULL;
        $_SESSION['carrello']['note'] = NULL;

        // ricalcolo i totali aggiornando ogni riga
        foreach( $_SESSION['carrello']['articoli'] as $dati ) {

            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_carrello'               => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_carrello'],
                    'id_articolo'               => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_articolo'],
                    'id_iva'                    => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['id_iva'],
                    'quantita'                  => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['quantita'],
                    'prezzo_netto_unitario'     => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_unitario'],
                    'prezzo_lordo_unitario'     => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_unitario'],
                    'prezzo_netto_totale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'],
                    'prezzo_lordo_totale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'],
                    'prezzo_netto_finale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'],
                    'prezzo_lordo_finale'       => $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'],
                    'sconto_percentuale'        => ( isset($_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['sconto_percentuale']) ? $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['sconto_percentuale'] : NULL ),
                    'note'                      => ( isset($_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['note']) ? $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['note'] : NULL ),
                ),
                'carrelli_articoli'
            );
            
            // aggiorno i totali
            $_SESSION['carrello']['prezzo_netto_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_totale'];
            $_SESSION['carrello']['prezzo_lordo_totale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_totale'];
            $_SESSION['carrello']['prezzo_netto_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_netto_finale'];
            $_SESSION['carrello']['prezzo_lordo_finale'] += $_SESSION['carrello']['articoli'][ $dati['id_articolo'] ]['prezzo_lordo_finale'];

        }

    }
*/

    function aggiornaFlagCarrelloSeLogin( &$carrello ) {

        global $cf;
    
        $ids = array_keys( $carrello['articoli'] );
        $par = array();

        // die( print_r( $ids ) );
        // die( 'SELECT max( testo ) FROM metadati WHERE nome = "se_login" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')' );

        foreach( $ids as $id ) {
            $par[] = array( 's' => $id );
        }

        $carrello['se_login'] = ( empty( $ids ) ) ? NULL : mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( testo ) FROM metadati WHERE nome = "se_login" AND id_articolo IN (' . implode( ',', array_fill( 0, count( $ids ), '?' ) ) . ')',
            $par
        );

        // die( $carrello['se_login'] );

    }