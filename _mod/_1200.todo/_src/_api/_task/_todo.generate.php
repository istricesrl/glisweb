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
	logWrite( 'richiesta generazione todo', 'todo' );
    //var par = '&__g__=' + giorno + '&__d_i__=' + data_inizio + '&__d_f__=' + data_fine + '&__o_i__=' + ora_inizio + '&__o_f__=' + ora_fine + '&__l__=' + luogo + '&__'

 
    if( isset($_REQUEST) && ( $_REQUEST['__g__'] == 0 || !empty($_REQUEST['__g__'])  )&& ! empty( $_REQUEST['__d_i__'] ) && ! empty( $_REQUEST['__d_f__'] )  ){
       
     
        $status['__status__'] = 'OK';
   
       // log
	    logWrite( 'data inizio generazione '.$_REQUEST['__d_i__'].' '.$_REQUEST['__d_f__'], 'todo', LOG_ERR );
       // function creazionePianificazione( $c, $data, $id_periodicita, $cadenza=NULL, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){ 
        if(  $_REQUEST['__g__'] != ''){
        
            $restult = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__d_i__'], 2, 1, $_REQUEST['__d_f__'], NULL, $_REQUEST['__g__']);
            //die(print_r($restult));  

        } else {
        
            $restult = createDateRangeArray($_REQUEST['__d_i__'],$_REQUEST['__d_f__']);
        
        }
        logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
        
        if( $restult ){

            // se vanno eliminate le chiusure
            if( isset( $_REQUEST['__periodi__'] ) && ! empty( $_REQUEST['__periodi__'] ) ){

                $tipologie = explode(',', $_REQUEST['__periodi__']);

                foreach( $tipologie as $t ){

                    $chiusure = mysqlQuery(
                        $cf['mysql']['connection'], 
                        'SELECT data_inizio, data_fine FROM periodi WHERE tipologie_periodi_path_check( id_tipologia, ? ) = 1',
                        array( array( 's' => $t ) )
                    );

                    foreach( $chiusure as $c ){
                        $range = createDateRangeArray($c['data_inizio'], $c['data_fine']);
                        $restult = array_diff($restult, $range);
                    }
                    
                }

            }

            $status['__status__'] = 'Pianificazione completata';
            $status['date'] = $restult;
            $status['n'] = count($restult);

            if( ! empty( $_REQUEST['__o_i__'] ) && ! empty( $_REQUEST['__o_f__'] ) && ! empty( $_REQUEST['__l__'] ) && ! empty( $_REQUEST['__a__'] )  ){
            
            $inserite = 0;
            $resp = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_anagrafica FROM progetti_anagrafica WHERE se_sostituto IS NULL AND id_ruolo = 16 AND id_progetto = ?', array( array( 's' => $_REQUEST['progetto'] ) ) );
            // creazione todo [andrebbe fatto un job?]
            foreach( $restult as $data ){

                logWrite( 'inserisco la todo per la data  '.$data, 'todo', LOG_ERR ); 

                $todo['id'] = mysqlQuery( $cf['mysql']['connection'],
                    'INSERT INTO todo ( id_anagrafica, id_luogo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, nome ) VALUES ( ?, ?, ?, ?, ?, ?, ? )',
                    array(  array( 's' => $resp ), 
                            array( 's' => $_REQUEST['__l__'] ), 
                            array( 's' => $_REQUEST['progetto'] ), 
                            array( 's' => $_REQUEST['__o_i__'] ), 
                            array( 's' => $_REQUEST['__o_f__'] ), 
                            array( 's' => $data ),
                            array( 's' => 'lezione corso '.$_REQUEST['progetto'] ) )
                );

               

                if( $todo['id'] ){
                 
                    $inserite++;

                    $attivita['id'] = mysqlQuery( $cf['mysql']['connection'], 
                    'INSERT INTO attivita (id_anagrafica_programmazione, id_luogo, id_todo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, id_tipologia) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                        array(  
                            array( 's' => $_REQUEST['__a__'] ),
                            array( 's' => $_REQUEST['__l__'] ), 
                            array( 's' => $todo['id'] ),                             
                            array( 's' => $_REQUEST['progetto'] ), 
                            array( 's' => $_REQUEST['__o_i__'] ), 
                            array( 's' => $_REQUEST['__o_f__'] ), 
                            array( 's' => $data ),
                            array( 's' => 1 )
                        )
                    );

                    mysqlQuery( $cf['mysql']['connection'], 'CALL todo_view_static( ? )', array( array( 's' => $todo['id'] ) ) );
                    logWrite( 'aggiornata view statica  per id #' . $todo['id'], 'speed' );
                    
                    if( $attivita['id'] ){
                        mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => $attivita['id'] ) ) );
                        logWrite( 'aggiornata view statica  per id #' . $attivita['id'], 'speed' );
                    }

                }
                
    
            }

            $status['__status__'] = 'OK';
            $status['__new__'] = $inserite;

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
