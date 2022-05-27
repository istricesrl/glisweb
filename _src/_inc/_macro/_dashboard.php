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

	// RELAZIONI CON IL MODULO DOCUMENTI
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) && in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'inserimento fattura',
            'text' => 'inserisce una nuova fattura'
        );

    }

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) && in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // inserimento nuovo DDT
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'inserimento DDT',
            'text' => 'inserisce un nuovo DDT'
        );
        
    }

    // RELAZIONI CON IL MODULO MAILING
	if( in_array( "7000.mailing", $cf['mods']['active']['array'] ) ) {

        // inserimento nuovo invio mailing
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['mailing.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-bolt',
            'title' => 'crea mailing',
            'text' => 'crea nuovo invio mailing'
        );

    }