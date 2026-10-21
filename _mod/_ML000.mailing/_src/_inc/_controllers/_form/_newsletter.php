<?php

    /**
     * controller del form di iscrizione alla newsletter
     *
     * La include `_750.controller.php` del modulo contatti quando riceve `__ct__[newsletter]`, dopo il controllo
     * antispam e il salvataggio del contatto; ha a disposizione `$k` ( il nome del form ) e `$v` ( i suoi dati,
     * per riferimento ).
     *
     * Chi si iscrive dal sito diventa una riga di `mail` senza anagrafica, iscritta alle liste configurate in
     * `$cf['contatti']['newsletter']['liste']`, con il consenso INVIO_COMUNICAZIONI_MARKETING registrato
     * sull'indirizzo: è il modello deciso da Fabio il 2026-10-01. Se l'indirizzo c'è già si riusa, preferendo la
     * riga senza anagrafica, così chi si riscrive dopo essersi tolto torna a ricevere la newsletter senza creare
     * un doppione.
     *
     * campi del form
     * ==============
     * campo                | descrizione
     * ---------------------|-------------------------------------------------------------------------------------
     * mail                 | l'indirizzo da iscrivere, obbligatorio
     * lista                | facoltativo, la lista scelta fra quelle configurate ( per id o per nome )
     * __privacy__          | i consensi del modulo privacy `newsletter`, INVIO_COMUNICAZIONI_MARKETING obbligatorio
     *
     * @file
     *
     */

    // log
    logger( 'controller ' . __FILE__ . ' caricata', 'contatti' );

    // indirizzo
    $indirizzo = trim( $v['mail'] ?? '' );

    // controllo dei dati
    if( ! filter_var( $indirizzo, FILTER_VALIDATE_EMAIL ) ) {

        // status
        $v['__status__'] = 'ERR';
        $v['__err__'][] = 'indirizzo mail non valido';

        // log
        logger( 'iscrizione alla newsletter rifiutata per indirizzo non valido (' . $indirizzo . ')', 'mailing', LOG_WARNING );

    } elseif( empty( $v['__privacy__']['INVIO_COMUNICAZIONI_MARKETING'] ) ) {

        // status
        $v['__status__'] = 'ERR';
        $v['__err__'][] = 'consenso all\'invio della newsletter non prestato';

        // log
        logger( 'iscrizione alla newsletter rifiutata per consenso mancante (' . $indirizzo . ')', 'mailing', LOG_WARNING );

    } else {

        // riga di mail esistente, preferendo quella senza anagrafica
        $idMail = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM mail WHERE indirizzo = ? ORDER BY id_anagrafica IS NULL DESC, id ASC LIMIT 1',
            array( array( 's' => $indirizzo ) )
        );

        // altrimenti la creo senza anagrafica
        if( empty( $idMail ) ) {
            $idMail = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => NULL,
                    'id_anagrafica' => NULL,
                    'indirizzo' => $indirizzo,
                    'note' => 'iscrizione alla newsletter dal sito, contatto #' . $v['__id_contatto__']
                ),
                'mail'
            );
        }

        // liste configurate
        $liste = $cf['contatti']['newsletter']['liste'] ?? array();

        // se il form ha scelto una lista fra quelle configurate, solo quella
        if( ! empty( $v['lista'] ) && in_array( $v['lista'], $liste ) ) {
            $liste = array( $v['lista'] );
        }

        // iscrizione alle liste
        foreach( $liste as $lista ) {

            // ID della lista, creandola se è indicata per nome e non esiste
            $idLista = ( is_numeric( $lista ) ) ? $lista : mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => NULL,
                    'nome' => $lista
                ),
                'liste',
                true,
                false,
                array(
                    'nome'
                )
            );

            // iscrizione
            mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT IGNORE INTO liste_mail ( id_lista, id_mail, timestamp_inserimento ) VALUES ( ?, ?, ? )',
                array(
                    array( 's' => $idLista ),
                    array( 's' => $idMail ),
                    array( 's' => time() )
                )
            );

        }

        // consenso sull'indirizzo
        mailingRegistraConsenso( $idMail, true, 'modulo newsletter del sito, contatto #' . $v['__id_contatto__'] );

        // dati per la pagina di conferma
        $v['__id_mail__'] = $idMail;

        // log
        logger( 'iscritto alla newsletter l\'indirizzo ' . $indirizzo . ' (mail #' . $idMail . ')', 'mailing' );

    }
