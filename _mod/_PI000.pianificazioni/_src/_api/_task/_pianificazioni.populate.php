<?php

    /**
     * creazione degli oggetti delle pianificazioni
     *
     * Questo task crea gli oggetti di UNA pianificazione, usando pianificazioniElabora() di
     * _mod/_PI000.pianificazioni/_src/_lib/_pianificazioni.utils.php, a cui si rimanda per il dettaglio di come si
     * calcolano le date e si costruiscono gli oggetti.
     *
     * chi lo chiama
     * =============
     * Lo include il blocco delle pianificazioni di _src/_api/_cron.php, una volta per ogni pianificazione scaduta, dopo
     * averle bloccate tutte con il proprio token: in quel caso la riga da elaborare arriva nella variabile
     * $pianificazione e il lock lo rilascia il cron. Chiamato a mano ( /task/PI000.pianificazioni/pianificazioni.populate )
     * il task si prende da solo il lock:
     *
     * parametro    | effetto
     * -------------|-------------------------------------------------------------------------------------------------
     * id           | elabora la pianificazione indicata, anche se non è scaduta
     * d            | lavora come se oggi fosse la data indicata ( Y-m-d ): serve per il debug e per rigenerare in
     *              | ordine documenti numerati ( tutte le fatture di un mese prima di passare al successivo )
     *
     * Senza id elabora la prima delle pianificazioni scadute, in ordine di data del prossimo oggetto, con gli stessi
     * criteri del cron ( vedi il blocco delle pianificazioni di _src/_api/_cron.php: le due query vanno tenute uguali ).
     *
     * il lock
     * =======
     * Il token si prende con timestamp_elaborazione alla data e ora corrente; un token più vecchio di dieci minuti
     * viene considerato appeso ( il giro che lo aveva preso è morto ) e azzerato, come fa _src/_api/_cron.php per task e
     * job. NOTA fino al 2026-09-25, nel task di _0100.pianificazioni, un token rimasto appeso bloccava la pianificazione
     * per sempre.
     *
     * Il dettaglio di ogni giro si trova nell'output JSON e, da cron, in var/log/pianificazioni/.
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

    // data di lavoro: oggi, oppure quella simulata con il parametro d
    $data = ( ! empty( $_REQUEST['d'] ) ) ? date( 'Y-m-d', strtotime( $_REQUEST['d'] ) ) : date( 'Y-m-d' );

    // status
    $status['info'][] = 'elaborazione delle pianificazioni al ' . $data;

    // pianificazione passata dal cron, o da bloccare qui
    if( defined( 'CRON_RUNNING' ) && isset( $pianificazione ) && is_array( $pianificazione ) ) {

        // riga passata dal cron
        $current = $pianificazione;

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

        // lock della riga
        if( ! empty( $_REQUEST['id'] ) ) {

            // status
            $status['info'][] = 'elaborazione della pianificazione #' . $_REQUEST['id'];

            // lock della pianificazione richiesta
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET token = ?, timestamp_elaborazione = ? WHERE id = ? AND token IS NULL AND id_genitore IS NULL',
                array(
                    array( 's' => $status['token'] ),
                    array( 's' => time() ),
                    array( 's' => $_REQUEST['id'] )
                )
            );

        } else {

            // lock della prima pianificazione scaduta
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET token = ?, timestamp_elaborazione = ? WHERE
                    id_genitore IS NULL AND token IS NULL AND entita IS NOT NULL AND
                    data_avvio IS NOT NULL AND data_avvio <= ? AND
                    ( data_elaborazione IS NULL OR data_elaborazione < ? OR timestamp_aggiornamento > timestamp_elaborazione ) AND
                    NOT ( data_fine IS NOT NULL AND data_elaborazione > data_fine AND coalesce( giorni_estensione, 0 ) = 0 )
                    ORDER BY coalesce( data_ultimo_oggetto, data_inizio, data_avvio ) ASC LIMIT 1',
                array(
                    array( 's' => $status['token'] ),
                    array( 's' => time() ),
                    array( 's' => $data ),
                    array( 's' => $data )
                )
            );

        }

        // riga bloccata
        $current = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pianificazioni WHERE token = ?',
            array( array( 's' => $status['token'] ) )
        );

    }

    // elaborazione
    if( ! empty( $current ) ) {

        // status
        $status['info'][] = 'elaboro la pianificazione #' . $current['id'] . ' ( ' . $current['entita'] . ' ) ' . $current['nome'];

        // creazione degli oggetti
        $status['creati'] = pianificazioniElabora( $current, $data, $status );

        // rilascio del lock preso qui ( quello del cron lo rilascia il cron )
        if( isset( $status['token'] ) ) {
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET token = NULL, timestamp_elaborazione = ? WHERE token = ?',
                array(
                    array( 's' => time() ),
                    array( 's' => $status['token'] )
                )
            );
        }

    } else {

        // status
        $status['info'][] = 'nessuna pianificazione da elaborare';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
