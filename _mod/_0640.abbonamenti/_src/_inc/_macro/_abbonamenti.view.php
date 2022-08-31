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
	$ct['view']['table'] = 'abbonamenti';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'abbonamenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'tipologia',
        'iscritti' => 'anagrafica',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'codice' => 'text-left d-none d-md-table-cell',
        'iscritti' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';