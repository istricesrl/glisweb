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
	/*	'__acl_anagrafica__' => array(
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
		),*/
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
	    'anagrafica_attivi' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'anagrafica_archiviati' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'anagrafica_categorie' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'anagrafica_cittadinanze' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
#		'anagrafica_condizioni_pagamento' => array(
#			CONTROL_FULL => array( 'roots' )
#		),
		'anagrafica_indirizzi' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
#		'anagrafica_modalita_pagamento' => array(
#		CONTROL_FULL => array( 'roots' ),
#		CONTROL_FILTERED => array( 'staff' )
#		),
#	    'anagrafica_ruoli' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'anagrafica_settori' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'badge' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'relazioni_anagrafica' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
#		'attivita' => array(
#		CONTROL_FULL => array( 'roots' ),
#		CONTROL_FILTERED => array( 'staff' )
#	    ),
	    'audio' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'categorie_anagrafica' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
#		'categorie_attivita' => array(
#		CONTROL_FULL => array( 'roots' )
#		),
	    'comuni' => array(
		CONTROL_FULL => array( 'roots' ),
		METHOD_GET => array( 'staff', 'users', 'guests' )
		),
	    'contenuti' => array(
			CONTROL_FULL => array( 'roots' ,'staff'),
		),
#	    'cron' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'date' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'file' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'gruppi' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
	    ),
		'iban' => array(
			CONTROL_FULL => array( 'roots','staff' )
		),
		'immagini' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
#	    'immagini_anagrafica' => array(
#		CONTROL_FULL => array( 'roots' ),
#		CONTROL_FILTERED => array( 'staff' )
#	    ),
	    'indirizzi' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
		'indirizzi_caratteristiche' => array(
			CONTROL_FULL => array( 'roots','staff' )
	    ),
	    'job' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )	
	    ),
	    'luoghi' => array(
		CONTROL_FULL => array( 'roots', 'staff' )
	    ),
#		'macro' => array(
#		CONTROL_FULL => array( 'roots' )
#		),
		'mail' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'mail_out' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'mail_sent' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'metadati' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
		),
		'periodi' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
		),
#		'progetti_anagrafica' => array(
#			CONTROL_FULL => array( 'roots' ),
#			CONTROL_FILTERED => array( 'staff' )
#		),
#		'progetti_certificazioni' => array(
#            CONTROL_FULL => array( 'roots' )
#        ),
#	    'prezzi' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
#	    'recensioni' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'redirect' => array(
		CONTROL_FULL => array( 'roots', 'staff' )
	    ),
#	    'settori' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'sms_out' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'sms_sent' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
		'task' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
		),
	    'telefoni' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'template' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
#	    'test' => array(
#		CONTROL_FULL => array( 'roots' )
#	    ),
	    'zone_indirizzi' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
		'tipologie_luoghi' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
		),
	    'tipologie_periodi' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
	    ),
		'tipologie_zone' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
		),
	    'ranking' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
		),
		'reparti' => array(
			CONTROL_FULL => array( 'roots' ),
			METHOD_GET => array( 'staff' )
		),
#		'todo' => array(
#			CONTROL_FULL => array( 'roots' ),
#			CONTROL_FILTERED => array( 'staff' )
#		),
#		'todo_archivio' => array(
#			CONTROL_FULL => array( 'roots' ),
#			CONTROL_FILTERED => array( 'staff' )
#		),
#		'todo_completa' => array(
#			CONTROL_FULL => array( 'roots' ),
#			CONTROL_FILTERED => array( 'staff' )
#		),
#		'turni' => array(
#			CONTROL_FULL => array( 'roots' )
#		),
	    'url' => array(
			CONTROL_FULL => array( 'roots', 'staff' )
	    ),
	    'video' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		),
	    'zone' => array(
			CONTROL_FULL => array( 'roots' ),
			CONTROL_FILTERED => array( 'staff' )
		)
	);
