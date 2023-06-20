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
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'template';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'template.mail.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'nome' => 'nome',
	    '__label__' => 'ruolo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    '__label__' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
