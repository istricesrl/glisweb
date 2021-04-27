<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo i permessi per le entità andrebbero dichiarati "più in basso" possibile, nei moduli che le usano
     * @todo documentare
     *
     * @file
     *
     */

    // array dei permessi
	$cf['auth']['permissions'] = array(
	    'account' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'account_gruppi' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'account_gruppi_attribuzione' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'anagrafica' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'anagrafica_archiviati' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'anagrafica_categorie' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'anagrafica_cittadinanze' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
#	    'anagrafica_clienti' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
		'anagrafica_condizioni_pagamento' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
		),
		'anagrafica_indirizzi' => array(
		CONTROL_FULL => array( 'roots' )
		),
		'anagrafica_modalita_pagamento' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
		),
#	    'anagrafica_ruoli' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'anagrafica_settori' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'attivita' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'audio' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'categorie_anagrafica' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'comuni' => array(
		CONTROL_FULL => array( 'roots' )
		),
	    'contenuti' => array(
		CONTROL_FULL => array( 'roots' )
		),
#	    'cron' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'date' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'file' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'gruppi' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
		'iban' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
		),
		'immagini' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
#	    'immagini_anagrafica' => array(
#		CONTROL_FULL => array( 'roots' ),
#		CONTROL_FILTERED => array( 'staff' )
#	    ),
	    'indirizzi' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'job' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
#	    'luoghi' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
		'macro' => array(
		CONTROL_FULL => array( 'roots' )
		),
		'mail' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'mail_out' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'mail_sent' => array(
			CONTROL_FULL => array( 'roots' )
	    ),
	    'metadati' => array(
		CONTROL_FULL => array( 'roots' )
		),
		'pianificazioni' => array(
			CONTROL_FULL => array( 'roots' )
		),
		'progetti' => array(
			CONTROL_FULL => array( 'roots' )
		),
		'progetti_anagrafica' => array(
			CONTROL_FULL => array( 'roots' )
		),
	    'pubblicazione' => array(
		CONTROL_FULL => array( 'roots' )
		),
#	    'prezzi' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'recensioni' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'redirect' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
#	    'settori' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'sms_out' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'sms_sent' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'telefoni' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'template_mail' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
	    'test' => array(
		CONTROL_FULL => array( 'roots' )
	    ),
#	    'tipologie_anagrafica' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'tipologie_attivita' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'tipologie_crm' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'tipologie_crm' => array(
		CONTROL_FULL => array( 'roots' )
		),
		'turni' => array(
			CONTROL_FULL => array( 'roots' )
		),
	    'video' => array(
			CONTROL_FULL => array( 'roots' )
		)
	);
