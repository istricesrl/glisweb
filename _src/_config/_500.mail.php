<?php

    /**
     * dichiarazione dei template per la posta
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

    // NOTA per convenzione passare sempre al template mail le seguenti chiavi 'ct' => $ct e 'dt' => <datiDellaMail>

    // array del template mail di default
	$cf['mail']['tpl']['DEFAULT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'template di default',
			'testo' => 'template di default'
	    )
	);

    // array dei template mail di test
	$cf['mail']['tpl']['MAIL_TEST_TEMPLATE'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( 'GlisWeb' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'prova sistema di template per le mail',
			'testo' => '<p>caro {{ destinatario.nome }} {{ destinatario.cognome }},</p><ul>{% for k,v in dt %}<li><b>{{ k }}:</b> {{ v }}</li>{% endfor %}</ul>',
			'attach' => array( 'sitemap' => DIR_ETC . '_current.conf' )
	    )
	);

    // array dei template mail
	$cf['mail']['tpl']['DEFAULT_NUOVO_ACCOUNT_ATTIVO'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'creazione nuovo account per {{ dt.nome }}',
            'testo' => '<p>Gentile {{ dt.nome }}, il suo account è stato creato e attivato, utilizzi i seguenti dati per effettuare l\'accesso:</p><ul><li><strong>username:</strong> {{ dt.username }}</li><li><strong>password:</strong> {{ dt.password }}</li></ul><p>Buona giornata!</p>'
	    )
	);

    // array del template mail per notifica attivazione account
	$cf['mail']['tpl']['DEFAULT_ATTIVAZIONE_ACCOUNT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'Attivazione account',
			'testo' => '<p>Gentile utente, il suo account è stato attivato dagli amministratori. Utilizzi questo link per effettuare il login:<br/>{{ ct.pages.dashboard.url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
	    )
	);

    // array del template mail per notifica disattivazione account
	$cf['mail']['tpl']['DEFAULT_DISATTIVAZIONE_ACCOUNT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'Disattivazione account',
			'testo' => '<p>Gentile utente, il suo account è stato disattivato dagli amministratori. Non le sarà più possibile effettuare l\'accesso a <br/>{{ ct.pages.dashboard.url[ ct.localization.language.ietf ] }}</p>'
	    )
	);

    // array dei template mail
	$cf['mail']['tpl']['DEFAULT_REIMPOSTAZIONE_PASSWORD'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
		'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
		'oggetto' => 'reimpostazione password',
		'testo' => '<p>Gentile utente, utilizzi questo link per reimpostare la sua password:<br>{{ ct.pages[ dt.pg ].url[ ct.localization.language.ietf ] }}?tk={{ dt.tk }}</p>'
	    )
	);

	// array dei template mail di test
	$cf['mail']['tpl']['NOTIFICA_NUOVO_ACCOUNT'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( 'GlisWeb' => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'nuovo account per il sito {{ ct.site.fqdn }}',
			'testo' => '<p>caro {{ dt.nome }} {{ dt.cognome }},</p><p>siamo lieti di informarla che il suo account per accedere al sito è attivo; può effettuare il login utilizzando i seguenti parametri:</p>'.
				'<ul>{% if dt.url %}<li>indirizzo: {{ dt.url }}</li>{% endif %}<li>username: {{ dt.username }}</li><li>password: {{ dt.password }}</li></ul><p>Cordiali saluti.</p>',
			'attach' => array( 'sitemap' => DIR_ETC . '_current.conf' )
	    )
	);