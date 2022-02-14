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

    // trovo i flag di prodotto
    $ct['etc']['flags'] = mysqlSelectCachedRow(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_prodotti.* FROM prodotti INNER JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia WHERE prodotti.id = ?',
        array( array( 's' => $_REQUEST['articoli']['id_prodotto'] ) )
    );

    // print_r( $ct['etc']['flags'] );
