<?php

    /**
     * task richiamato per cambiare il codice di un prodotto
     *
     * Riceve in ingresso:
     * - id:  il codice attuale
     * - new: il codice nuovo
     *
     * Il lavoro vero lo fa rinominaEntita() in _src/_lib/_page.utils.php, che ripunta tutte le
     * righe figlie prima di cancellare quella vecchia. Qui c'e' solo il guscio, modellato su
     * _prodotti.duplicate.php.
     *
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_CATALOGO' );

    // inizializzo l'array del risultato
	$status = array();

    // verifico che siano arrivati tutti e due i codici
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['new'] ) ) {

        $status = rinominaProdotto( $_REQUEST['id'], $_REQUEST['new'] );

    } else {

        // status
        $status['err'][] = 'servono il codice attuale ( id ) e quello nuovo ( new )';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
