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
    $ct['form']['table'] = 'articoli';
    
    // tabella della vista
	$ct['view']['table'] = 'modalita_spedizione';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'zona' => 'zona',
        'id_prodotto' => 'prodotto',
        'id_articolo' => 'articolo',
        'lotto_spedizione' => 'lotto',
        'importo_netto' => 'netto',
        'iva' => 'IVA',
        'giorni_spedizione' => 'TTS',
        'giorni_consegna' => 'TTC',
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
	    'importo_netto' => 'text-right'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'modalita.spedizione.form';
    $ct['view']['open']['table'] = 'modalita_spedizione';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'modalita.spedizione.form';
	$ct['view']['insert']['field'] = 'id_articolo';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_articolo';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_articolo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // inserimento rapido
	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/articoli.form.modalita.spedizione.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // tendina IVA
	$ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM iva_view' );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // operazioni sui dati
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            $row['importo_netto'] = writeCurrency( $row['importo_netto'] );

        }
    }
