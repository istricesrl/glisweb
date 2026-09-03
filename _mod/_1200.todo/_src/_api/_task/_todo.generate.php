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
    
        if( isset($_REQUEST) && ( $_REQUEST['__g__'] == 0 || !empty($_REQUEST['__g__'])  )&& ! empty( $_REQUEST['__di__'] ) && ! empty( $_REQUEST['__df__'] )  ){
        
            $status['__status__'] = 'OK';
    
            // log
            logWrite( 'data inizio generazione '.$_REQUEST['__di__'].' '.$_REQUEST['__df__'], 'todo', LOG_ERR );

            // function creazionePianificazione( $c, $data, $id_periodicita, $cadenza=NULL, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){ 

            if( $_REQUEST['__g__'] != '' ) {
            
                $restult = creazionePianificazione( $_REQUEST['__di__'], 2, 1, $_REQUEST['__df__'], NULL, $_REQUEST['__g__'] );
                //die(print_r($restult));  

            } else {
            
                $restult = createDateRangeArray($_REQUEST['__di__'],$_REQUEST['__df__']);
            
            }

            logWrite( implode(', ', $restult), 'todo', LOG_ERR ); 
            
            // die( print_r( $status, true ) );

            if( $restult ) {

                // se vanno eliminate le chiusure
                if( isset( $_REQUEST['__periodi__'] ) && ! empty( $_REQUEST['__periodi__'] ) ){

                    $tipologie = explode(',', $_REQUEST['__periodi__']);

                    $status['periodi'] = $tipologie;

                    $status['dateSalt'] = array();

                    foreach( $tipologie as $t ){

                        $chiusure = mysqlQuery(
                            $cf['mysql']['connection'], 
                            'SELECT data_inizio, data_fine FROM periodi WHERE tipologie_periodi_path_check( id_tipologia, ? ) = 1',
                            array( array( 's' => $t ) )
                        );

                        foreach( $chiusure as $c ){
                            $range = createDateRangeArray($c['data_inizio'], $c['data_fine']);
                            $status['dateSalt'] = array_merge( $status['dateSalt'], $range );
                            // $restult = array_diff($restult, $range);
                        }
                        
                    }

                } else {
                    $status['periodi'] = 'salto periodi non richiesto';
                }

                $status['__status__'] = 'Pianificazione completata';
                $status['date'] = $restult;
                $status['n'] = count($restult);

                // if( ! empty( $_REQUEST['__oi__'] ) && ! empty( $_REQUEST['__of__'] ) && ! empty( $_REQUEST['__l__'] ) && ! empty( $_REQUEST['__a__'] )  ) {
                if( ! empty( $_REQUEST['__oi__'] ) && ! empty( $_REQUEST['__of__'] ) && ! empty( $_REQUEST['__l__'] ) ) {

                    $inserite = 0;

                    // Fix 2026-07-24: id delle righe create, per il refresh set-based delle view statiche
                    // a valle del ciclo (vedi blocco "refresh view statiche" dopo il foreach).
                    $idTodoCreate = array();
                    $idAttivitaCreate = array();

                    $resp = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_anagrafica FROM progetti_anagrafica WHERE se_sostituto IS NULL AND id_ruolo = 16 AND id_progetto = ?', array( array( 's' => $_REQUEST['progetto'] ) ) );

                    if( ! empty( $_REQUEST['__a__'] )  ) {
                        if( empty( $resp ) ) {
                            $resp = $_REQUEST['__a__'];
                        }
                    }

                    // creazione todo [andrebbe fatto un job?]
                    foreach( $restult as $data ) {

                        logWrite( 'inserisco la todo per la data  '.$data, 'todo', LOG_ERR ); 

                        if( in_array( $data, $status['dateSalt'] ) ) {
                            $idTipo = 17;
                            $respData = NULL;
                        } else {
                            $idTipo = 15;
                            $respData = $resp;
                        }

                        $todo['id'] = mysqlQuery( $cf['mysql']['connection'],
                            'INSERT INTO todo ( id_anagrafica, id_tipologia, id_luogo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, nome ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                            array(  array( 's' => $respData ), 
                                    array( 's' => $idTipo ),
                                    array( 's' => $_REQUEST['__l__'] ), 
                                    array( 's' => $_REQUEST['progetto'] ), 
                                    array( 's' => $_REQUEST['__oi__'] ), 
                                    array( 's' => $_REQUEST['__of__'] ), 
                                    array( 's' => $data ),
                                    array( 's' => 'lezione corso '.$_REQUEST['progetto'] ) )
                        );

                        if( $todo['id'] && $idTipo == 15 ) {
                        
                            $inserite++;

                            $attivita['id'] = mysqlQuery( $cf['mysql']['connection'], 
                            'INSERT INTO attivita (id_anagrafica_programmazione, id_luogo, id_todo, id_progetto, ora_inizio_programmazione, ora_fine_programmazione, data_programmazione, id_tipologia) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                                array(  
                                    array( 's' => $_REQUEST['__a__'] ),
                                    array( 's' => $_REQUEST['__l__'] ), 
                                    array( 's' => $todo['id'] ),                             
                                    array( 's' => $_REQUEST['progetto'] ), 
                                    array( 's' => $_REQUEST['__oi__'] ), 
                                    array( 's' => $_REQUEST['__of__'] ), 
                                    array( 's' => $data ),
                                    array( 's' => 30 )
                                )
                            );

                            // Fix 2026-07-24: le `CALL todo_view_static( ? )` / `CALL attivita_view_static( ? )`
                            // che stavano qui aggiornavano le view statiche UNA RIGA ALLA VOLTA dentro il ciclo.
                            // Accumulo gli id e faccio un refresh unico dopo il foreach (vedi sotto).
                            $idTodoCreate[] = intval( $todo['id'] );

                            if( $attivita['id'] ){
                                $idAttivitaCreate[] = intval( $attivita['id'] );
                            }

                        }


                    }

                    /**
                     * refresh view statiche (set-based)
                     * =================================
                     *
                     * Fix 2026-07-24: prima qui si eseguiva una `CALL todo_view_static( i )` per OGNI data
                     * generata, dentro il ciclo. Ogni chiamata esegue
                     * `INSERT INTO todo_view_static SELECT * FROM todo_view WHERE id = i` e:
                     *
                     *  - prende un WRITE LOCK sull'intera `todo_view_static`, che è MyISAM (lock di tabella,
                     *    non di riga): finché dura, ogni lettura della tabella resta appesa in
                     *    "Waiting for table level lock";
                     *  - apre le 15 tabelle sottostanti a `todo_view`, moltiplicate per il numero di date.
                     *
                     * Con una generazione da ~40 date si osservavano 2-3 secondi per singola todo (log
                     * `todo.err`), tabella lockata per minuti e connessioni accumulate fino a saturare
                     * `max_connections` del server MySQL condiviso, bloccando tutti i siti ospitati.
                     *
                     * Ora si fa UNA sola query per view, sui soli id appena creati. NB: refresh incrementale
                     * e non `TRUNCATE` + rebuild completo, perché `todo` ha ~2,3 milioni di righe mentre
                     * `todo_view_static` ne contiene ~26.000: un rebuild completo materializzerebbe l'intera
                     * tabella tenendo il lock MyISAM per tutta la durata, cioè esattamente il problema che
                     * questo fix rimuove.
                     *
                     * `REPLACE INTO` (e non `INSERT`) perché `todo_view_static` ha PRIMARY KEY su `id`: così
                     * il refresh è idempotente e ripetibile. Le colonne di view e view statica coincidono per
                     * numero, nome e ordine (verificato), quindi `SELECT *` è sicuro.
                     */
                    if( ! empty( $idTodoCreate ) ) {

                        // il lock evita che due refresh si sovrappongano sulla stessa view statica; è
                        // per-connessione e le connessioni non sono persistenti, quindi non resta appeso
                        $lockRefresh = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT GET_LOCK( concat( database(), ".view_static.refresh" ), 30 )'
                        );

                        if( ! empty( $lockRefresh ) ) {

                            refreshStaticView( $cf['mysql']['connection'], 'todo', $idTodoCreate );
                            logWrite( 'aggiornata view statica todo per ' . count( $idTodoCreate ) . ' id', 'speed' );

                            if( ! empty( $idAttivitaCreate ) ) {
                                refreshStaticView( $cf['mysql']['connection'], 'attivita', $idAttivitaCreate );
                                logWrite( 'aggiornata view statica attivita per ' . count( $idAttivitaCreate ) . ' id', 'speed' );
                            }

                            mysqlQuery( $cf['mysql']['connection'], 'SELECT RELEASE_LOCK( concat( database(), ".view_static.refresh" ) )' );

                        } else {

                            // le todo sono comunque state create: segnalo che le view statiche restano indietro
                            $status['err'][] = 'refresh delle view statiche saltato: lock non acquisito entro 30s';
                            logWrite( 'refresh view statiche saltato: lock non acquisito', 'speed', LOG_ERR );

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
