<?php

    /**
     * macro form progetti chiusura
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

    // tabella gestita
	$ct['form']['table'] = 'documenti';

    // tendina mittenti
	$ct['etc']['select']['mittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ?',
        array(
            array(
                's' => $_REQUEST[ $ct['form']['table'] ]['id_emittente']
            )
        )
	);

    // tendina mittenti
	$ct['etc']['select']['destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ?',
        array(
            array(
                's' => $_REQUEST[ $ct['form']['table'] ]['id_destinatario']
            )
        )
	);

    // unisco il template INVIO_DOC_MAIL
    $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $cf['mail']['tpl']['INVIO_DOC_MAIL']['it-IT'] ) );
    $ct['etc']['corpo'] = $twig->render( 'testo', array(
        'dt' => array(
            'documento' => mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
        ),
        'ct' => $ct
    ) );

    // se c'è un invio da accodare
    if( isset( $_REQUEST['__invio__']) ) {

        $token = md5( time() );
        $attach = 'tmp/documento.' . $_REQUEST[ $ct['form']['table'] ]['id'] . '.pdf';
        mysqlQuery( $cf['mysql']['connection'], 'UPDATE documenti SET token = ?', array( array( 's' => $token ) ) );

        $x = restCall(
            $cf['site']['url'] . 'print/0400.documenti/documento.pdf',
            METHOD_GET,
            array( '__documento__' => $_REQUEST[ $ct['form']['table'] ]['id'], 'n' => $attach, 't' => $token ),
            NULL,
            MIME_APPLICATION_JSON
        );

        $mittente = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT anagrafica, indirizzo FROM mail_view WHERE id = ?',
            array( array( 's' => $_REQUEST['__invio__']['id_mittente'] ) ) 
        );

        $destinatario = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT anagrafica, indirizzo FROM mail_view WHERE id = ?',
            array( array( 's' => $_REQUEST['__invio__']['id_destinatario'] ) ) 
        );

        queueMail(
            $cf['mysql']['connection'],
            strtotime( '+5 minutes' ),
            array(
                $mittente['anagrafica'] => $mittente['indirizzo']
            ),
            array(
                $destinatario['anagrafica'] => $destinatario['indirizzo']
            ),
            $_REQUEST['__invio__']['oggetto'],
            $_REQUEST['__invio__']['corpo'],
            array(),
            array(),
            array(
                'documento' => $attach
            )
        );

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
