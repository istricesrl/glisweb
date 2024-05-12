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
    //var par = '&__g__=' + giorno + '&__di__=' + data_inizio + '&__df__=' + data_fine + '&__oi__=' + ora_inizio + '&__of__=' + ora_fine + '&__l__=' + luogo + '&__'

    if( isset($_REQUEST) && ! empty( $_REQUEST['__di__'] ) && ! empty( $_REQUEST['__df__'] )  ){
        
        if( ! empty( $_REQUEST['__g__'] ) || $_REQUEST['__g__']=='0'  ){

            $restult = creazionePianificazione( $_REQUEST['__di__'], 2, 1, $_REQUEST['__df__'], NULL, $_REQUEST['__g__']);
                
            logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
            
            if( $restult ){

                $status['__status__'] = 'trovate todo da modificare';

                // se va modificato il luogo asggiorno la todo
                if( ! empty( $_REQUEST['__l__'] ) ){

                        $status['action'][] = 'modifica luogo';

                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['__l__'] );
                        // $params[] = array( 's' => $_REQUEST['__l__'] );
                        $params[] = array( 's' => $_REQUEST['progetto'] );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'todo.ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'todo.ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        // aggiornamento todo ed attivita
                        foreach( $restult as $data ){

                            $params[count($params)] =  array( 's' => $data );
/*
                            mysqlQuery( $cf['mysql']['connection'],
                            'UPDATE attivita, todo SET todo.id_luogo = ?, attivita.id_luogo = ?, 
                                attivita.timestamp_aggiornamento = unix_timestamp(), todo.timestamp_aggiornamento = unix_timestamp() 
                                WHERE todo.id = attivita.id_todo AND todo.id_progetto = ? '.$where.' AND  todo.data_programmazione = ?  ',
                            $params
                            );
*/

                            $query = 'UPDATE todo SET todo.id_luogo = ?, 
                            todo.timestamp_aggiornamento = unix_timestamp() 
                            WHERE todo.id_progetto = ? '.$where.' AND  todo.data_programmazione BETWEEN ? AND ?  ';

                            $status['query'][] = $query;

                            mysqlQuery( $cf['mysql']['connection'],
                                $query,
                                $params
                            );

                            $query = 'UPDATE attivita, todo SET attivita.id_luogo = ?, 
                            attivita.timestamp_aggiornamento = unix_timestamp()
                            WHERE todo.id = attivita.id_todo AND todo.id_progetto = ? '.$where.' AND  todo.data_programmazione BETWEEN ? AND ?  ';

                            $status['query'][] = $query;

                            mysqlQuery( $cf['mysql']['connection'],
                                $query,
                                $params
                            );

                            unset($params[count($params)-1]);
                        }

                    } 
                
                // se devo aggiungere un istruttore
                if( ! empty( $_REQUEST['__addi__'] ) ){

                    $status['action'][] = 'aggiunta istruttore';

                    // aggiornamento todo ed attivita
                    foreach( $restult as $data ){

                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $data );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        $todo = mysqlSelectRow( $cf['mysql']['connection'],
                        'SELECT * FROM todo WHERE id_progetto = ? AND data_programmazione = ? '.$where,
                        $params
                        );
                        
                        if( $todo ){
                            mysqlQuery( $cf['mysql']['connection'], 
                            'INSERT INTO attivita (id_anagrafica_programmazione, id_luogo, id_todo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, id_tipologia) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                                array(  
                                    array( 's' => $_REQUEST['__addi__'] ),
                                    array( 's' => $todo['id_luogo'] ), 
                                    array( 's' => $todo['id'] ),                             
                                    array( 's' => $todo['id_progetto'] ), 
                                    array( 's' => $todo['ora_inizio_programmazione'] ), 
                                    array( 's' => $todo['ora_fine_programmazione'] ), 
                                    array( 's' => $data ),
                                    array( 's' => 1 )
                                )
                            );

                        }

                    }

                }

                // se devo eliminare un istruttore
                if( ! empty( $_REQUEST['__removei__'] ) ){

                    // aggiornamento todo ed attivita
                    foreach( $restult as $data ){

                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $data );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        $todo = mysqlSelectValue( $cf['mysql']['connection'],
                        'SELECT id FROM todo WHERE id_progetto = ? AND data_programmazione = ? '.$where,
                        $params
                        );
                        
                        if( $todo ){
                            $params[0] = array( 's' => $_REQUEST['__removei__'] );
                            $params[] = array( 's' => $todo );
                            mysqlQuery(  $cf['mysql']['connection'],
                            'DELETE FROM attivita WHERE id_anagrafica_programmazione = ?  AND data_programmazione = ? '.$where.' AND id_todo = ?',
                            $params
                            );
                            //ora_inizio_programmazione, ora_fine_programmazione, data_programmazione
                        }

                    }

                }

                // se devo sostituire un instruttore
                if( ! empty( $_REQUEST['__deletei__'] ) && ! empty( $_REQUEST['__newi__'] ) ){

                    $status['action'][] = 'sostituzione istruttore';
                    $status['date'] = $restult;

                    // aggiornamento todo ed attivita
                    foreach( $restult as $data ){

                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $data );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        $todo = mysqlSelectValue( $cf['mysql']['connection'],
                        'SELECT id FROM todo WHERE id_progetto = ? AND data_programmazione = ? '.$where,
                        $params
                        );
                        
                        $status['todo'] = $todo;
                        if( $todo ){

                            $params[0] = array( 's' => $_REQUEST['__newi__'] );
                            $params[1] = array( 's' => $_REQUEST['__deletei__'] );

                            $params[] = array( 's' => $data );
                            $params[] = array( 's' => $todo );

                            mysqlQuery(  $cf['mysql']['connection'],
                            'UPDATE attivita SET id_anagrafica_programmazione = ?, 
                                attivita.timestamp_aggiornamento = unix_timestamp()
                                WHERE id_anagrafica_programmazione = ?  '.$where.'  AND data_programmazione = ? AND id_todo = ?',
                            $params
                            );
                        }

                    }

                }
