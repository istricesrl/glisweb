<?php

    /**
     * macro dashboard mailing
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

    // inserimento nuovo invio mailing
    $ct['page']['contents']['metro']['scorciatoie'][] = array(
        'url' => $cf['contents']['pages']['mailing.form']['url'][ LINGUA_CORRENTE ],
        'icon' => NULL,
        'fa' => 'fa-plus-square',
        'title' => 'crea mailing',
        'text' => 'crea nuovo invio mailing',
        'colspan' => 3
    );
