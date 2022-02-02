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
            'oggetto' => 'creazione nuovo account per {{ dati.nome }}',
            'testo' => '<p>Gentile utente, utilizzi questo link per confermare il suo account:<br>{{ ct.pages.registrazione.url[ ct.localization.language.ietf ] }}?tk={{ dati.tk }}</p>'
	    )
	);

	$cf['mail']['tpl']['DEFAULT_AGGIORNAMENTO_DATI'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( '{{ ct.site.name[ ct.localization.language.ietf ] }}' => 'noreply@{{ ct.site.fqdn }}' ),
            'oggetto' => 'modifica dati account per {{ dati.nome }}',
            'testo' => '<p>Gentile utente, utilizzi questo link per confermare le modifiche al suo account:<br>{{ ct.pages.profilo.url[ ct.localization.language.ietf ] }}?tk={{ dati.tk }}</p>'
	    )
	);
