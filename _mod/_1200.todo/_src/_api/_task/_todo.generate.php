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

    if( isset($_REQUEST) && (! empty( $_REQUEST['__g__'] ) || $_REQUEST['__g__']==0 )&& ! empty( $_REQUEST['__d_i__'] ) && ! empty( $_REQUEST['__d_f__'] )  ){
        
        $status['__status__'] = 'OK';
   
       // log
	    logWrite( 'data inizio generazione '.$_REQUEST['__d_i__'].' '.$_REQUEST['__d_f__'], 'todo', LOG_ERR );
       // function creazionePianificazione( $c, $data, $id_periodicita, $cadenza=NULL, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){ 

        $restult = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__d_i__'], 2, 1, $_REQUEST['__d_f__'], NULL, $_REQUEST['__g__']);
	    
        logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
        
        if( $restult ){

            $status['__status__'] = 'Pianificazione completata';
            $status['date'] = $restult;
            $status['n'] = count($restult);

            if( ! empty( $_REQUEST['__o_i__'] ) && ! empty( $_REQUEST['__o_f__'] ) && ! empty( $_REQUEST['__l__'] ) && ! empty( $_REQUEST['__a__'] )  ){
            // creazione todo [andrebbe fatto un job?]
            foreach( $restult as $data ){

                mysqlQuery( $cf['mysql']['connection'],
                    'INSERT INTO todo ( id_anagrafica, id_luogo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, nome ) VALUES ( ?, ?, ?, ?, ?, ?, ? )',
                    array(  array( 's' => $_REQUEST['__a__'] ), 
                            array( 's' => $_REQUEST['__l__'] ), 
                            array( 's' => $_REQUEST['progetto'] ), 
                            array( 's' => $_REQUEST['__o_i__'] ), 
                            array( 's' => $_REQUEST['__o_f__'] ), 
                            array( 's' => $data ),
                            array( 's' => 'lezione corso '.$_REQUEST['progetto'] ) )
                );
            }

            mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
                array(
                    array( 's' => 'todo' ),
                    array( 's' => '_mod/_1200.todo/_src/_api/_task/_todo.generate.php'),
                    array( 's' => time() )
                )
            );

            } else {
                $status['__status__'] = 'NO';
                $status['err'][] = 'dettagli todo non passati';
            }

        } else {
            $status['__status__'] = 'Pianificazione NON completata: controllare i dati e la connessione';
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
