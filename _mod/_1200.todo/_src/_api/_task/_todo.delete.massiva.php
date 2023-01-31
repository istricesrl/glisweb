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

    if( isset($_REQUEST) && ! empty( $_REQUEST['__d_i__'] ) && ! empty( $_REQUEST['__d_f__'] )   ){
        
        $status['__status__'] = 'OK';
   
       // log
	    logWrite( 'data inizio eliminazione '.$_REQUEST['__d_i__'].' '.$_REQUEST['__d_f__'], 'todo', LOG_ERR );

        if( ! empty( $_REQUEST['__g__'] ) || $_REQUEST['__g__']=='0'  ){

                $restult = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__d_i__'], 2, 1, $_REQUEST['__d_f__'], NULL, $_REQUEST['__g__']);
                
                logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
                
                if( $restult ){

                    $status['__status__'] = 'trovate todo da eliminare';
                    $status['date'] = $restult;
                    $status['n'] = count($restult);

                    $where = array();
                    $params = array();

                    $params[] = array( 's' => $_REQUEST['progetto'] );
                    
                    if(! empty( $_REQUEST['__o_i__'] )){
                        $where[] = 'todo.ora_inizio_programmazione = ?';
                        $params[] = array( 's' => $_REQUEST['__o_i__'] );
                    }  
                    if(! empty( $_REQUEST['__o_f__'] )){
                        $where[] = 'todo.ora_fine_programmazione = ?';
                        $params[] = array( 's' => $_REQUEST['__o_f__'] );
                    }  
                    if(! empty( $_REQUEST['__l__'] ) ){
                        $where[] = 'todo.id_luogo = ?';
                        $params[] = array( 's' => $_REQUEST['__l__'] );
                    } 

                    if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                    else{ $where = '';}
                    
                    // creazione todo [andrebbe fatto un job?]
                    foreach( $restult as $data ){
                        $params[count($params)] =  array( 's' => $data );
                      
                        mysqlQuery( $cf['mysql']['connection'],
                        'DELETE attivita FROM attivita LEFT JOIN todo ON todo.id = attivita.id_todo WHERE  todo.id_progetto = ? '.$where.' AND  todo.data_programmazione = ? ',
                        $params
                        );

                        mysqlQuery( $cf['mysql']['connection'],
                            'DELETE FROM todo WHERE  id_progetto = ? '.$where.' AND  data_programmazione = ?',
                            $params
                        );

                        unset($params[count($params)-1]);
                        
                }
                

                // aggiornare todo_view_static
                mysqlQuery( $cf['mysql']['connection'], 'CALL todo_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata todo view statica per tutti i record', 'speed' );

                mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata attivita view statica per tutti i record', 'speed' );

                $status['__status__'] = 'OK';

            }
        } else {

            $where = array();
            $params = array();
            $params[] = array( 's' => $_REQUEST['progetto'] );

            if(! empty( $_REQUEST['__o_i__'] )){
                $where[] = 'todo.ora_inizio_programmazione = ?';
                $params[] = array( 's' => $_REQUEST['__o_i__'] );
            }  
            if(! empty( $_REQUEST['__o_f__'] )){
                $where[] = 'todo.ora_fine_programmazione = ?';
                $params[] = array( 's' => $_REQUEST['__o_f__'] );
            }  
            if(! empty( $_REQUEST['__l__'] ) ){
                $where[] = 'todo.id_luogo = ?';
                $params[] = array( 's' => $_REQUEST['__l__'] );
            } 

            $params[] = array( 's' => $_REQUEST['__d_i__'] );
            $params[] = array( 's' => $_REQUEST['__d_f__'] );

            if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
            else{ $where = '';}

            mysqlQuery( $cf['mysql']['connection'],
            'DELETE attivita FROM attivita INNER JOIN todo ON todo.id = attivita.id_todo WHERE  todo.id_progetto = ? '.$where.' AND  todo.data_programmazione BETWEEN ? AND ? ',
            $params
            );

            mysqlQuery( $cf['mysql']['connection'],
            'DELETE FROM todo WHERE  id_progetto = ? '.$where.' AND  data_programmazione BETWEEN ? AND ? ',
            $params
            );

         // aggisornare todo_view_static
         mysqlQuery( $cf['mysql']['connection'], 'CALL todo_view_static( ? )', array( array( 's' => NULL ) ) );
         logWrite( 'aggiornata todo view statica per tutti i record', 'speed' );

         mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => NULL ) )  );
         logWrite( 'aggiornata attivita view statica per tutti i record', 'speed' );

         $status['__status__'] = 'OK';

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
