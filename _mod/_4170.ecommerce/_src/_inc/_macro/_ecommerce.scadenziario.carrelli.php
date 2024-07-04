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
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_documenti_carrelli__';

    // tabella per la gestione degli oggetti esistenti
	// $ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'corsi.form';

    // id della vista
    // $ct['view']['id'] = md5( $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] );

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'anagrafica' => 'cliente',
        'tipologia_contratto' => 'acquisto',
        'prezzo_lordo_finale' => 'totale dovuto',
        'pagato' => 'totale pagato',
        'rateizzato' => 'totale rateizzato',
        // 'scaduto' => 'totale scaduto',
        'sospeso' => 'totale in sospeso',
        'data_acquisto' => 'data acquisto',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'anagrafica' => 'text-left d-none d-md-table-cell',
        'pagato' => 'text-right',
        'rateizzato' => 'text-right',
        'scaduto' => 'text-right',
        'sospeso' => 'text-right',
        NULL => 'nowrap'
    );

    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // elaborazione dati
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            $row['pagato'] = writeCurrency( $row['pagato'] );
            $row['rateizzato'] = writeCurrency( $row['rateizzato'] );
            $row['scaduto'] = writeCurrency( $row['scaduto'] );
            $row['sospeso'] = writeCurrency( $row['sospeso'] );

        }
    }
