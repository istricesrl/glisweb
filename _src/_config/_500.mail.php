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
