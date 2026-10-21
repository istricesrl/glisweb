<?php

    /**
     * popolazione di una lista da una categoria di anagrafica
     *
     * Iscrive alla lista gli indirizzi mail delle anagrafiche della categoria. Si lancia dalla scheda azioni della
     * lista.
     *
     * Restano fuori gli indirizzi che hanno revocato il consenso, secondo mailingCondizioneConsenso(): in
     * `_7000.mailing` la lista prendeva tutte le mail della categoria, quindi chi si era tolto rientrava alla prima
     * lista ripopolata. ⚠ Le anagrafiche che non hanno nessuna riga di consenso entrano: è la regola decisa per
     * non svuotare le liste esistenti, e vuol dire che chi si era tolto da uno strumento precedente senza lasciarne
     * traccia qui rientra.
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_COMUNICAZIONI' );

    // inizializzo l'array del risultato
    $status = array();

    // inserimento degli iscritti
    if( ! empty( $_REQUEST['__lista__'] ) && ! empty( $_REQUEST['__categoria__'] ) ) {

        // NOTA la chiave unica ( id_lista, id_mail ) lascia com'è chi è già iscritto
        $status['inserimento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO liste_mail ( id_lista, id_mail, timestamp_inserimento ) '.
            'SELECT ?, mail.id, ? FROM mail '.
            'INNER JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = mail.id_anagrafica '.
            'WHERE anagrafica_categorie.id_categoria = ? '.
            'AND ' . mailingCondizioneConsenso( 'mail' ),
            array(
                array( 's' => $_REQUEST['__lista__'] ),
                array( 's' => time() ),
                array( 's' => $_REQUEST['__categoria__'] )
            )
        );

        // log
        logWrite( 'popolata la lista #' . $_REQUEST['__lista__'] . ' dalla categoria #' . $_REQUEST['__categoria__'], 'mailing' );

    } else {

        // status
        $status['err'][] = 'lista o categoria non specificata';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
