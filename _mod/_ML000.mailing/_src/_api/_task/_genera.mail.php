<?php

    /**
     * generazione delle mail di un mailing
     *
     * Prende una riga di `mailing_mail` non ancora generata, compone la mail con i contenuti del mailing ( uno per
     * lingua ) e i suoi allegati, e la mette in coda su `_MA000.mail` con queueMailFromTemplate(); la spedizione
     * la fa poi la coda, che scrive `mailing_mail.timestamp_invio`. Gira da cron, una riga per giro, oppure dalla
     * scheda azioni del mailing per l'invio di prova ( parametri `mt`, l'indirizzo, e `mid`, il mailing ).
     *
     * Rispetto a `_7000.mailing`:
     *
     * - un destinatario che ha revocato il consenso dopo la preparazione dell'elenco non riceve la mail, e la sua
     *   riga si toglie da `mailing_mail`;
     * - in fondo al testo si aggiunge il link di disiscrizione, se il testo non ne ha già uno ( se contiene `mtk=` );
     * - l'header `List-Unsubscribe` ha il mittente vero nel `mailto:` ( prima ci finiva l'array serializzato ) e
     *   l'URL della pagina `disiscrizione` nella lingua del sito;
     * - il **tracciamento delle aperture** resta: path2url() rende assoluti i percorsi del testo mettendoci
     *   l'id del mailing e quello dell'indirizzo, così `_download.php`, servendo le immagini, registra la lettura.
     *
     * @file
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

    // status
    $status['info'][] = 'inizio operazioni di generazione mail';

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mailing_mail SET token = ? '.
            'WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        // status
        $status['info'][] = 'selezione forzata';

    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mailing_mail '.
            'SET mailing_mail.token = ? '.
            'WHERE mailing_mail.timestamp_generazione IS NULL '.
            'AND token IS NULL '.
            'ORDER BY mailing_mail.id ASC '.
            'LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

        // status
        $status['info'][] = 'selezione normale';

    }

    // se è specificata una mail di test
    if( isset( $_REQUEST['mt'] ) && isset( $_REQUEST['mid'] ) ) {

        // simulo l'estrazione di una riga dalla coda
        $row = array_replace_recursive(
            mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT mailing.* '.
                'FROM mailing '.
                'WHERE id = ? ',
                array(
                    array( 's' => $_REQUEST['mid'] )
                )
            ),
            array(
                'indirizzo' => $_REQUEST['mt'],
                'destinatario' => 'DESTINATARIO DI TEST',
                'timestamp_invio' => time(),
                'id_mail' => NULL
            )
        );

        // status
        $status['info'][] = 'selezione diretta';

    } else {

        // prelevo una riga dalla coda
        $row = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT mailing.*, mailing_mail.id_mail, '.
            'mail.indirizzo, anagrafica.codice AS codice_destinatario, '.
            'anagrafica.id AS id_destinatario, anagrafica.nome AS nome_destinatario, anagrafica.cognome AS cognome_destinatario, anagrafica.denominazione AS denominazione_destinatario, '.
            'concat_ws( \' \', anagrafica.nome, anagrafica.cognome, anagrafica.denominazione ) AS destinatario '.
            'FROM mailing_mail '.
            'INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing '.
            'INNER JOIN mail ON mail.id = mailing_mail.id_mail '.
            'LEFT JOIN anagrafica ON anagrafica.id = mail.id_anagrafica '.
            'WHERE mailing_mail.token = ? ',
            array(
                array( 's' => $status['token'] )
            )
        );

        // status
        $status['info'][] = 'selezione da token (' . $status['token'] . ')';

        // un destinatario che ha revocato il consenso dopo la preparazione dell'elenco non riceve la mail
        if( ! empty( $row ) && ! mailingSeConsenso( $row['id_mail'] ) ) {

            // tolgo la riga dall'elenco dei destinatari
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM mailing_mail WHERE token = ?',
                array(
                    array( 's' => $status['token'] )
                )
            );

            // log
            logWrite( 'la mail #' . $row['id_mail'] . ' ha revocato il consenso, tolta dal mailing #' . $row['id'], 'mailing' );

            // status
            $status['info'][] = 'consenso revocato per la mail #' . $row['id_mail'] . ', destinatario tolto dal mailing';

            // non c'è niente da generare in questo giro, ma la coda non è finita
            $row = array();
            $status['id'] = NULL;
            $saltata = true;

        }

    }

    // se c'è almeno una mail da inviare
    if( ! empty( $row ) ) {

        // calcolo il token di cancellazione
        $row['mtk'] = md5( $row['id_mail'] . $row['indirizzo'] );

        // URL della pagina di disiscrizione
        $row['disiscrizione'] = ( $cf['contents']['pages']['disiscrizione']['url'][ $cf['localization']['language']['ietf'] ] ?? $cf['site']['url'] . 'disiscrizione' ) .
            '?mtk=' . $row['mtk'] . '&isc=' . $row['id_mail'];

        // log
        logWrite( print_r( $row, true ), 'details/mailing/' . $row['id'] );

        // inizializzo il template
        $tpl = array(
            'type' => 'twig',
            'nome' => $row['nome']
        );

        // prelevo i contenuti
        $cnts = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT contenuti.*,lingue.ietf FROM contenuti '.
            'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
            'WHERE contenuti.id_mailing = ?',
            array( array( 's' => $row['id'] ) )
        );

        // log
        logWrite( print_r( $cnts, true ), 'details/mailing/' . $row['id'] );

        // indirizzo per la disiscrizione via mail
        $mittente = NULL;

        // ciclo sui contenuti
        foreach( $cnts as $cnt ) {

            // percorsi assoluti, con mailing e destinatario per il tracciamento delle aperture
            $cnt['testo'] = path2url( $cnt['testo'], 1, $row['id'], $row['id_mail'] );

            // link di disiscrizione, se il testo non ne ha già uno
            if( strpos( $cnt['testo'], 'mtk=' ) === false ) {
                $piede = '<p style="font-size: small;">' . ( ( $cnt['ietf'] == 'it-IT' )
                    ? 'ricevi questa mail perché sei iscritto alla nostra newsletter; per non riceverla più <a href="{{ row.disiscrizione|e }}">clicca qui</a>'
                    : 'you receive this mail because you subscribed to our newsletter; to stop receiving it <a href="{{ row.disiscrizione|e }}">click here</a>' ) . '</p>';
                if( stripos( $cnt['testo'], '</body>' ) !== false ) {
                    $cnt['testo'] = str_ireplace( '</body>', $piede . '</body>', $cnt['testo'] );
                } else {
                    $cnt['testo'] .= $piede;
                }
            }

            // mittente
            $from = safe_unserialize( $cnt['mittente_mail'] );
            if( empty( $mittente ) ) {
                $mittente = ( is_array( $from ) ) ? reset( $from ) : $from;
            }

            // contenuto per lingua
            $tpl[ $cnt['ietf'] ] = array(
                'from' => $from,
                'to' => array(),
                'to_cc' => array(),
                'to_bcc' => array(),
                'oggetto' => $cnt['cappello'],
                'testo' => $cnt['testo']
            );

        }

        // prelevo gli allegati
        $files = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT file.*,lingue.ietf FROM file '.
            'INNER JOIN lingue ON lingue.id = file.id_lingua '.
            'WHERE file.id_mailing = ?',
            array( array( 's' => $row['id'] ) )
        );

        // ciclo sugli allegati
        foreach( $files as $file ) {
            $tpl[ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = $file['path'];
        }

        // log
        logWrite( print_r( $tpl, true ), 'details/mailing/' . $row['id'] );

        // header per la disiscrizione ( RFC 2369 e RFC 8058 ), solo per un destinatario vero
        $headers = array();
        if( ! empty( $row['id_mail'] ) ) {
            $headers['List-Unsubscribe'] = ( ( filter_var( $mittente, FILTER_VALIDATE_EMAIL ) ) ? '<mailto:' . $mittente . '?subject=Unsubscribe>, ' : NULL ) .
                '<' . $row['disiscrizione'] . '>';
            $headers['List-Unsubscribe-Post'] = 'List-Unsubscribe=One-Click';
        }

        // invio la mail
        $invio = queueMailFromTemplate(
            $cf['mysql']['connection'],
            $tpl,
            array( 'row' => $row ),
            $row['timestamp_invio'],
            array( $row['destinatario'] => $row['indirizzo'] ),
            $cf['localization']['language']['ietf'],
            array(),
            array(),
            array(),
            $headers
        );

        // aggiorno la coda
        if( $invio ) {

            // se ho inviato dalla tabella mailing_mail
            if( isset( $status['id'] ) && ! empty( $status['id'] ) ) {

                // aggiorno la riga
                $status['id'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE mailing_mail '.
                    'SET mailing_mail.timestamp_generazione = ?, '.
                    'mailing_mail.id_mail_out = ?, '.
                    'mailing_mail.token = NULL '.
                    'WHERE mailing_mail.token = ? ',
                    array(
                        array( 's' => time() ),
                        array( 's' => $invio ),
                        array( 's' => $status['token'] )
                    )
                );

                // follow-up
                if( ! empty( $row['promemoria_id_tipologia'] ) && ! empty( $row['id_destinatario'] ) ) {

                    // inserisco il follow-up
                    $status['id_follow_up'] = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia' => $row['promemoria_id_tipologia'],
                            'id_cliente' => $row['id_destinatario'],
                            'id_mail' => $invio,
                            'id_mailing' => $row['id'],
                            'id_anagrafica_programmazione' => $row['promemoria_id_anagrafica_programmazione'],
                            'nome' => $row['promemoria_nome'],
                            'note_programmazione' => $row['promemoria_note_programmazione'],
                            'data_programmazione' => date( 'Y-m-d', strtotime( '+' . $row['promemoria_giorni_programmazione'] . ' days', $row['timestamp_invio'] ) )
                        ),
                        'attivita'
                    );

                }

            }

            // status
            $status['info'][] = 'mail generata correttamente con id #' . $invio;

        } else {

            // status
            $status['err'][] = 'impossibile generare la mail';

        }

    } elseif( empty( $saltata ) ) {

        // chiudo il ciclo
        $iter = $task['iterazioni'] ?? NULL;

        // status
        $status['info'][] = 'nessuna mail da generare';

        // log
        logWrite( 'nessuna mail da generare', 'mailer' );

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
