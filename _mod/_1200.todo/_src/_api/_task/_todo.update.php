<?php

    /**
     * effettua l'eliminazione di una todo e di tutti gli oggetti as essa collegati
     * - riceve in ingresso l'id della todo
     * 
     *
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una todo
    if( ! empty( $_REQUEST['progetto'] ) ) {

    // log
	logWrite( 'richiesta generazione todo', 'todo', LOG_ERR );
    //var par = '&__g__=' + giorno + '&__d_i__=' + data_inizio + '&__d_f__=' + data_fine + '&__o_i__=' + ora_inizio + '&__o_f__=' + ora_fine + '&__l__=' + luogo + '&__'

    if( isset($_REQUEST) && ! empty( $_REQUEST['__d_i__'] ) && ! empty( $_REQUEST['__d_f__'] )  ){
        
        if( ! empty( $_REQUEST['__g__'] ) || $_REQUEST['__g__']=='0'  ){

            $restult = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__d_i__'], 2, 1, $_REQUEST['__d_f__'], NULL, $_REQUEST['__g__']);
                
            logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
            
            if( $restult ){

                // se va modificato il luogo asggiorno la todo

                // altrimenti devo
            }

        } else {

        }
   

    } else {
	    $status['__status__'] = 'NO';
	}

    } else {

        // status
        $status['err'][] = 'ID progetto per todo non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
