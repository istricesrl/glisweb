<?php

    /**
     * macro dashboard logistica
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'notifiche' => array(
			'label' => 'notifiche'
		),
	    'scorciatoie' => array(
			'label' => 'azioni rapide'
		)
	);

	if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // inserimento nuovo DDT
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'inserimento DDT',
            'text' => 'inserisce un nuovo DDT'
        );
    }