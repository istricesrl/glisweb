<?php

    /**
     * macro dashboard
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

    // inserimento nuova anagrafica
	$ct['page']['contents']['metro']['scorciatoie'][] = array(
	    'url' => $cf['contents']['pages']['anagrafica.form']['url'][ LINGUA_CORRENTE ],
	    'icon' => NULL,
	    'fa' => 'fa-bolt',
	    'title' => 'inserimento anagrafica',
	    'text' => 'inserisce una nuova anagrafica'
	);

	// RELAZIONI CON IL MODULO 
	if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'inserimento fattura',
            'text' => 'inserisce una nuova fattura'
        );

    }