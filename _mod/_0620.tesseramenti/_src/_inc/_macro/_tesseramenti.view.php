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
	$ct['view']['table'] = 'tesseramenti';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'numero tessera',
        'iscritti' => 'anagrafica',
        'tipologia_rinnovo' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'codice' => 'text-left d-none d-md-table-cell',
        'iscritti' => 'text-left',
        'tipologia_rinnovo' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';