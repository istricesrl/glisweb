<?php

    /**
     * crea una pianificazione che ha per modello un oggetto esistente
     *
     * Questo task crea, con pianificazioniDaOggetto() di _mod/_PI000.pianificazioni/_src/_lib/_pianificazioni.utils.php,
     * una pianificazione il cui modello è l'oggetto indicato: le sue colonne finiscono nelle colonne model_* e, per un
     * documento, le sue righe e i suoi pagamenti diventano le pianificazioni figlie. La pianificazione nasce senza
     * periodicità e senza data di avvio: la si completa dal suo form, che è dove porta il comando delle schede
     * pianificazione dei form degli altri moduli. Il nome segue quello dei task che creano un oggetto da un altro
     * ( _mod/_4140.coupon/_src/_api/_task/_nota.da.coupon.php ).
     *
     * parametro    | effetto
     * -------------|-------------------------------------------------------------------------------------------------
     * entita       | l'entità dell'oggetto ( documenti, attivita, todo, rinnovi, documenti_articoli, pagamenti )
     * id           | l'id dell'oggetto
     *
     * L'id della pianificazione creata è in pianificazione.id dell'output JSON.
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

    // dati di partenza
    if( ! empty( $_REQUEST['entita'] ) && ! empty( $_REQUEST['id'] ) ) {

        // status
        $status['info'][] = 'pianificazione da ' . $_REQUEST['entita'] . ' #' . $_REQUEST['id'];

        // creazione della pianificazione
        $status['pianificazione']['id'] = pianificazioniDaOggetto( $_REQUEST['entita'], $_REQUEST['id'] );

        // controllo
        if( empty( $status['pianificazione']['id'] ) ) {
            $status['err'][] = 'oggetto non trovato o pianificazione non creata';
        }

    } else {

        // status
        $status['err'][] = 'entità o id non passati';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
