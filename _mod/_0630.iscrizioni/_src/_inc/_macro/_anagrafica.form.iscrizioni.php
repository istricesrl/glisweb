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
	$ct['view']['table'] = 'contratti_anagrafica';

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
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_progetto' => 'd-none',
	    'id_contratto' => 'd-none',
        'id_anagrafica' => 'd-none',
        'codice' => 'text-left d-none d-md-table-cell',
        'tipologia' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

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
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

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

