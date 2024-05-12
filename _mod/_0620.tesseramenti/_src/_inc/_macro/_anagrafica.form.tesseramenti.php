<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = '__report_tesseramenti_anagrafica__';
    $ct['view']['data']['__report_mode__'] = 1;

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'id_anagrafica' => 'anagrafica',
        'se_tesseramento' => 'tesseramento',
        'tessera' => 'numero tessera',
        'id_tipologia' => 'ID tipologia',
        'id_contratto' => 'ID contratto',
        'tipologia' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine',
        'pagamento' => 'pagamento',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'se_tesseramento' => 'd-none',
#        'codice' => 'text-left d-none d-md-table-cell',
        'id_tipologia' => 'd-none',
        'id_contratto' => 'd-none',
        'tipologia' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // colonne da non prelevare dal database
    $ct['view']['extra']['cols'] = array( 'pagamento' );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'tesseramenti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        
        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['se_tesseramento']['EQ'] = 1;
        $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {

            /*
            $pagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT documenti_articoli.id FROM documenti_articoli INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id INNER JOIN rinnovi ON rinnovi.id = documenti_articoli.id_rinnovo WHERE rinnovi.id_contratto = ? AND pagamenti.timestamp_pagamento IS NOT NULL', array( array( 's' => $row['id'] ) ) );
            if( empty( $pagato ) ) {
                $articolo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT articoli.id FROM articoli INNER JOIN metadati ON metadati.id_articolo = articoli.id WHERE metadati.nome = "acquisto_rinnovi|id_tipologia" AND metadati.testo = ?', array( array( 's' => $row['id_tipologia'] ) ) );
                $ordinato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT carrelli.id FROM carrelli_articoli INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello WHERE id_articolo = ? AND carrelli_articoli.destinatario_id_anagrafica = ? AND carrelli.session = ?', array( array( 's' => $articolo ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ), array( 's' => $cf['session']['id'] ) ) );

                // die($ordinato);
                if( empty( $ordinato ) ) {
                    if( isset( $cf['contents']['pages']['ecommerce.carrello']['url'][ LINGUA_CORRENTE ] ) ) {
                        // $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$articolo.'&__carrello__[__articolo__][destinatario_id_anagrafica]='.$_REQUEST[ $ct['form']['table'] ]['id'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                        $row[ NULL ] =  '<a href="' . $cf['contents']['pages']['ecommerce.carrello']['url'][ LINGUA_CORRENTE ] . '?__carrello__[__articolo__][id_articolo]=' . $articolo . '&__carrello__[__articolo__][destinatario_id_anagrafica]='.$_REQUEST[ $ct['form']['table'] ]['id'].'"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                    }
                }
            }
            */

            // TODO considerare solo i rinnovi di tipo ordinario ecc. escludere i rinnovi di ripresa dopo una sospensione
            // OPPURE utilizzare i periodi per le sospensioni vedere cosa è meno un casino
            $rinnovi = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT rinnovi.*, 
                sum( documenti_articoli.importo_lordo_totale ) AS pagato, sum( carrelli_articoli.prezzo_lordo_finale ) AS ordinato
                FROM rinnovi
                LEFT JOIN documenti_articoli ON documenti_articoli.id_rinnovo = rinnovi.id
                LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id
                WHERE rinnovi.id_contratto = ?
                GROUP BY rinnovi.id
                ORDER BY rinnovi.data_fine DESC',
                array( array( 's' => $row['id_contratto'] ) )
            );

            if( empty( $rinnovi ) ) {
                $row['pagamento'] = 'nessun rinnovo trovato';
            } elseif( $rinnovi['ordinato'] == 0 ) {
                $row['pagamento'] = 'da aggiungere al carrello';
            } elseif( $rinnovi['pagato'] == 0 ) {
                $row['pagamento'] = 'da pagare';
            } elseif( $rinnovi['pagato'] < $rinnovi['ordinato'] ) {
                $row['pagamento'] = 'da pagare € ' . number_format( $rinnovi['ordinato'] - $rinnovi['pagato'], 2, ',', '.');
                $row[ NULL ] =  '<a href="' . $cf['contents']['pages']['ecommerce.pagamento']['url'][ LINGUA_CORRENTE ] . '?__pagamenti__[id_cliente]='.$row['id_anagrafica'].'"><span class="media-left"><i class="fa fa-shopping-cart"></i></span></a>';
            } elseif( $rinnovi['pagato'] == $rinnovi['ordinato'] ) {
                $row['pagamento'] = 'pagato';
            }

        }
    }

