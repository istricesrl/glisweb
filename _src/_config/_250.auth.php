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
		'__acl_anagrafica__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_todo__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_progetti__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_progetti_produzione__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_documenti__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_documenti_articoli__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_scadenze__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'__acl_contatti__' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
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
		CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'anagrafica_archiviati' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
	    'anagrafica_categorie' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
		'anagrafica_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
	    'anagrafica_cittadinanze' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
		'anagrafica_condizioni_pagamento' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
		),
		'anagrafica_indirizzi' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
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
		'categorie_attivita' => array(
		CONTROL_FULL => array( 'roots' )
		),
	    'comuni' => array(
		CONTROL_FULL => array( 'roots' )
		),
	    'contenuti' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
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
	    'immagini_anagrafica' => array(
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
	    ),
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
		CONTROL_FULL => array( 'roots' ),
		CONTROL_FILTERED => array( 'staff' )
		),
		'pianificazioni' => array(
			CONTROL_FULL => array( 'roots' )
		),
		'progetti_anagrafica' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		),
		'progetti_certificazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
	    'pubblicazioni' => array(
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
	    'template' => array(
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
		'todo' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		),
		'todo_archivio' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		),
		'todo_completa' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		),
		'turni' => array(
			CONTROL_FULL => array( 'roots' )
		),
	    'video' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		)
	);