/*
                // aggiornare todo_view_static
                mysqlQuery( $cf['mysql']['connection'], 'CALL todo_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata todo view statica per tutti i record', 'speed' );

                mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata attivita view statica per tutti i record', 'speed' );
*/

                // aggiorno il report lezioni corsi
                // TODO fare solo se la todo è una lezione di un corso!
                $status['job'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
                    array(
                        array( 's' => 'popolazione report lezioni corsi' ),
                        array( 's' => '_mod/_0920.corsi/_src/_api/_job/_report.lezioni.corsi.popolazione.php' ),
                        array( 's' => 15 ),
                        array( 's' => 1 ),
                        array( 's' => json_encode( array( 'id_corso' => $_REQUEST['progetto'] ) ) )
                    )
                );
            
            } else {

                
                // non ci sono date
                $status['err'][] = 'non ci sono date da modificare';

            }

            } else {

                // tutti i giorni
                if( ! empty( $_REQUEST['__l__'] ) ){

                        $status['action'][] = 'modifica luogo';

                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['__l__'] );
                        // $params[] = array( 's' => $_REQUEST['__l__'] );
                        $params[] = array( 's' => $_REQUEST['progetto'] );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'todo.ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'todo.ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        $params[] = array( 's' => $_REQUEST['__di__'] );
                        $params[] = array( 's' => $_REQUEST['__df__'] );
/*
                        $query = 'UPDATE attivita, todo SET todo.id_luogo = ?, attivita.id_luogo = ?, 
                        attivita.timestamp_aggiornamento = unix_timestamp(), todo.timestamp_aggiornamento = unix_timestamp() 
                        WHERE todo.id = attivita.id_todo AND todo.id_progetto = ? '.$where.' AND  todo.data_programmazione 
                        BETWEEN ? AND ?  ';
*/

                        $query = 'UPDATE todo SET todo.id_luogo = ?, 
                        todo.timestamp_aggiornamento = unix_timestamp() 
                        WHERE todo.id_progetto = ? '.$where.' AND  todo.data_programmazione BETWEEN ? AND ?  ';

                        $status['query'][] = $query;

                        mysqlQuery( $cf['mysql']['connection'],
                            $query,
                            $params
                        );

                        $query = 'UPDATE attivita, todo SET attivita.id_luogo = ?, 
                        attivita.timestamp_aggiornamento = unix_timestamp()
                        WHERE todo.id = attivita.id_todo AND todo.id_progetto = ? '.$where.' AND  todo.data_programmazione BETWEEN ? AND ?  ';

                        $status['query'][] = $query;

                        mysqlQuery( $cf['mysql']['connection'],
                            $query,
                            $params
                        );

                    } 
                
                // se devo aggiungere un istruttore
                if( ! empty( $_REQUEST['__addi__'] ) ){

                    $status['action'][] = 'aggiunta istruttore';


                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $_REQUEST['__di__'] );
                        $params[] = array( 's' => $_REQUEST['__df__'] );
                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}



                        $t = mysqlQuery( $cf['mysql']['connection'],
                        'SELECT * FROM todo WHERE id_progetto = ? AND (data_programmazione BETWEEN ? AND ?) '.$where,
                        $params
                        );
                        
                        if( $t ){
                            foreach($t as $todo){
                                mysqlQuery( $cf['mysql']['connection'], 
                                'INSERT INTO attivita (id_anagrafica_programmazione, id_luogo, id_todo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, id_tipologia) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                                    array(  
                                        array( 's' => $_REQUEST['__addi__'] ),
                                        array( 's' => $todo['id_luogo'] ), 
                                        array( 's' => $todo['id'] ),                             
                                        array( 's' => $todo['id_progetto'] ), 
                                        array( 's' => $todo['ora_inizio_programmazione'] ), 
                                        array( 's' => $todo['ora_fine_programmazione'] ), 
                                        array( 's' => $todo['data_programmazione'] ),
                                        array( 's' => 1 )
                                    )
                                );
    
                            }

                        }

                }

                // se devo eliminare un istruttore
                if( ! empty( $_REQUEST['__removei__'] ) ){

                    $status['action'][] = 'eliminazione istruttore';

                    // aggiornamento todo ed attivita
                        $where = array();
                        $params = array();

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $_REQUEST['__di__'] );
                        $params[] = array( 's' => $_REQUEST['__df__'] );

                        
                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        if(!empty($where)){$where = ' AND '.implode(' AND ', $where);}
                        else{ $where = '';}

                        $todo = mysqlQuery( $cf['mysql']['connection'],
                        'SELECT id FROM todo WHERE id_progetto = ? AND (data_programmazione BETWEEN ? AND ?) '.$where,
                        $params
                        );
                        
                        if( $todo ){

                            foreach($todo as $t){

                                $params[0] = array( 's' => $_REQUEST['__removei__'] );
                                $params[count($params)] = array( 's' => $t['id'] );
                                mysqlQuery(  $cf['mysql']['connection'],
                                'DELETE FROM attivita WHERE id_anagrafica_programmazione = ?  AND (data_programmazione BETWEEN ? AND ?)  '.$where.' AND id_todo = ?',
                                $params
                                );
                               

                            }

                            //ora_inizio_programmazione, ora_fine_programmazione, data_programmazione
                        }


                }

                // se devo sostituire un instruttore
                if( ! empty( $_REQUEST['__deletei__'] ) && ! empty( $_REQUEST['__newi__'] ) ){

                    $status['action'][] = 'sostituzione istruttore';
                    
                        $where = array();
                        $params = array();

                        if(! empty( $_REQUEST['__oi__'] )){
                            $where[] = 'ora_inizio_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__oi__'] );
                        }  
                        if(! empty( $_REQUEST['__of__'] )){
                            $where[] = 'ora_fine_programmazione = ?';
                            $params[] = array( 's' => $_REQUEST['__of__'] );
                        }  

                        $params[] = array( 's' => $_REQUEST['progetto'] );
                        $params[] = array( 's' => $_REQUEST['__di__'] );
                        $params[] = array( 's' => $_REQUEST['__df__'] );

                        

                        if(!empty($where)){$where = implode(' AND ', $where).' AND ';}
                        else{ $where = '';}

                        $todo = mysqlQuery( $cf['mysql']['connection'],
                        'SELECT id FROM todo WHERE '.$where.' id_progetto = ? AND (data_programmazione BETWEEN ? AND ?) ',
                        $params
                        );
                        
                        $status['todo'] = $todo;

                        if( $todo ){

                            foreach($todo as $t){
    
                                mysqlQuery(  $cf['mysql']['connection'],
                                'UPDATE attivita SET id_anagrafica_programmazione = ?, 
                                    attivita.timestamp_aggiornamento = unix_timestamp() 
                                    WHERE  id_anagrafica_programmazione = ?   AND id_todo = ?',
                                array(
                                    array( 's' => $_REQUEST['__newi__'] ),
                                    array( 's' => $_REQUEST['__deletei__'] ),
                                    array( 's' => $t['id'] )
                                )
                                );
                            }


                        }


                }
/*
                // aggiornare todo_view_static
                mysqlQuery( $cf['mysql']['connection'], 'CALL todo_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata todo view statica per tutti i record', 'speed' );

                mysqlQuery( $cf['mysql']['connection'], 'CALL attivita_view_static( ? )', array( array( 's' => NULL ) ) );
                logWrite( 'aggiornata attivita view statica per tutti i record', 'speed' );
*/
                // aggiorno il report lezioni corsi
                // TODO fare solo se la todo è una lezione di un corso!
                $status['job'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
                    array(
                        array( 's' => 'popolazione report lezioni corsi' ),
                        array( 's' => '_mod/_0920.corsi/_src/_api/_job/_report.lezioni.corsi.popolazione.php' ),
                        array( 's' => 15 ),
                        array( 's' => 1 ),
                        array( 's' => json_encode( array( 'id_corso' => $_REQUEST['progetto'] ) ) )
                    )
                );

            }

        } else {



        }

        // status
        $status['__status__'] = 'OK';

    } else {

        // status
        $status['err'][] = 'ID progetto per todo non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
