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
	$ct['view']['table'] = 'template_mail';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'template.mail.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'ruolo' => 'ruolo',
	    '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'ruolo' => 'text-left',
	    '__label__' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
