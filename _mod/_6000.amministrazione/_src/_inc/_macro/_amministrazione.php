<?php

    /**
     * macro dashboard amministrazione
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

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'inserimento fattura',
            'text' => 'inserisce una nuova fattura'
        );
    }