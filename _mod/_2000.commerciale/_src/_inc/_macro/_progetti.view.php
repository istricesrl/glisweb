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
	$ct['view']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        '__label__' => 'progetto',
        'cliente' => 'cliente'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
	    'tipologia' => 'nowrap d-none d-sm-table-cell',
	    'cliente' => 'text-left nowrap d-none d-sm-table-cell'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   