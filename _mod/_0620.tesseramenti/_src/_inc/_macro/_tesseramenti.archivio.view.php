<?php

    /**
     * macro form tesseramenti archivio
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

    // tabella della vista
	$ct['view']['table'] = 'tesseramenti_archiviati';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'codice' => 'tipologia',
        'iscritti' => 'iscritto'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'codice' => 'text-left d-none d-md-table-cell',
        'iscritti' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
