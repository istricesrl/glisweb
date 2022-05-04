<?php

    /**
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // print_r( $_REQUEST['articoli'] );

    // se l'articolo non è già salvato, ragiono sul preset
    if( ! isset( $_REQUEST['articoli']['id_prodotto'] ) && isset( $_REQUEST['__preset__']['articoli']['id_prodotto'] )   ) { $_REQUEST['articoli']['id_prodotto'] =  $_REQUEST['__preset__']['articoli']['id_prodotto']; }

    if( isset( $_REQUEST['articoli']['id_prodotto'] ) ){
        
        // trovo i flag di prodotto
        $ct['etc']['flags'] = mysqlSelectCachedRow(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT tipologie_prodotti.* FROM prodotti INNER JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST['articoli']['id_prodotto'] ) )
        );
    }


    // print_r( $ct['etc']['flags'] );
