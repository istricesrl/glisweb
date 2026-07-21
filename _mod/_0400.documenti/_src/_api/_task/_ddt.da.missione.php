<?php

    /**
     * genera il DDT di controllo per gli ordini associati a una missione
     *
     * E' il task dietro al pulsante "abilita controllo" della scheda missione. La logica vive in
     * creaDdtDaMissione() ( _mod/_0400.documenti/_src/_lib/_mysql.utils.add.php ), condivisa con il
     * task pianificato mod/0400.documenti/src/api/task/ddt.da.missioni.chiuse.php.
     *
     * parametri
     * ---------
     * missione     documenti.id della missione
     * forza        genera il DDT anche se la missione non e' ancora chiusa
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // se è passato un ID documento
    if( isset( $_REQUEST['missione'] ) && ! empty( $_REQUEST['missione'] ) ) {

        // status
        $status['info'][] = 'ID missione: ' . $_REQUEST['missione'];

        // genero il DDT
        $status = array_merge_recursive(
            $status,
            creaDdtDaMissione( $_REQUEST['missione'], ( isset( $_REQUEST['forza'] ) && ! empty( $_REQUEST['forza'] ) ) )
        );

    } else {

        // status
        $status['err'][] = 'ID missione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
