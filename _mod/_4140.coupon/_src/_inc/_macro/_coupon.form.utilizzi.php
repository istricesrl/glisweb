<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'coupon';

    // tabella della vista
	$ct['view']['table'] = '__report_utilizzi_coupon__';

    // modalità della vista
    $ct['view']['data']['__report_mode__'] = 1;

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_pagamento' => 'data utilizzo',
        'tipo' => 'usato per',
        'riferimento' => 'riferimento',
        'importo_lordo_totale' => 'importo dovuto',
        'coupon_valore' => 'utilizzo coupon',
        'importo_lordo_finale' => 'importo pagato',
#	    'nome' => 'articolo',
#        'id_prodotto' => 'id_prodotto',
#        'ean' => 'ean'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
        'riferimento' => 'text-left',
        'importo_lordo_totale' => 'text-right',
        'coupon_valore' => 'text-right',
        'importo_lordo_finale' => 'text-right',
#	    'nome' => 'text-left',
#        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
#    $ct['view']['open']['page'] = 'articoli.form';
#    $ct['view']['open']['table'] = 'articoli';
#    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
#	$ct['view']['insert']['page'] = 'articoli.form';

    // campo per il preset di apertura
#	$ct['view']['open']['preset']['field'] = 'id_prodotto';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // elaborazione dati
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            $row['importo_lordo_totale'] = writeCurrency( $row['importo_lordo_totale'] );
            $row['coupon_valore'] = writeCurrency( $row['coupon_valore'] );
            $row['importo_lordo_finale'] = writeCurrency( $row['importo_lordo_finale'] );

        }
    }
