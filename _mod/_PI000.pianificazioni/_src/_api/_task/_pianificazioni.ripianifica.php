<?php

    /**
     * ripianificazione di una pianificazione
     *
     * Questo task rifà gli oggetti della pianificazione id a partire da una data, secondo i parametri che la pianificazione
     * ha adesso: cancella gli oggetti dalla data in poi che non sono ancora stati lavorati, riporta indietro
     * data_ultimo_oggetto e crea subito gli oggetti scaduti con pianificazioniElabora(), come il task
     * pianificazioni.populate chiamato con l'id. Serve dopo aver cambiato periodicità, giorni o modello di una
     * pianificazione che ha già creato oggetti futuri. È la versione per le pianificazioni a modello della
     * ripianificazione di _0100.pianificazioni ( il modal ripianifica, il task populate.flag che segnava la pianificazione
     * e il task clean che cancellava gli oggetti dopo data_inizio_pulizia e riportava lì data_ultimo_oggetto ), che
     * lavorava sulle colonne della fase precedente e non funziona più.
     *
     * parametro    | effetto
     * -------------|-------------------------------------------------------------------------------------------------
     * id           | la pianificazione da ripianificare ( obbligatorio )
     * data         | la data da cui ripianificare, compresa ( Y-m-d, default oggi )
     * d            | la data di lavoro con cui si creano gli oggetti, come per pianificazioni.populate ( default oggi )
     *
     * cosa si cancella
     * ================
     * Si cancellano gli oggetti della pianificazione con data uguale o successiva a quella indicata, tranne:
     *
     * -# i documenti, MAI, con la stessa regola del task pianificazioni.stop: un documento pianificato nasce numerato, e
     *    un documento numerato che sparisce lascia un buco nella numerazione. Per le pianificazioni di documenti il task
     *    elenca quelli dalla data in poi, li lascia dove sono e non tocca data_ultimo_oggetto, così che i documenti nuovi
     *    partano dopo l'ultimo esistente e la numerazione resti in ordine di data;
     * -# gli oggetti già lavorati: le todo chiuse ( data_chiusura ), le attività svolte ( data_attivita ) e i pagamenti
     *    pagati ( timestamp_pagamento ). Restano al loro posto, e se la loro data è ancora una data della
     *    pianificazione pianificazioniElabora() non li ricrea, perché salta le date che hanno già un oggetto.
     *
     * Per le altre entità data_ultimo_oggetto torna all'ultima ripetizione il cui oggetto viene prima della data indicata
     * ( pianificazioniUltimaRipetizione() ), o resta dov'era se era già più indietro, e data_elaborazione si azzera, così
     * che si creino di nuovo gli oggetti dalla data indicata in poi. Per i pagamenti la data dell'oggetto è la scadenza:
     * si cancellano quelli che scadono dalla data in poi, e si ricreano le ripetizioni che con i parametri attuali scadono
     * dalla data in poi, anche se la ripetizione viene prima.
     *
     * Il task prende il lock della pianificazione come pianificazioni.populate, perché la pulizia e la creazione non si
     * sovrappongano al cron: se la pianificazione è bloccata da un altro giro non fa niente e lo dice.
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
    if( ! empty( $_REQUEST['id'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = ?, timestamp_elaborazione = ? WHERE id = ? AND token IS NULL AND id_genitore IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() ),
                array( 's' => $_REQUEST['id'] )
            )
        );
    }

    // pianificazione da ripianificare
    $current = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM pianificazioni WHERE token = ?',
        array( array( 's' => $status['token'] ) )
    );

    // verifico se è arrivata una pianificazione
    if( ! empty( $current ) ) {

        // data da cui ripianificare
        $data = ( ! empty( $_REQUEST['data'] ) ) ? date( 'Y-m-d', strtotime( $_REQUEST['data'] ) ) : date( 'Y-m-d' );

        // entità
        $e = pianificazioniEntita( $current['entita'] );

        // status
        $status['info'][] = 'ripianificazione della pianificazione #' . $current['id'] . ' dal ' . $data;

        // oggetti già lavorati, che non si cancellano
        $lavorati = array(
            'todo'          => 'data_chiusura IS NOT NULL',
            'attivita'      => 'data_attivita IS NOT NULL',
            'pagamenti'     => 'timestamp_pagamento IS NOT NULL'
        );

        // i documenti non si cancellano
        if( empty( $e ) ) {

            // status
            $status['err'][] = 'la pianificazione non ha un\'entità valida';

        } elseif( $e['tabella'] == 'documenti' ) {

            // status
            $status['info'][] = 'i documenti non vengono cancellati: i nuovi partono dopo l\'ultimo esistente';
            $status['documenti'] = mysqlSelectColumn(
                'id',
                $cf['mysql']['connection'],
                'SELECT id FROM documenti WHERE id_pianificazione = ? AND data >= ?',
                array( array( 's' => $current['id'] ), array( 's' => $data ) )
            );

        } else {

            // cancellazione degli oggetti non lavorati
            $status['cancellati'] = mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ? AND ' . $e['data'] . ' >= ?' .
                ( ( isset( $lavorati[ $e['tabella'] ] ) ) ? ' AND NOT ( ' . $lavorati[ $e['tabella'] ] . ' )' : '' ),
                array( array( 's' => $current['id'] ), array( 's' => $data ) )
            );

            // status
            $status['info'][] = 'cancellati ' . $status['cancellati'] . ' oggetti dal ' . $data . ' da ' . $e['tabella'];

            // data dell'ultimo oggetto all'ultima ripetizione con l'oggetto prima della data, se non era già più indietro
            $ultimo = pianificazioniUltimaRipetizione( $current, date( 'Y-m-d', strtotime( $data . ' -1 day' ) ) );
            if( ! empty( $current['data_ultimo_oggetto'] ) && $current['data_ultimo_oggetto'] < $ultimo ) {
                $ultimo = $current['data_ultimo_oggetto'];
            }

            // aggiornamento della pianificazione
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET data_ultimo_oggetto = ?, data_elaborazione = NULL WHERE id = ?',
                array( array( 's' => $ultimo ), array( 's' => $current['id'] ) )
            );

            // la riga aggiornata
            $current['data_ultimo_oggetto'] = $ultimo;
            $current['data_elaborazione'] = NULL;

        }

        // creazione degli oggetti secondo i parametri attuali
        if( ! empty( $e ) ) {
            $status['creati'] = pianificazioniElabora( $current, ( ! empty( $_REQUEST['d'] ) ) ? date( 'Y-m-d', strtotime( $_REQUEST['d'] ) ) : date( 'Y-m-d' ), $status );
        }

        // rilascio del lock
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE pianificazioni SET token = NULL, timestamp_elaborazione = ? WHERE token = ?',
            array(
                array( 's' => time() ),
                array( 's' => $status['token'] )
            )
        );

    } else {

        // status
        $status['err'][] = 'pianificazione non trovata o in elaborazione';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
