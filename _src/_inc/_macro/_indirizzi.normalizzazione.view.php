<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'anagrafica_indirizzi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'indirizzi.normalizzazione.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'codice_anagrafica' => 'codice',
        'anagrafica' => 'anagrafica',
        'categorie' => 'categorie',
        'indirizzo' => 'indirizzo',
        'data_ora_elaborazione' => 'elaborazione'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
        'anagrafica' => 'text-left',
        'categorie' => 'text-left',
	    'indirizzo' => 'text-left'
	);

    $ct['view']['__restrict__']['id_indirizzo']['NL'] = 1;

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
