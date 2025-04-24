<?php

    /**
     * macro form anagrafica
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
	$ct['form']['table'] = 'documenti';

    // ...
    if( isset( $_REQUEST['__bip__']['__codice__'] ) && ! empty( $_REQUEST['__bip__']['__codice__'] ) ) {

        // die( print_r( $_REQUEST[ $ct['form']['table'] ], true ) );

        $idTipologiaRiga = 4;

        $idGenitoreRiga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT documenti_articoli.id,
                documenti_articoli.quantita,
                sum( righe_evasione.quantita ) AS quantita_evasione
            FROM documenti_articoli 
            LEFT JOIN documenti_articoli AS righe_evasione ON righe_evasione.id_genitore = documenti_articoli.id
            WHERE documenti_articoli.id_missione = ? 
            AND documenti_articoli.id_articolo = ?
            GROUP BY documenti_articoli.id',
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__bip__']['__codice__'] )
            )
        );

        // ...
        // die( print_r( $idGenitoreRiga, true ) );

        $idMastroProvenienza = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_mastro FROM __report_giacenza_magazzini__ WHERE id_articolo = ? AND totale_proprio > 0',
            array( 
                array( 's' => $_REQUEST['__bip__']['__codice__'] )
            )
        );

        // die( 'mastro provenienza ' . $idMastroProvenienza );

        // ...
        $idRiga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT id, quantita FROM documenti_articoli WHERE id_genitore = ? AND id_missione = ? AND id_articolo = ?',
            array( 
                array( 's' => $idGenitoreRiga['id'] ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__bip__']['__codice__'] )
            )
        );

        // ...
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO documenti_articoli ( id, id_genitore, id_tipologia, id_missione, id_articolo, quantita, id_mastro_provenienza, id_mastro_destinazione )
            VALUES ( ?, ?, ?, ?, ?, ?, ?, ? ) ON DUPLICATE KEY UPDATE 
                id=VALUES(id), 
                id_genitore=VALUES(id_genitore), 
                id_tipologia=VALUES(id_tipologia), 
                id_missione=VALUES(id_missione), 
                id_articolo=VALUES(id_articolo), 
                quantita=VALUES(quantita),
                id_mastro_provenienza=VALUES(id_mastro_provenienza),
                id_mastro_destinazione=VALUES(id_mastro_destinazione)',
            array(
                array( 's' => $idRiga['id'] ),
                array( 's' => $idGenitoreRiga['id'] ),
                array( 's' => $idTipologiaRiga ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__bip__']['__codice__'] ),
                array( 's' => $idRiga['quantita'] + 1 ),
                array( 's' => $idMastroProvenienza ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_mastro_destinazione'] )
            )
        );

    }

    // ...
    $ct['etc']['dati'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT documenti_articoli.id_articolo, sum( quantita ) AS quantita,
            concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione,
            group_concat( concat( documenti.numero, "/", documenti.sezionale, " del ", documenti.data ) SEPARATOR "|" ) AS documenti
        FROM documenti_articoli 
        INNER JOIN articoli ON articoli.id = documenti_articoli.id_articolo
        INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
        INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento
        WHERE documenti_articoli.id_missione = ? GROUP BY documenti_articoli.id_articolo',
        array( 
            array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
        )
    );

    // ...
    foreach( $ct['etc']['dati'] as &$row ) {

        $row['qta_prelevata'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( sum( quantita ), 0 ) FROM documenti_articoli WHERE id_genitore IS NOT NULL AND id_missione = ? AND id_tipologia = ? AND id_articolo = ? GROUP BY id_genitore',
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => 4 ),
                array( 's' => $row['id_articolo'] )
            )
        );

        $row['qta_da_prelevare'] = $row['quantita'] - $row['qta_prelevata'];

        $row['collocazione'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT nome FROM __report_giacenza_magazzini__ WHERE id_articolo = ? AND totale_proprio > 0',
            array( 
                array( 's' => $row['id_articolo'] )
            )
        );

    }

    // debug
    // die( print_r( $ct['etc']['data'], true ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
