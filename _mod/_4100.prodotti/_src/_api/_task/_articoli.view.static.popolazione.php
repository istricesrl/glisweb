<?php

    // inclusione del framework
    if (! defined('CRON_RUNNING')) {
        require '../../../../../_src/_config.php';
    }

    // inizializzo l'array del risultato
    $status = array();

    // ...
    if (! isset($_REQUEST['idArticolo'])) {

        // trovo una riga da aggiornare
        $status['aggiornare'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT articoli.id
                FROM articoli
                LEFT JOIN articoli_view_static 
                    ON articoli_view_static.id = articoli.id
                WHERE
                    (
                        articoli_view_static.timestamp_inserimento IS NULL
                        OR articoli.timestamp_inserimento > articoli_view_static.timestamp_inserimento
                    )
                    OR
                    (
                        articoli_view_static.timestamp_aggiornamento IS NULL
                        OR articoli.timestamp_aggiornamento > articoli_view_static.timestamp_aggiornamento
                    )
                ORDER BY
                    (articoli_view_static.id IS NULL) DESC,
                    articoli.timestamp_inserimento DESC,
                    articoli.timestamp_aggiornamento DESC
                LIMIT 1;'
        );

        // status
        $status['modalita'] = 'standard';
    } elseif (isset($_REQUEST['idArticolo'])) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['idArticolo'];
        $status['modalita'] = 'forzata';
    }

    // ...
    if (! empty($status['aggiornare']['id'])) {
        updateArticoliViewStatic(
            $status['aggiornare']['id']
        );
    }

    // debug
    // print_r( $_REQUEST );

    // output
    if (! defined('CRON_RUNNING')) {
        buildJson($status);
    }
