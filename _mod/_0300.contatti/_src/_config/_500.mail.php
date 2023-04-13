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
# TODO il from va specificato per forza, perché dichiarato in questo modo non è "sovrascritto" dalla configurazione custom
#            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
            'oggetto' => 'invio modulo: {{ dt.modulo }}',
            'testo' => '<ul>{% for k,v in dt %}<li><b>{{ k }}:</b> {% if v is iterable %}<ul>'.
                '{% for kk,vv in v %}<li><b>{{ kk }}:</b> {{ vv }}</li>{% endfor %}</ul>'.
                '{% else %}{{ v }}{% endif %}</li>{% endfor %}</ul>'
	    )
	);

	$cf['mail']['tpl']['DEFAULT_RINGRAZIAMENTO_CONTATTI'] = array(
	    'type' => 'twig',
	    'it-IT' => array(
# TODO il from va specificato per forza, perché dichiarato in questo modo non è "sovrascritto" dalla configurazione custom
#            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
            'oggetto' => 'grazie {{ dt.nome }}!',
            'testo' => 'caro {{ dt.nome }}, grazie per averci contattati!'
#	    ),
#	    'en-GB' => array(
#            'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
#            'oggetto' => 'thank you {{ dt.nome }}!',
#            'testo' => 'dear {{ dt.nome }}, thank you for your request!'
	    )
	);

# TODO specificare nello status se i from non sono specificati?
