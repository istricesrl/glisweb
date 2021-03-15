<?php

    /**
     * configurazioni generali della posta
     *
     *
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

    // array dei template mail
	$cf['mail']['tpl']['DEFAULT_REIMPOSTAZIONE_PASSWORD'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
		'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
		'oggetto' => 'reimpostazione password',
		'testo' => '<p>Gentile utente, utilizzi questo link per reimpostare la sua password:<br>{{ ct.pages.reset_password.url[ ct.localization.language.ietf ] }}?tk={{ dati.tk }}</p>'
	    )
	);

