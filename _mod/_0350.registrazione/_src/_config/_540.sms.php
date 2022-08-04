<?php

    /**
     * server e profili SMS
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

    // array dei template SMS di test
	$cf['sms']['tpl']['DEFAULT_NUOVO_ACCOUNT'] = array(
		'type' => 'twig',
        'it-IT' => array(
            'from' => array( 'GLISWEB' => '+39 329 00 00 000' ),
            'testo' => 'Gentile {{ dt.nome }}, il codice OTP per attivare il suo account è {{ dt.ts }}'
        )
	);
