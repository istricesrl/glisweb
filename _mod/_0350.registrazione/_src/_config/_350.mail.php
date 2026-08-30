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
	$cf['mail']['tpl']['DEFAULT_NUOVO_ACCOUNT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'creazione nuovo account per {{ dt.nome }}',
            'testo' => '<p>Gentile {{ dt.nome }}, utilizzi questo link per confermare il suo account:<br>{{ ct.pages[ pf.landing ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
	    )
	);

    $cf['mail']['tpl']['STANDARD_NUOVO_ACCOUNT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'creazione nuovo account per {{ dt.nome }}',
            'testo' => '<p>Gentile {{ dt.nome }} {{ dt.cognome }},</p><p>siamo lieti di informarla che il suo account per accedere al sito è stato creato; '.
                'per attivarlo deve fare click su questo link: {{ ct.pages[ pf.landing ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'.
				'<p>Una volta attivo potrà effettuare l\'accesso utilizzando questi dati:</p>'.
                '<ul><li>indirizzo: {{ ct.pages[ pf.landing ].url[ ct.localization.language.ietf ] }}</li><li>username: {{ dt.username }}</li><li>password: {{ dt.password }}</li></ul><p>Cordiali saluti.</p>',
		)
	);

	$cf['mail']['tpl']['DEFAULT_AGGIORNAMENTO_DATI'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'modifica dati account per {{ dt.nome }}',
            'testo' => '<p>Gentile {{ dt.nome }}, utilizzi questo link per confermare le modifiche al suo account:<br>{{ ct.pages[ pf.landing ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
	    )
	);
