<?php

    /**
     * preparazione dei destinatari di un mailing
     *
     * Copia in `mailing_mail` gli indirizzi iscritti alle liste del mailing, che poi `_genera.mail.php` lavora uno
     * per giro. Si lancia dalla scheda azioni del mailing, e si può rilanciare: gli indirizzi già in elenco non
     * vengono toccati, quelli iscritti nel frattempo si aggiungono.
     *
     * Rispetto a `_7000.mailing`:
     *
     * - un indirizzo entra **una volta sola** anche se è iscritto a più liste del mailing o se nella tabella `mail`
     *   ci sono più righe con lo stesso indirizzo ( una per anagrafica ): prima ciascuna riga riceveva la sua
     *   copia della newsletter;
     * - restano fuori gli indirizzi che hanno revocato il consenso, secondo mailingCondizioneConsenso().
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

    // inserimento dei destinatari
    if( ! empty( $_REQUEST['idMailing'] ) ) {

        // NOTA la chiave unica ( id_mailing, id_mail ) evita di inserire due volte la stessa riga, il NOT EXISTS e il
        // GROUP BY evitano di inserire due volte lo stesso indirizzo con righe di mail diverse
        $status['inserimento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO mailing_mail ( id_mailing, id_mail, timestamp_inserimento ) '.
            'SELECT mailing_liste.id_mailing, min( mail.id ), ? '.
            'FROM liste_mail '.
            'INNER JOIN mailing_liste ON mailing_liste.id_lista = liste_mail.id_lista '.
            'INNER JOIN mail ON mail.id = liste_mail.id_mail '.
            'WHERE mailing_liste.id_mailing = ? '.
            'AND ' . mailingCondizioneConsenso( 'mail' ) . ' '.
            'AND NOT EXISTS ( '.
                'SELECT mailing_mail.id FROM mailing_mail '.
                'INNER JOIN mail AS mail_inviata ON mail_inviata.id = mailing_mail.id_mail '.
                'WHERE mailing_mail.id_mailing = mailing_liste.id_mailing '.
                'AND mail_inviata.indirizzo = mail.indirizzo '.
            ') '.
            'GROUP BY mailing_liste.id_mailing, mail.indirizzo',
            array(
                array( 's' => time() ),
                array( 's' => $_REQUEST['idMailing'] )
            )
        );

        // log
        logWrite( 'preparati i destinatari del mailing #' . $_REQUEST['idMailing'], 'mailing' );

    } else {

        // status
        $status['err'][] = 'mailing non specificato';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
