<?php

    /**
     * interruzione di una pianificazione
     *
     * Questo task ferma la pianificazione id a una data: scrive la data in data_fine e azzera giorni_estensione, così
     * che il cron non crei più oggetti dopo quel giorno e non allunghi più la pianificazione. È la versione per le
     * pianificazioni a modello del task di _0100.pianificazioni con lo stesso nome, che lavorava sulle colonne della
     * fase precedente ( giorni_rinnovo, data_inizio_pulizia ) e non funziona più.
     *
     * parametro    | effetto
     * -------------|-------------------------------------------------------------------------------------------------
     * id           | la pianificazione da fermare ( obbligatorio )
     * data         | la data di fine ( Y-m-d, default oggi )
     * pulisci      | se vale 1 cancella anche gli oggetti già creati con data successiva
     *
     * LA PULIZIA NON CANCELLA MAI DOCUMENTI. Un documento numerato che sparisce lascia un buco nella numerazione, e una
     * fattura già emessa non si cancella: per le pianificazioni di documenti il task elenca quelli successivi alla data
     * e li lascia dove sono. Per le altre entità cancella gli oggetti successivi e riporta data_ultimo_oggetto
     * all'ultimo oggetto rimasto, così che una ripresa della pianificazione li ricrei.
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
    checkTaskPrivilege( 'GESTIONE_PIANIFICAZIONI' );

    // inizializzo l'array del risultato
    $status = array();

    // pianificazione da fermare
    $current = ( empty( $_REQUEST['id'] ) ) ? NULL : mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM pianificazioni WHERE id = ? AND id_genitore IS NULL',
        array( array( 's' => $_REQUEST['id'] ) )
    );

    // verifico se è arrivata una pianificazione
    if( ! empty( $current ) ) {

        // data di fine
        $data = ( ! empty( $_REQUEST['data'] ) ) ? date( 'Y-m-d', strtotime( $_REQUEST['data'] ) ) : date( 'Y-m-d' );

        // interruzione
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET data_fine = ?, giorni_estensione = NULL WHERE id = ?',
            array(
                array( 's' => $data ),
                array( 's' => $current['id'] )
            )
        );

        // status
        $status['info'][] = 'pianificazione #' . $current['id'] . ' fermata al ' . $data;

        // pulizia degli oggetti successivi
        if( ! empty( $_REQUEST['pulisci'] ) ) {

            // entità
            $e = pianificazioniEntita( $current['entita'] );

            // i documenti non si cancellano
            if( empty( $e ) ) {

                // status
                $status['err'][] = 'la pianificazione non ha un\'entità valida';

            } elseif( $e['tabella'] == 'documenti' ) {

                // status
                $status['err'][] = 'i documenti non vengono cancellati';
                $status['documenti'] = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM documenti WHERE id_pianificazione = ? AND data > ?',
                    array( array( 's' => $current['id'] ), array( 's' => $data ) )
                );

            } else {

                // cancellazione
                $status['cancellati'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ? AND ' . $e['data'] . ' > ?',
                    array( array( 's' => $current['id'] ), array( 's' => $data ) )
                );

                // data dell'ultimo oggetto rimasto
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_ultimo_oggetto = ( SELECT max( ' . $e['data'] . ' ) FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ? ) WHERE id = ?',
                    array( array( 's' => $current['id'] ), array( 's' => $current['id'] ) )
                );

                // status
                $status['info'][] = 'cancellati gli oggetti successivi al ' . $data . ' da ' . $e['tabella'];

            }

        }

    } else {

        // status
        $status['err'][] = 'pianificazione non trovata';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
