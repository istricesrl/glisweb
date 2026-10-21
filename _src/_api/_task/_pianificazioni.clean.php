<?php

    /**
     * pulizia degli oggetti di una pianificazione
     *
     * Questo task cancella gli oggetti creati dalla pianificazione id, tutti o solo quelli delle ripetizioni comprese
     * fra due date, e se richiesto elimina la pianificazione stessa con le sue pianificazioni figlie. La tabella in cui
     * cercare gli oggetti e la colonna con la loro data non arrivano dalla richiesta: si ricavano dalla colonna entita
     * della pianificazione con pianificazioniEntita(), come fanno i task del modulo _PI000.pianificazioni.
     *
     * parametro    | effetto
     * -------------|-------------------------------------------------------------------------------------------------
     * id           | la pianificazione da pulire ( obbligatorio, solo pianificazioni senza id_genitore )
     * da           | la prima ripetizione da cancellare, compresa ( Y-m-d, default nessun limite )
     * a            | l'ultima ripetizione da cancellare, compresa ( Y-m-d, default nessun limite )
     * elimina      | se vale 1, dopo gli oggetti elimina le pianificazioni figlie e la pianificazione
     *
     * Le regole sono quelle della pulizia del task pianificazioni.stop di _PI000.pianificazioni, e sono spiegate nel
     * capitolo _usr/_docs/_read/122.esecuzione.pianificazioni.md:
     *
     * -# I DOCUMENTI NON SI CANCELLANO MAI: nascono numerati, e un documento numerato che sparisce lascia un buco nella
     *    numerazione. Per le pianificazioni di documenti il task elenca quelli dell'intervallo in $status['documenti'] e li
     *    lascia dove sono; con elimina restano con un id_pianificazione che non punta più a niente, come quando si
     *    cancella la pianificazione dal suo form;
     * -# si ragiona per ripetizione: per i pagamenti l'intervallo si confronta con data_ripetizione, e per quelli creati
     *    prima che la colonna ci fosse ( data_ripetizione vuota ) con la scadenza calcolata da pianificazioniScadenza().
     *
     * Il task NON tocca data_ultimo_oggetto: gli oggetti cancellati restano cancellati, e il cron riprende dopo l'ultimo
     * oggetto creato. Per fermare una pianificazione e rifarne gli oggetti dopo la data di fine si usa
     * pianificazioni.stop, per ricrearli con i parametri attuali pianificazioni.ripianifica.
     *
     * Il task prende il lock della pianificazione come pianificazioni.ripianifica, perché la pulizia non si sovrapponga
     * al cron che crea gli oggetti: se la pianificazione è bloccata da un altro giro non fa niente e lo dice. Lavora
     * solo se il modulo _PI000.pianificazioni è attivo, come il blocco delle pianificazioni di _src/_api/_cron.php.
     *
     * NOTA fino al 2026-09-29 il task riceveva il nome della tabella dalla richiesta ( __table__ ) e lo passava come
     * segnaposto della query ( DELETE FROM ? ), confrontava una colonna timestamp_pianificazione che nessuna tabella ha, e
     * leggeva l'esito da una variabile mai assegnata: non ha mai cancellato niente, e nessuna pagina lo chiamava.
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../_config.php';
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_PIANIFICAZIONI' );

    // inizializzo l'array del risultato
    $status = array();

    // log
    logWrite( 'richiesta di pulizia degli oggetti di una pianificazione', 'pianificazioni', LOG_DEBUG );

    // il modello delle pianificazioni è quello del modulo _PI000.pianificazioni
    if( ! in_array( 'PI000.pianificazioni', $cf['mods']['active']['array'] ) ) {

        // status
        $status['__status__'] = 'NO';
        $status['err'][] = 'il modulo PI000.pianificazioni non è attivo';

    } elseif( empty( $_REQUEST['id'] ) ) {

        // status
        $status['__status__'] = 'NO';
        $status['err'][] = 'pianificazione non indicata';

    } else {

        // chiave di lock
        $status['token'] = getToken( __FILE__ );

        // sblocco delle pianificazioni rimaste appese
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = NULL WHERE token IS NOT NULL AND timestamp_elaborazione < ?',
            array(
                array( 's' => strtotime( '-10 minutes' ) )
            )
        );

        // lock della pianificazione
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ?, timestamp_elaborazione = ? WHERE id = ? AND token IS NULL AND id_genitore IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        // pianificazione da pulire
        $current = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pianificazioni WHERE token = ?',
            array( array( 's' => $status['token'] ) )
        );

        // entità
        $e = ( empty( $current ) ) ? NULL : pianificazioniEntita( $current['entita'] );

        // verifico se è arrivata una pianificazione
        if( empty( $current ) ) {

            // status
            $status['__status__'] = 'NO';
            $status['err'][] = 'pianificazione non trovata o in elaborazione';

        } elseif( empty( $e ) ) {

            // status
            $status['__status__'] = 'NO';
            $status['err'][] = 'la pianificazione non ha un\'entità valida';

        } else {

            // errori MySQL
            $errori = array();

            // oggetti della pianificazione
            $where = array( 'id_pianificazione = ?' );
            $params = array( array( 's' => $current['id'] ) );

            // estremi dell'intervallo
            $estremi = array();
            if( ! empty( $_REQUEST['da'] ) ) {
                $estremi['>='] = date( 'Y-m-d', strtotime( $_REQUEST['da'] ) );
            }
            if( ! empty( $_REQUEST['a'] ) ) {
                $estremi['<='] = date( 'Y-m-d', strtotime( $_REQUEST['a'] ) );
            }

            // ripetizioni dell'intervallo ( per i pagamenti senza data_ripetizione, scadenze dell'intervallo )
            foreach( $estremi as $operatore => $data ) {
                if( $e['tabella'] == 'pagamenti' ) {
                    $where[] = '( data_ripetizione ' . $operatore . ' ? OR ( data_ripetizione IS NULL AND data_scadenza ' . $operatore . ' ? ) )';
                    $params[] = array( 's' => $data );
                    $params[] = array( 's' => pianificazioniScadenza( $data, $current ) );
                } else {
                    $where[] = $e['data'] . ' ' . $operatore . ' ?';
                    $params[] = array( 's' => $data );
                }
            }

            // status
            $status['info'][] = 'pulizia della pianificazione #' . $current['id']
                . ( ( isset( $estremi['>='] ) ) ? ' dal ' . $estremi['>='] : '' )
                . ( ( isset( $estremi['<='] ) ) ? ' al ' . $estremi['<='] : '' );

            // i documenti non si cancellano
            if( $e['tabella'] == 'documenti' ) {

                // status
                $status['info'][] = 'i documenti non vengono cancellati';
                $status['documenti'] = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM documenti WHERE ' . implode( ' AND ', $where ),
                    $params
                );

            } else {

                // cancellazione
                $status['cancellati'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM ' . $e['tabella'] . ' WHERE ' . implode( ' AND ', $where ),
                    $params,
                    $errori
                );

                // status
                $status['info'][] = 'cancellati ' . $status['cancellati'] . ' oggetti da ' . $e['tabella'];

            }

            // eliminazione della pianificazione
            if( empty( $errori ) && ! empty( $_REQUEST['elimina'] ) ) {

                // pianificazioni figlie ( la chiave esterna su id_genitore non cancella in cascata )
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM pianificazioni WHERE id_genitore = ?',
                    array( array( 's' => $current['id'] ) ),
                    $errori
                );

                // pianificazione
                if( empty( $errori ) ) {
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'DELETE FROM pianificazioni WHERE id = ?',
                        array( array( 's' => $current['id'] ) ),
                        $errori
                    );
                }

                // status
                if( empty( $errori ) ) {
                    $status['info'][] = 'eliminata la pianificazione #' . $current['id'];
                }

            }

            // esito
            if( empty( $errori ) ) {
                $status['__status__'] = 'OK';
            } else {
                $status['__status__'] = 'NO';
                $status['err'][] = 'pulizia della pianificazione NON completata: controllare i dati e la connessione';
                $status['errori'] = $errori;
            }

        }

        // rilascio del lock ( se la pianificazione è stata eliminata non trova niente da rilasciare )
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = NULL, timestamp_elaborazione = ? WHERE token = ?',
            array(
                array( 's' => time() ),
                array( 's' => $status['token'] )
            )
        );

    }

    // log
    logWrite( 'pulizia degli oggetti di una pianificazione: ' . $status['__status__'], 'pianificazioni', ( ( $status['__status__'] == 'OK' ) ? LOG_DEBUG : LOG_ERR ) );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
