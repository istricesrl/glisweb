<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'account';

    // tendina account
	$ct['etc']['select']['gruppi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM gruppi_view'
	);

    // tendina ruolo
	$ct['etc']['select']['se_amministratore'] = array(
	    array( 'id' => 1, '__label__' => 'amministratore' ),
	    array( 'id' => 0, '__label__' => 'membro' )
	);

    // tendine variabili
	if( isset( $_REQUEST['account']['id_anagrafica'] ) && ! empty( $_REQUEST['account']['id_anagrafica'] ) ) {

		// tendina anagrafica
		$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM anagrafica_view_static WHERE id = ?',
		    array( array( 's' => $_REQUEST['account']['id_anagrafica'] ) )
		);

	    // tendina mail
		$ct['etc']['select']['mail'] = mysqlCachedIndexedQuery(
		    $cf['memcache']['index'],
		    $cf['memcache']['connection'],
		    $cf['mysql']['connection'],
		    'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ?',
		    array( array( 's' => $_REQUEST['account']['id_anagrafica'] ) )
		);

	}

	$ct['etc']['mastri'] = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT r.id_mastro, r.nome, r.totale FROM __report_giacenza_crediti__ AS r WHERE r.id_account=?',
		array( array( 's' => $_REQUEST['account']['id'] ) )
	);






/* SUPER TODO :D questa roba deve stare nella controller post salvataggio dell'account, non qui!

    if( isset( $_REQUEST[ $ct['etc']['table'] ]['id'] ) ){
	// attivazione dell'account
	if( isset( $_REQUEST['__activation__'] )){
#	print_r('attiva');
	// attivo l'account
	$azione = mysqlQuery( $cf['mysql']['connection'], 'UPDATE account SET se_attivo = 1 WHERE id = ?', array( array('s' => $_REQUEST[ $ct['etc']['table'] ]['id']  ) ) ); 

//print_r($azione);
	if( $azione ){
	// se l'attivazione va a buon fine
	$_REQUEST[ $ct['etc']['table'] ]['se_attivo'] = 1;

	$account = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM account_view '.
								'LEFT JOIN mail ON mail.id = account_view.id_mail '.
								'WHERE account_view.id = ?',
							array( array('s' =>  $_REQUEST[ $ct['etc']['table'] ]['id'] ) ) );
	// creo il token
		$tk = md5( $account['username'].$account['password'] );
	// invio la mail con il link e il token
		queueMailFromTemplate(
		    $cf['mysql']['connection'],
		    $cf['mail']['tpl']['DEFAULT_ATTIVAZIONE_ACCOUNT'],
		    array( 'dati' => array( 'tk' => $tk ), 'ct' => $ct ),
		    strtotime( '+2 minutes' ),
		    array( $account['username'] => $account['indirizzo'] ),
		    $cf['localization']['language']['ietf']
		);
	}
	}

	// disattivazione dell'account
	if( isset( $_REQUEST['__disabling__'] )){
	// disattivo l'account
	$azione = mysqlQuery( $cf['mysql']['connection'], 'UPDATE account SET se_attivo = NULL WHERE id = ?', array( array('s' => $_REQUEST[ $ct['etc']['table'] ]['id']  ) ) ); 

	if( $azione ){
	$_REQUEST[ $ct['etc']['table'] ]['se_attivo']= NULL;
	// se la disattivazione va a buon fine
//	$ct['etc']['attivo'] = 0;
	$account = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM account_view '.
								'LEFT JOIN mail ON mail.id = account_view.id_mail '.
								'WHERE account_view.id = ?',
							array( array('s' =>  $_REQUEST[ $ct['etc']['table'] ]['id'] ) ) );
	// creo il token
		$tk = md5( $account['username'].$account['password'] );
	// invio la mail con il link e il token
		queueMailFromTemplate(
		    $cf['mysql']['connection'],
		    $cf['mail']['tpl']['DEFAULT_DISATTIVAZIONE_ACCOUNT'],
		    array( 'dati' => array( 'tk' => $tk ), 'ct' => $ct ),
		    strtotime( '+2 minutes' ),
		    array( $account['username'] => $account['indirizzo'] ),
		    $cf['localization']['language']['ietf']
		);
	}
	}
    }

*/

    // impedisco che la password cifrata venga inviata al modulo
	unset( $_REQUEST['account']['password'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
