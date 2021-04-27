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
	$cf['mail']['tpl']['DEFAULT_CONTATTI'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
            'oggetto' => 'invio modulo: {{ dati.modulo }}',
            'testo' => '<ul>{% for k,v in dati %}<li><b>{{ k }}:</b> {% if v is iterable %}<ul>{% for kk,vv in v %}<li><b>{{ kk }}:</b> {{ vv }}</li>{% endfor %}</ul>{% else %}{{ v }}{% endif %}</li>{% endfor %}</ul>'
	    )
	);

	$cf['mail']['tpl']['DEFAULT_RINGRAZIAMENTO_CONTATTI'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
            'oggetto' => 'grazie {{ dati.nome }}!',
            'testo' => 'caro {{ dati.nome }}, grazie per averci contattati!'
	    ),
	    'en-GB' => array(
            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
            'oggetto' => 'thank you {{ dati.nome }}!',
            'testo' => 'dear {{ dati.nome }}, thank you for your request!'
	    )
	);

