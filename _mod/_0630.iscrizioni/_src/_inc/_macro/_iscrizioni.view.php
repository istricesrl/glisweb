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
	$ct['view']['table'] = 'iscrizioni';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'iscrizioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'tipologia',
        'id_destinatario' => 'anagrafica'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'codice' => 'text-left d-none d-md-table-cell',
        'id_destinatario' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';