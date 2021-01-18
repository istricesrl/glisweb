<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../_config.php';

    /* funzione che ritrona il numero della settimana del mese di una data  */ 
    function numOfDayInWeek($todt, $wd){
        $monthName = date("F", mktime(0, 0, 0, date('m', strtotime($todt))));
        $fromdt=date('Y-m-01 ',strtotime("First Day Of ".$monthName." ".date('Y', strtotime($todt)))) ;
        $num='';                
        for ($i = 0; $i <= ((strtotime($todt) - strtotime($fromdt)) / 86400); $i++){
            if(date('l',strtotime($fromdt) + ($i * 86400)) == $wd){ $num++;}    
        }
        return $num;
    }

    // funzione per la creazione di un'array di date pianificate in base a criteri specifici
    function creazionePianificazione( $c, $data, $id_periodicita, $cadenza, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){ 

        // TODO controlli
               // la data inizio è successiva alla data fine

        $number = ['first', 'second', 'third', 'fourth','fifth','sixth'];
        $days = ['Monday', 'Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday' ];
        $months = ['January','February','March','April','May','June','July','August','September','October','November','December' ];
    #    $attivita[] = array();     // chiedere a Chiara se questa sostituzione è corretta
        $attivita = array();

            // in base al tipo di periodicità della pianificazione vengono generate le attività
        switch($id_periodicita){
    
        // l'attività non si ripete
            case 0:
                $attivita[] = $data;

            break;

            // attività con ripetizione giornaliera
            case 1:
                
                if ( empty($data_fine) || $data_fine === NULL ){ $data_fine = date('Y-m-d', strtotime($data. ' + '.$cadenza * ($numero_ripetizioni - 1).' days')); }
                do {
                    $attivita[] = $data;
                    // aggiorno la data con la successiva
                    $data = date('Y-m-d', strtotime($data. ' + '.$cadenza.' days'));

                } while ( $data <= $data_fine );
            
            break;

            // attività con ripetizione settimanale
            case 2:
                // lunedì della settimana di inizio
                $d_inizio = date('Y-m-d',strtotime('monday this week ', strtotime($data) ));
                if ( empty($data_fine) || $data_fine === NULL ){ $data_fine = date('Y-m-d', strtotime($d_inizio. ' + '.($cadenza * $numero_ripetizioni ).' weeks -1 day')); }
                $giorni = explode(",",$giorni_settimana);
                foreach($giorni as $g){
                    if( date('N', strtotime($data)) - 1 == $g ){
                        $d = $data;
                    } else {
                        $d = date('Y-m-d',strtotime(' next '.$days[$g], strtotime($d_inizio) ));
                    }
                    do {
                    if($d >= $data){
                        $attivita[] =$d;
                    }
                    // aggiorno la data con la successiva
                    $d = date('Y-m-d', strtotime($d. ' + '.$cadenza.' weeks'));
                    
                    } while ( $d <= $data_fine );
                }
            break;

            // attività con ripetizione mensile
            case 3:
                if ( empty($data_fine) || $data_fine === NULL ){ 
                    $data_fine = date('Y-m-d', strtotime($data. ' + '.$cadenza * $numero_ripetizioni .' months ')); 
                    $data_fine = date(date('Y',strtotime($data_fine))."-".date('m',strtotime($data_fine))."-01");}
                                    
            if( $ripetizione_mese != 1 ){
                $n_g = numOfDayInWeek($data, $days[ date('N', strtotime($data)) - 1 ]);
                while ( $data < $data_fine ){
                    
                    $attivita[] = $data;
                    $data_temp = date("Y-m-d", strtotime("+ ".$cadenza." month", strtotime($data)));
                    $data_temp = date(date('Y',strtotime($data_temp))."-".date('m',strtotime($data_temp))."-01");
                    $data_temp = date("Y-m-d", strtotime($number[ $n_g -1 ]." ".$days[ date('N', strtotime($data))-1 ], strtotime($data_temp." -1 day")));
                    
                    if( date('m', strtotime($data_temp)) != ((date('m',  strtotime($data)) + $cadenza) % 12 ) ){
                        $data_temp = date("Y-m-d", strtotime("last ".$days[ date('N', strtotime($data))-1 ], strtotime($data_temp)));   
                    }
                    
                    $data = $data_temp;

                };
            } else {
                do {
                    $attivita[] = $data;
                    // aggiorno la data con la successiva
                    $data = date('Y-m-d', strtotime($data. ' + '.$cadenza.' months'));

                } while ( $data <= $data_fine );
            }   
            break;

            // attività con ripetizione annuale
            // TODO gestione seconda tipologia di duplicazione data
            case 4:
                if ( empty($data_fine) || $data_fine === NULL ){ $data_fine = date('Y-m-d', strtotime($data. ' + '.$cadenza * ($numero_ripetizioni - 1).' years')); }
                do {
                    $attivita[] = $data;
                    // aggiorno la data con la successiva
                    $data = date('Y-m-d', strtotime($data. ' + '.$cadenza.' years'));

                } while ( $data < $data_fine );

            break;

        }
   
        return $attivita;
    
    }





    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'inizio creazione pianificazione', 'pianificazione', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__']) && !empty($_REQUEST['__dataf__']) && !empty( $_REQUEST['__id_contratto__'] ) && !empty( $_REQUEST['__turno__'] ) ){

        //print_r( $_REQUEST );
        $status['__status__'] = 'OK';

        // ricavo i giorni che separano data iniziale e data finale
        $gg = ( strtotime($_REQUEST['__dataf__']) - strtotime($_REQUEST['__data__']) ) / (60*60*24);
             
        $result = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__data__'], $_REQUEST['__p__'],$_REQUEST['__cad__'], $_REQUEST['__datafine__'], $_REQUEST['__nr__'],$_REQUEST['__gs__'],$_REQUEST['__rm__'],$_REQUEST['__ra__']);

        if( $result ){
            $status['__status__'] = 'creazione pianificazione completata';
            
            if( is_array( $result ) ){

                foreach( $result as $di ){

                    // setto la data finale
                    $df = date('Y-m-d', strtotime( $di . "+" . $gg . " days"));

                    echo "contratto: " . $_REQUEST['__id_contratto__'] . " - turno: " . $_REQUEST['__turno__'] . " - datainizio: " . $di . " - datafine: " . $df . PHP_EOL;

                    // inserisco le righe di turno
                    $q = mysqlQuery(
                        $cf['mysql']['connection'],
                        'INSERT INTO turni (id_contratto, turno, data_inizio, data_fine) VALUES( ?, ?, ?, ?)',
                        array(
                            array( 's' => $_REQUEST['__id_contratto__'] ),
                            array( 's' => $_REQUEST['__turno__'] ),
                            array( 's' => $di ),
                            array( 's' => $df )
                        )
                    );
                    
                }
            }

        } else {
            $result['__status__'] = 'creazione pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
