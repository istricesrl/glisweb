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

    // log
	logWrite( 'creazione account anagrafica', 'account', LOG_NOTICE );

    if( in_array( 'GESTIONE_ACCOUNT', array_keys( $_SESSION['account']['privilegi'] ) ) ) {
   
        $mail = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT indirizzo FROM mail WHERE id=?',
            array( array( 's' => $_REQUEST['__e__'] ) )
        );

        $token = md5( microtime() );

        $idAccount = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => NULL,
                'id_anagrafica' => $_REQUEST['anagrafica'],
                'id_mail' => $_REQUEST['__e__'], 
                'username' => $mail,
                'password' => md5( $_REQUEST['__psw__'] ), 
                'se_attivo' => 1,
                'token' => $token
            ),
            'account'
        );

        // associo ai gruppi
        foreach( $cf['auth']['profili'][ $_REQUEST['__p__'] ]['gruppi'] as $gruppo ) {

            // recupero l'id del gruppo
            $idGruppo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM gruppi WHERE nome = ?', array( array( 's' => $gruppo ) ) );

            // associo l'account
            if( ! empty( $idGruppo ) ) {
                $idAccountGruppo[] = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO account_gruppi ( id_account, id_gruppo ) VALUES ( ?, ? )', array( array( 's' => $idAccount ), array( 's' => $idGruppo ) ) );
            }

        }

        // associo alle categorie
        /*foreach( $cf['auth']['profili'][$_REQUEST['__p__']]['categorie'] as $categoria ) {

            // recupero l'id della categoria
            $idCategoria = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM categorie_anagrafica WHERE nome = ?', array( array( 's' => $categoria ) ) );

            // associo l'account
            if( ! empty( $idCategoria ) ) {
                $idAnagraficaCategoria[] = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO anagrafica_categorie ( id_anagrafica, id_categoria ) VALUES ( ?, ? )', array( array( 's' => $_REQUEST['anagrafica'] ), array( 's' => $idCategoria ) ) );
            }

        }*/

        $anagrafica = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT nome, cognome FROM anagrafica WHERE id=?',
            array( array( 's' => $_REQUEST['anagrafica'] ) )
        );

        // TODO url pagina di atterraggio potrebbe essere diverso per profili diversi
        $dt = array(
            'url' => $cf['contents']['pages']['app']['url'][LINGUA_CORRENTE],
            'nome' => $anagrafica['nome'],
            'cognome' => $anagrafica['cognome'],
            'username' => $mail,
            'password' => $_REQUEST['__psw__']
        );

        if( isset( $cf['auth']['profili'][$_REQUEST['__p__']]['mail'] ) ) {
            $template = $cf['auth']['profili'][$_REQUEST['__p__']]['mail'];
        } else {
            $template = $cf['mail']['tpl']['NOTIFICA_NUOVO_ACCOUNT'];
        }

        $idMail = queueMailFromTemplate(
            $cf['mysql']['connection'],
            $cf['mail']['tpl'][$template],
            array( 'dt' => $dt, 'ct' => $ct ),
            strtotime( '+1 minutes' ),
            array( $anagrafica['nome'] . ' ' . $anagrafica['cognome'] => $mail ),
            $cf['localization']['language']['ietf']
        );

        if ( !empty( $idAccount ) ) {
            $status['__status__'] = 'OK';
        }

    } else {

        if ( !empty( $idAccount ) ) {
            $status['__status__'] = 'KO';
        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

    // debug
    // print_r($_REQUEST);