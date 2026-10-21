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
     * I pagamenti hanno per data la scadenza, che con un differimento cade dopo la ripetizione da cui nascono: si
     * cancellano quelli delle ripetizioni successive alla data di fine, riconosciute da data_ripetizione, e
     * data_ultimo_oggetto torna alla ripetizione dell'ultimo pagamento rimasto, perché la colonna contiene sempre una
     * data di ripetizione. I pagamenti creati prima che ci fosse data_ripetizione ( vuota ) si riconoscono ancora dalla
     * scadenza: si cancellano quelli che scadono dopo la scadenza della data di fine, e la loro ripetizione si ricava con
     * pianificazioniUltimaRipetizione(). NOTA fino al 2026-09-25 si confrontavano le scadenze con la data di fine e
     * data_ultimo_oggetto prendeva la scadenza: un pagamento a 30 giorni della ripetizione del 10/03, fermando al 31/03,
     * veniva cancellato e poi ricreato dal cron, e la ripresa saltava una ripetizione; e confrontando le scadenze, con il
     * fine mese e una periodicità più breve del mese, restava il pagamento di una ripetizione successiva alla data di
     * fine che scadeva lo stesso giorno di quello della data di fine.
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

                // ripetizioni successive alla data di fine ( per i pagamenti senza data_ripetizione, scadenze
                // successive alla scadenza della data di fine )
                $successive = ( $e['tabella'] == 'pagamenti' )
                    ? '( data_ripetizione > ? OR ( data_ripetizione IS NULL AND data_scadenza > ? ) )'
                    : $e['data'] . ' > ?';

                // cancellazione
                $status['cancellati'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ? AND ' . $successive,
                    array_merge(
                        array( array( 's' => $current['id'] ), array( 's' => $data ) ),
                        ( ( $e['tabella'] == 'pagamenti' ) ? array( array( 's' => pianificazioniScadenza( $data, $current ) ) ) : array() )
                    )
                );

                // ripetizione dell'ultimo oggetto rimasto
                $ultimo = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT max( ' . $e['ripetizione'] . ' ) FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ?',
                    array( array( 's' => $current['id'] ) )
                );

                // per i pagamenti senza data_ripetizione, la ripetizione si ricava dalla scadenza
                if( $e['tabella'] == 'pagamenti' ) {
                    $scadenza = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT max( data_scadenza ) FROM pagamenti WHERE id_pianificazione = ? AND data_ripetizione IS NULL',
                        array( array( 's' => $current['id'] ) )
                    );
                    if( ! empty( $scadenza ) ) {
                        $ultimo = max( $ultimo, pianificazioniUltimaRipetizione( $current, $scadenza ) );
                    }
                }

                // aggiornamento della pianificazione
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_ultimo_oggetto = ? WHERE id = ?',
                    array( array( 's' => $ultimo ), array( 's' => $current['id'] ) )
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
