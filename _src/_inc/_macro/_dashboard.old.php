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
	    '00.notifiche' => array(
			'label' => 'notifiche'
		),
	    '10.scorciatoie_anagrafica' => array(
			'label' => 'scorciatoie anagrafica'
        ),
        '20.scorciatoie_amministrazione' => array(
			'label' => 'scorciatoie amministrazione'
		),
        '30.scorciatoie_logistica' => array(
			'label' => 'scorciatoie logistica'
		),
        '40.scorciatoie_mailing' => array(
			'label' => 'scorciatoie mailing'
		)
	);
/*
    // view anagrafica
	$ct['page']['contents']['metro']['10.scorciatoie_anagrafica'][] = array(
	    'url' => $cf['contents']['pages']['anagrafica.view']['url'][ LINGUA_CORRENTE ],
	    'icon' => NULL,
	    'fa' => 'fa-list',
	    'title' => 'lista anagrafica',
	    'text' => 'mostra la lista delle anagrafica',
        'colspan' => 3
	);

    // inserimento nuova anagrafica
	$ct['page']['contents']['metro']['10.scorciatoie_anagrafica'][] = array(
	    'url' => $cf['contents']['pages']['anagrafica.form']['url'][ LINGUA_CORRENTE ],
	    'icon' => NULL,
	    'fa' => 'fa-plus-square',
	    'title' => 'inserimento anagrafica',
	    'text' => 'inserisce una nuova anagrafica',
        'colspan' => 3
	);

	// RELAZIONI CON IL MODULO DOCUMENTI
	if( in_array( "6000.amministrazione", $cf['mods']['active']['array'] ) && in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // view fattura attiva
        $ct['page']['contents']['metro']['20.scorciatoie_amministrazione'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.view']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-list',
            'title' => 'lista fatture attive',
            'text' => 'mostra la lista delle fattura attiva',
            'colspan' => 3
        );

        // inserimento nuova fattura attiva
        $ct['page']['contents']['metro']['20.scorciatoie_amministrazione'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento fattura attiva',
            'text' => 'inserisce una nuova fattura attiva',
            'colspan' => 3
        );

    }

    // RELAZIONI CON IL MODULO LOGISTICA
	if( in_array( "5000.logistica", $cf['mods']['active']['array'] ) && in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // view DDT attivo
        $ct['page']['contents']['metro']['30.scorciatoie_logistica'][] = array(
            'url' => $cf['contents']['pages']['ddt.magazzini.view']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-list',
            'title' => 'lista DDT attivi',
            'text' => 'mostra la lista dei DDT attivi',
            'colspan' => 3
        );

        // inserimento nuovo DDT attivo
        $ct['page']['contents']['metro']['30.scorciatoie_logistica'][] = array(
            'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento DDT attivo',
            'text' => 'inserisce un nuovo DDT attivo',
            'colspan' => 3
        );
        
    }

    // RELAZIONI CON IL MODULO MAILING
	if( in_array( "7000.mailing", $cf['mods']['active']['array'] ) ) {

        // view mailing
        $ct['page']['contents']['metro']['40.scorciatoie_mailing'][] = array(
            'url' => $cf['contents']['pages']['mailing.view']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-list',
            'title' => 'lista mailing',
            'text' => 'mostra la lista dei mailing',
            'colspan' => 3
        );

        // inserimento nuovo invio mailing
        $ct['page']['contents']['metro']['40.scorciatoie_mailing'][] = array(
            'url' => $cf['contents']['pages']['mailing.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'crea mailing',
            'text' => 'crea nuovo invio mailing',
            'colspan' => 3
        );

    }
*/
