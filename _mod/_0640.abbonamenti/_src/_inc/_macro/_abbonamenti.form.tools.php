<?php

    /**
     * macro form abbonamenti tools
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
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

    // tabella gestita
	$ct['form']['table'] = 'contratti';

    $documenti = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT rinnovi.*, 
        sum( documenti_articoli.importo_lordo_totale ) AS pagato
        FROM rinnovi
        LEFT JOIN documenti_articoli ON documenti_articoli.id_rinnovo = rinnovi.id
        WHERE rinnovi.id_contratto = ?
        GROUP BY rinnovi.id
        ORDER BY rinnovi.data_fine DESC',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

    $carrelliPagati = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT rinnovi.*, 
        sum( carrelli_articoli.prezzo_lordo_finale ) AS pagato_carrelli
        FROM rinnovi
        LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id
        LEFT JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello
        WHERE rinnovi.id_contratto = ? AND carrelli.timestamp_pagamento IS NOT NULL
        GROUP BY rinnovi.id
        ORDER BY rinnovi.data_fine DESC',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

    $carrelli = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT rinnovi.*, 
        sum( carrelli_articoli.prezzo_lordo_finale ) AS ordinato
        FROM rinnovi
        LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id
        WHERE rinnovi.id_contratto = ?
        GROUP BY rinnovi.id
        ORDER BY rinnovi.data_fine DESC',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

    $ct['etc']['rinnovi'] = array_merge( $documenti, $carrelli, $carrelliPagati );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

