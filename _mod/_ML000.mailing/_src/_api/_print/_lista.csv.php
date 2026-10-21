<?php

    /**
     * esportazione degli iscritti a una lista in CSV
     *
     * Scarica gli iscritti alla lista `__lista__` con le colonne che `_importazione.iscritti.php` sa rileggere
     * ( id, nome, cognome, denominazione, codice, codice_fiscale, mail, lista ), lasciando fuori gli indirizzi che
     * hanno revocato il consenso: il file serve a portare la lista altrove, e portarci chi si è tolto
     * vorrebbe dire scrivergli di nuovo.
     *
     * In `_7000.mailing` l'endpoint leggeva la lista con controller() ma la riga che produceva il CSV era
     * commentata, quindi non scaricava niente; qui la lista si legge con una query, e il privilegio richiesto è
     * quello dei task del modulo.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_COMUNICAZIONI' );

    // controllo parametri
    if( empty( $_REQUEST['__lista__'] ) ) {

        // errore
        buildText( 'nessuna lista specificata' );

    } else {

        // iscritti alla lista
        $lista = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT liste_mail_view.id_anagrafica AS id, '.
            'liste_mail_view.anagrafica_nome AS nome, '.
            'liste_mail_view.anagrafica_cognome AS cognome, '.
            'liste_mail_view.anagrafica_denominazione AS denominazione, '.
            'liste_mail_view.anagrafica_codice AS codice, '.
            'liste_mail_view.anagrafica_codice_fiscale AS codice_fiscale, '.
            'liste_mail_view.mail, '.
            'liste_mail_view.lista '.
            'FROM liste_mail_view '.
            'INNER JOIN mail ON mail.id = liste_mail_view.id_mail '.
            'WHERE liste_mail_view.id_lista = ? '.
            'AND ' . mailingCondizioneConsenso( 'mail' ) . ' '.
            'ORDER BY liste_mail_view.mail',
            array(
                array( 's' => $_REQUEST['__lista__'] )
            )
        );

        // output
        buildCsv( array2csvString( $lista, ';', array( 'id', 'nome', 'cognome', 'denominazione', 'codice', 'codice_fiscale', 'mail', 'lista' ) ), 'iscritti.csv' );

    }
