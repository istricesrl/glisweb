<?php

    /**
     * creazione di un account per un'anagrafica
     *
     * Crea un account per l'anagrafica indicata, lo associa ai gruppi del profilo scelto e mette in coda la mail di
     * benvenuto con le credenziali. Lo chiama in POST la modale `inc/anagrafica.form.tools.crea.account.html` di Athena
     * legacy, con i parametri:
     *
     * parametro        | dettagli
     * -----------------|-----------------------------------------------------------------------
     * anagrafica       | l'id dell'anagrafica
     * __e__            | l'id della mail dell'anagrafica, il cui indirizzo diventa lo username
     * __p__            | la chiave del profilo in `$cf['auth']['profili']`
     * __psw__          | la password, SOLO in POST; se manca la si genera
     *
     * LA PASSWORD NON SI LEGGE DALLA QUERYSTRING: un URL finisce nei log del web server, nella cronologia del browser
     * e negli header Referer, e la password con lui. Chi la passa in GET se la vede ignorare, e riceve per mail una
     * password generata come fa `_account.reset.password.php`.
     *
     * La mail di benvenuto usa il template indicato nella chiave `mail` del profilo, e in mancanza
     * `NOTIFICA_NUOVO_ACCOUNT`. Risponde con `__status__` OK o KO, e con gli errori in `err` come fa
     * checkTaskPrivilege(), che la modale mostra all'utente. Legge la sessione, quindi da cron non fa niente di utile.
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ACCOUNT' );

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'creazione account anagrafica', 'account', LOG_NOTICE );

    // verifiche formali
    if( ! in_array( 'GESTIONE_ACCOUNT', $_SESSION['account']['privilegi'], true ) ) {

        // status
        $status['err'][] = 'privilegi insufficienti';

    } elseif( empty( $_REQUEST['anagrafica'] ) || empty( $_REQUEST['__e__'] ) ) {

        // status
        $status['err'][] = 'anagrafica o mail mancanti';

    } elseif( empty( $_REQUEST['__p__'] ) || ! isset( $cf['auth']['profili'][ $_REQUEST['__p__'] ] ) ) {

        // status
        $status['err'][] = 'profilo mancante o inesistente';

    } else {

        $mail = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT indirizzo FROM mail WHERE id=?',
            array( array( 's' => $_REQUEST['__e__'] ) )
        );

        // password: dal corpo della richiesta, altrimenti generata come in _account.reset.password.php
        if( ! empty( $_POST['__psw__'] ) ) {
            $password = $_POST['__psw__'];
        } else {
            $password = bin2hex( openssl_random_pseudo_bytes( 8 ) );
        }

        $token = md5( microtime() );

        $idAccount = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => NULL,
                'id_anagrafica' => $_REQUEST['anagrafica'],
                'id_mail' => $_REQUEST['__e__'],
                'username' => $mail,
                'password' => passwordHash( $password ),
                'se_attivo' => 1,
                'token' => $token
            ),
            'account'
        );

        if( empty( $idAccount ) ) {

            // status
            $status['err'][] = 'impossibile creare l\'account';

        } else {

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
                'password' => $password
            );

            // template della mail di benvenuto: quello del profilo, altrimenti quello di default
            if( isset( $cf['auth']['profili'][$_REQUEST['__p__']]['mail'] ) ) {
                $template = $cf['auth']['profili'][$_REQUEST['__p__']]['mail'];
            } else {
                $template = 'NOTIFICA_NUOVO_ACCOUNT';
            }

            $idMail = queueMailFromTemplate(
                $cf['mysql']['connection'],
                $cf['mail']['tpl'][$template],
                array( 'dt' => $dt, 'ct' => $ct ),
                strtotime( '+1 minutes' ),
                array( $anagrafica['nome'] . ' ' . $anagrafica['cognome'] => $mail ),
                $cf['localization']['language']['ietf']
            );

        }

    }

    // status
    if( ! empty( $idAccount ) ) {
        $status['__status__'] = 'OK';
    } else {
        $status['__status__'] = 'KO';
    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

    // debug
    // print_r($_REQUEST);
