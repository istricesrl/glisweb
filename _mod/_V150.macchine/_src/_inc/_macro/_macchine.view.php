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
	$ct['view']['table'] = 'asset';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'macchine.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
	    'tipologia' => 'tipologia',
	    'codice' => 'matricola',
	    'nome' => 'nome',
	    'hostname' => 'host',
	    'ip_address' => 'IP address',
	    'note' => 'note',
        'data_ora_aggiornamento' => 'ultima trasmissione'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
