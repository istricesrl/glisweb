<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	// $ct['view']['table'] = 'contratti_anagrafica';
	$ct['view']['table'] = '__report_iscrizioni_anagrafica__';
    $ct['view']['data']['__report_mode__'] = 1;

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'id_contratto' => '#',
        'id_anagrafica' => 'anagrafica',
        'id_progetto' => 'ID corso',
        'progetto' => 'corso',
        'tipologia' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine',
        'pagamento' => 'pagamento',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_progetto' => 'd-none',
	    'id_contratto' => 'd-none',
        'id_anagrafica' => 'd-none',
        'codice' => 'text-left d-none d-md-table-cell',
        'progetto' => 'text-left',
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
	$ct['view']['open']['page'] = 'iscrizioni.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'iscrizioni.form';

    // tasti aggiuntivi per l'inserimento
    $ct['view']['insert']['extras'][] = array(
        'icon' => 'fa-graduation-cap',
        'page' => 'corsi.view',
        'options' => array(
            '__work__[anagrafica][items]['.$_REQUEST[ $ct['form']['table'] ]['id'].'][id]' => $_REQUEST[ $ct['form']['table'] ]['id'],
            '__work__[anagrafica][items]['.$_REQUEST[ $ct['form']['table'] ]['id'].'][label]' => mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $ct['form']['table'] . getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $ct['form']['table'] ) . ' WHERE id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
        )
    );

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        
        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
        $ct['view']['__restrict__']['se_iscrizione']['EQ'] = 1;

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_MOD . '_0010.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
/*
    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $pagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT documenti_articoli.id FROM documenti_articoli INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id INNER JOIN rinnovi ON rinnovi.id = documenti_articoli.id_rinnovo WHERE rinnovi.id_contratto = ? AND pagamenti.timestamp_pagamento IS NOT NULL', array( array( 's' => $row['id'] ) ) );
            if( empty( $pagato ) ) {
#                $articolo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT articoli.id FROM articoli INNER JOIN metadati ON metadati.id_articolo = articoli.id WHERE metadati.nome = "acquisto_rinnovi|id_tipologia" AND metadati.testo = ?', array( array( 's' => $row['id_tipologia'] ) ) );
                $ordinato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT carrelli.id FROM carrelli_articoli INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto INNER JOIN progetti ON progetti.id_prodotto = prodotti.id WHERE progetti.id = ? AND carrelli_articoli.destinatario_id_anagrafica = ? AND carrelli.session = ?', array( array( 's' => $row['id_progetto'] ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ), array( 's' => $cf['session']['id'] ) ) );
# die($ordinato);
                if( empty( $ordinato ) ) {
#                    $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$articolo.'&__carrello__[__articolo__][destinatario_id_anagrafica]='.$_REQUEST[ $ct['form']['table'] ]['id'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                    $row[ NULL ] =  '<a href="' . $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ] . '?contratti[id]=' . $row['id_contratto'] . '&__backurl__='. $ct['page']['backurl'][LINGUA_CORRENTE] .'"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                }
            }
        }
    }
*/

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {

            // azioni
            $buttons = '';

/*
            $pagato = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT documenti_articoli.id 
                FROM documenti_articoli 
                INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento 
                INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id 
                INNER JOIN rinnovi ON rinnovi.id = documenti_articoli.id_rinnovo 
                WHERE rinnovi.id_contratto = ? 
                AND pagamenti.timestamp_pagamento IS NOT NULL',
                array( array( 's' => $row['id'] ) )
            );

            if( empty( $pagato ) ) {
                $articolo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT articoli.id FROM articoli INNER JOIN metadati ON metadati.id_articolo = articoli.id WHERE metadati.nome = "acquisto_rinnovi|id_tipologia" AND metadati.testo = ?', array( array( 's' => $row['id_tipologia'] ) ) );
                $ordinato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT carrelli.id FROM carrelli_articoli INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello WHERE id_articolo = ? AND carrelli_articoli.destinatario_id_anagrafica = ? AND carrelli.session = ?', array( array( 's' => $articolo ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ), array( 's' => $cf['session']['id'] ) ) );

                // die($ordinato);
                if( empty( $ordinato ) ) {
                    // $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$articolo.'&__carrello__[__articolo__][destinatario_id_anagrafica]='.$_REQUEST[ $ct['form']['table'] ]['id'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                    $row[ NULL ] =  '<a href="' . $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ] . '?contratti[id]=' . $row['id_contratto'] . '&__backurl__='. $ct['page']['backurl'][LINGUA_CORRENTE] .'"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                }

                $row['pagamento'] = 'da aggiungere al carrello';
            } else {
                $row['pagamento'] = $pagato;
            }
*/

            // TODO considerare solo i rinnovi di tipo ordinario ecc. escludere i rinnovi di ripresa dopo una sospensione
            // OPPURE utilizzare i periodi per le sospensioni vedere cosa è meno un casino
            $documenti = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT rinnovi.*, 
                sum( documenti_articoli.importo_lordo_totale ) AS pagato,
                sum( pagamenti.coupon_valore ) AS pagato_coupon
                FROM rinnovi
                LEFT JOIN documenti_articoli ON documenti_articoli.id_rinnovo = rinnovi.id
                LEFT JOIN pagamenti ON pagamenti.id_documento = documenti_articoli.id_documento
                WHERE rinnovi.id_contratto = ?
                GROUP BY rinnovi.id
                ORDER BY rinnovi.data_fine DESC',
                array( array( 's' => $row['id_contratto'] ) )
            );

            $carrelliPagati = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT rinnovi.*, 
                sum( carrelli_articoli.prezzo_lordo_finale ) AS pagato_carrelli,
                sum( pagamenti.coupon_valore ) AS pagato_coupon_carrelli
                FROM rinnovi
                LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id
                LEFT JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello
                LEFT JOIN pagamenti ON pagamenti.id_carrelli_articoli = carrelli_articoli.id
                WHERE rinnovi.id_contratto = ? AND carrelli.timestamp_pagamento IS NOT NULL
                GROUP BY rinnovi.id
                ORDER BY rinnovi.data_fine DESC',
                array( array( 's' => $row['id_contratto'] ) )
            );

            $carrelli = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT rinnovi.*, 
                sum( carrelli_articoli.prezzo_lordo_finale ) AS ordinato,
                sum( pagamenti.coupon_valore ) AS pagato_coupon
                FROM rinnovi
                LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id
                LEFT JOIN pagamenti ON pagamenti.id_carrelli_articoli = carrelli_articoli.id
                WHERE rinnovi.id_contratto = ?
                GROUP BY rinnovi.id
                ORDER BY rinnovi.data_fine DESC',
                array( array( 's' => $row['id_contratto'] ) )
            );

            $rinnovi = array_merge( $documenti, $carrelli, $carrelliPagati );

            if( ! isset( $rinnovi['pagato_carrelli'] ) ) {
                $rinnovi['pagato_carrelli'] = 0;
            }

            if( ! isset( $rinnovi['ordinato'] ) ) {
                $rinnovi['ordinato'] = 0;
            }

            // die( print_r( $documenti, true ) );
            // die( print_r( $carrelliPagati, true ) );
            // die( print_r( $carrelli, true ) );
            // die( print_r( $rinnovi, true ) );

            if( empty( $rinnovi ) ) {
                $row['pagamento'] = 'nessun rinnovo trovato';
            } elseif( $rinnovi['ordinato'] == 0 ) {
                $checkCoupon = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT sum( coupon.sconto_fisso ) AS rimborso FROM coupon WHERE coupon.causale_id_contratto = ?',
                    array( array( 's' => $row['id_contratto'] ) )
                );
                // TODO adesso "ritirato" è relavivo all'intero contratto, ma bisogna considerare in realtà il ritiro
                // dal singolo rinnovo altrimenti se uno si ritira una volta e poi si abbona di nuovo allo stesso abbonamento
                // c'è il rischio che risulti come "ritirato" anche se non lo è
                if( empty( $checkCoupon ) ) {
                    $row['pagamento'] = 'da aggiungere al carrello';
                } else {
                    $row['pagamento'] = 'ritirato (rimborsati € ' . number_format( $checkCoupon, 2, ',', '.') . ')';
                }
            } elseif( $rinnovi['pagato'] == 0 && $rinnovi['pagato_carrelli'] == 0 ) {
                $row['pagamento'] = 'interamente da pagare € ' . number_format( $rinnovi['ordinato'], 2, ',', '.');
            } elseif( ( ( $rinnovi['pagato'] + $rinnovi['pagato_coupon'] ) < $rinnovi['ordinato'] ) && ( $rinnovi['pagato_carrelli'] < $rinnovi['ordinato'] ) ) {
                $row['pagamento'] = 'da pagare € ' . number_format( $rinnovi['ordinato'] - $rinnovi['pagato'], 2, ',', '.') . ' su € ' . number_format( $rinnovi['ordinato'], 2, ',', '.');
                // $row[ NULL ] =  '<a href="' . $cf['contents']['pages']['ecommerce.pagamento']['url'][ LINGUA_CORRENTE ] . '?__pagamenti__[id_cliente]='.$row['id_anagrafica'].'"><span class="media-left"><i class="fa fa-shopping-cart"></i></span></a>';
            } elseif( ( ( $rinnovi['pagato'] + $rinnovi['pagato_coupon'] ) == $rinnovi['ordinato'] ) || ( $rinnovi['pagato_carrelli'] == $rinnovi['ordinato'] ) ) {
                $row['pagamento'] = 'totalmente pagato € ' . number_format( $rinnovi['ordinato'], 2, ',', '.');
            }

            $href = $cf['contents']['pages']['iscrizioni.form.tools']['url'][ LINGUA_CORRENTE ] . '?contratti[id]=' . $row['id_contratto'] . '&__backurl__='. $ct['page']['backurl'][LINGUA_CORRENTE];
            $buttons .= '<a href="'.$href.'"><i class="fa fa-cogs"></i></a>';

            $row[ NULL ] = $buttons;

        }
    }
