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

	// array dei template mail di test
	$cf['mail']['tpl']['RIEPILOGO_ATTIVITA_GIORNATA'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
			'from' => array( "{{ ct.site.name['it-IT'] }}" => 'noreply@{{ ct.site.fqdn }}' ),
			'oggetto' => 'promemoria attività per oggi dal sito {{ ct.site.fqdn }}',
			'testo' => 
                '<p>caro {{ dt.nome }} {{ dt.cognome }},</p>'.
                '<p>hai programmato alcune attività per oggi:</p>'.
				'<ul>{% for a in dt.attivita %}<li>{{ a.ora_inizio_programmazione }} {{ a.nome }}</li>{% endfor %}</ul>'.
                '<p>Cordiali saluti.</p>'
	    )
	);
