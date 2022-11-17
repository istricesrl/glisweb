<?php

    /**
     * macro form progetti produzione tools
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

    // tabella gestita
	$ct['form']['table'] = 'anagrafica_progetti';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		    'label' => 'azioni'
        ),
	    'report' => array(
		    'label' => 'report'
	    )
	);

    $ct['page']['contents']['metro']['azioni'][] = array(
        'url' => $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ].'?idAttesa='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'target' => '_self',
        'icon' => NULL,
        'fa' => 'fa-handshake-o',
        'title' => 'trasforma in iscrizione',
        'text' => 'crea una nuova iscrizione e archivia questa richiesta'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
