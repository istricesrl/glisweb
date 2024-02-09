<?php
    
    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // ...
    if( isset( $_REQUEST['account'] ) ) {

        // ...
        $account = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM account WHERE id=?',
            array( array( 's' => $_REQUEST['account'] ) )
        );

        // ...
        $status['anagrafica'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT nome, cognome FROM anagrafica WHERE id=?',
            array( array( 's' => $account['id_anagrafica'] ) )
        );

        // ...
        $status['mail'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT indirizzo FROM mail WHERE id_anagrafica=?',
            array( array( 's' => $account['id_anagrafica'] ) )
        );

        // genero una password casuale di sedici caratteri alfanumerici e speciali
        $password = bin2hex( openssl_random_pseudo_bytes( 8 ) );

        // aggiorno la password
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE account SET password = ? WHERE id = ?',
            array(
                array( 's' => md5( $password ) ),
                array( 's' => $account['id'] )
            )
        );

        // TODO l'url della pagina di atterraggio va resa parametrica
        $dt = array(
            'url' => $cf['contents']['pages']['admin']['url'][LINGUA_CORRENTE],
            'nome' => $status['anagrafica']['nome'],
            'cognome' => $status['anagrafica']['cognome'],
            'username' => $account['username'],
            'password' => $password
        );

        $idMail = queueMailFromTemplate(
            $cf['mysql']['connection'],
            $cf['mail']['tpl']['NOTIFICA_RESET_PASSWORD'],
            array( 'dt' => $dt, 'ct' => $ct ),
            strtotime( '+1 minutes' ),
            array( $status['anagrafica']['nome'] . ' ' . $status['anagrafica']['cognome'] => $status['mail'] ),
            $cf['localization']['language']['ietf']
        );

        if ( !empty( $idMail ) ) {
            $status['__status__'] = 'OK';
        } else {
            $status['__status__'] = 'KO';
        }

    } else {

        $status['__status__'] = 'KO';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

    // debug
    // print_r($_REQUEST);
