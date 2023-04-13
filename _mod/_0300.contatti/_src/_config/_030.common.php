<?php

    /**
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // comportamento di default
	$cf['contatti']['default'] = array(
	    'mail' => array(
            "interna" => array(
                'destinatari' => array( 'webmaster' => 'info@' . $cf['site']['domain'] ),
                'language' => 'it-IT',
                'exclude' => array( '__status__' ),
                'template' => 'DEFAULT_CONTATTI'
            ),
            "esterna" => array(
                'destinatari' => array( '{{ dt.nome }}' => '{{ dt.mail }}' ),
                'exclude' => array( '__status__' ),
                'template' => 'DEFAULT_RINGRAZIAMENTO_CONTATTI'
            )
	    ),
	    'backend' => array(
            array(
                'type' =>  DB_MYSQL,
                'table' => 'contatti'
            )
/*
        ),
        'privacy' => array(
            'titolo' => array(
                'it-IT' => 'modulo contatti'
            ),
            'descrizione' => array(
                'it-IT' => 'Questo modulo può essere utilizzato dagli utenti del sito per inviare richieste di contatto generiche.'
            ),
            'finalita' => array(
                'risposta' => array(
                    'informativa' => array(
                        'it-IT' => 'risposta alla richiesta di contatto generica'
                    ),
                    'modulo' => array(
                        'it-IT' => 'autorizzo il trattamento dei miei dati per la comunicazione della risposta alla mia domanda'
                    ),
                    'required' => true
                ),
                'marketing' => array(
                    'informativa' => array(
                        'it-IT' => 'invio di comunicazioni commerciali'
                    ),
                    'modulo' => array(
                        'it-IT' => 'autorizzo il trattamento dei miei dati per la comunicazione di proposte commerciali'
                    ),
                    'required' => false
                )
            )
*/
        )
	);

    // configurazione extra
	if( isset( $cx['contatti'] ) ) {
	    $cf['contatti'] = array_replace_recursive( $cf['contatti'], $cx['contatti'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['contatti'] ) ) {
	    $cf['contatti'] = array_replace_recursive( $cf['contatti'], $cf['site']['contatti'] );
	}

    // collegamento all'array $ct
	$ct['contatti']					= &$cf['contatti'];

    // debug
	// print_r( $cf['contatti'] );
