<?php

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

    /**
     * genera attività in base ai parametri
     *
     * Questa funzione viene usata per generare attività che si ripetono nel tempo.
     * 
     *
     * @param	int		$id_anagrafica	id anagrafica del soggetto proprietario dell'attività
     * @param	int		$id_cliente     il cliente o il soggetto che fruisce dell'attività    
     * @param	int		$id_luogo       il luogo dove l'attività pianificata verrà svolta
     * @param	string	$data           data dell'attività(se la pianificazione è per eventi che si ripetono equivale alla data di inizio pianificazione)
     * @param	int		$ore            durata dell'attività
     * @param	int		$id_periodicita tipologia ti attiivita: 0 = non si ripete, 1 = giornaliera, 2 = settimanale, 3 = mensile, 4 = annuale 
     * @param   int     $cadenza        ogni quanti giorni/settimane/mesi/anni l'attività si ripete
     * @param   string  $data_fine      
     * @param   int     $numero_ripetinzioni    numero di pianificazioni attività
     *  
     * 
     * @return	boolean			restituisce true se la generazione delle attività ha avuto successo, false altrimenti
     *
     *
     *
     * 
     *
     */
   

    // funzione per la creazione di un'array di date pianificate in base a criteri specifici
    function creazionePianificazione( $c, $data, $id_periodicita, $cadenza=NULL, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){ 

        // TODO controlli
               // la data inizio è successiva alla data fine

        $number = ['first', 'second', 'third', 'fourth','fifth','sixth'];
        $days = ['Monday', 'Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday' ];
        $months = ['January','February','March','April','May','June','July','August','September','October','November','December' ];
        //$attivita[] = array();
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
                    $dow = date('N', strtotime($data)) - 1;
                    do {
                        $attivita[] = $data; 
                        $data_temp = date("Y-m-d", strtotime("+ ".$cadenza." month", strtotime($data)));
                        $data_temp = date(date('Y',strtotime($data_temp))."-".date('m',strtotime($data_temp))."-01");
                        $data_temp = date("Y-m-d", strtotime($number[ $n_g -1 ]." ".$days[ $dow ], strtotime($data_temp." -1 day")));
                
                        if( date('m', strtotime($data_temp)) != ((date('m',  strtotime($data)) + $cadenza) % 12 ) ){
                            $data_temp = date("Y-m-d", strtotime("last ".$days[ $dow ], strtotime($data_temp)));   
                         }
                        
                        $data = $data_temp;
    
                    } while ( $data < $data_fine );
                } else {
                    do {
                        $attivita[] = $data;
                        // aggiorno la data con la successiva
                        $data = date('Y-m-d', strtotime($data. ' + '.$cadenza.' months'));
    
                    } while ( $data < $data_fine );
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