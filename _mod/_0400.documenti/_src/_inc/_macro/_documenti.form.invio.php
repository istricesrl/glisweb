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

        $attach = 'tmp/documento.' . $_REQUEST[ $ct['form']['table'] ]['id'] . '.pdf';

        // NOTA fino al 15/10/2026 il PDF si chiedeva via restCall() a print/0400.documenti/documento.pdf,
        // senza sessione e con un token usa e getta scritto su documenti.token; da quando l'endpoint
        // vuole GESTIONE_DOCUMENTI ( 15/09/2026 ) la chiamata prendeva 403 e la mail partiva senza
        // allegato. La macro gira gia' nella sessione di chi invia, quindi il PDF si genera qui, con la
        // stessa funzione dell'endpoint, e non serve aprire una chiave d'accesso in piu' sul documento
        $filePdf = generaDocumentoPdf( $_REQUEST[ $ct['form']['table'] ]['id'], fullPath( $attach ) );

        // senza allegato la mail non si accoda: il motivo lo scrive generaDocumentoPdf() nel log dei documenti
        if( $filePdf === false ) {
            logWrite( 'invio del documento #' . $_REQUEST[ $ct['form']['table'] ]['id'] . ' non accodato, stampa non generata', 'documenti', LOG_ERR );
        } else {

            $mittente = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT anagrafica, indirizzo, server FROM mail_view WHERE id = ?',
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
                ),
                array(),
                $mittente['server']
            );
        }

    }

    // debug
    // die( print_r( $mittente, true ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
