<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO non dovrebbe essere _cron.tools.php?
     * 
     * 
     */


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

    function numOfWeeksInYear( $y ) {

        $week_count = date('W', strtotime($y . '-12-31'));

        if ($week_count == '01')
        {   
            $week_count = date('W', strtotime($y . '-12-24'));
        }
        
        // echo ($week_count - date('W'));
        // echo ' weeks left in ' . date('Y') . '!';

        return $week_count;

    }

    function numOfWorkingDaysInMonth($year, $month, $ignore = array( 0, 6 ) ) {
        $count = 0;
        $counter = mktime(0, 0, 0, $month, 1, $year);
        while (date("n", $counter) == $month) {
            if (in_array(date("w", $counter), $ignore) == false) {
                $count++;
            }
            $counter = strtotime("+1 day", $counter);
        }
        return $count;
    }

    /**
     * genera todo che si ripetono nel tempo
     *
     * Questa funzione crea una todo per ogni data restituita da creazionePianificazione() con gli stessi parametri di
     * ripetizione, tutte con lo stesso proprietario, cliente, luogo, orario e nome; la usa il task
     * _src/_api/_task/_todo.generazione.php. L'ora di fine è l'ora di inizio più $ore ore. La periodicità è l'id della
     * tabella periodicita ( 0 nessuna ripetizione, 1 giornaliera, 2 settimanale, 3 mensile, da 4 a 7 bimestrale ...
     * semestrale, 8 annuale ), come per creazionePianificazione().
     *
     * NOTA fino al 2026-09-25 la funzione ricalcolava le date per conto suo, con gli stessi difetti che aveva
     * creazionePianificazione() ( e con 4 per l'annuale, dalla numerazione precedente alla tabella periodicita ),
     * scriveva nelle colonne ora_inizio_pianificazione e ora_fine_pianificazione, rinominate in *_programmazione nel
     * 2021, usava un $id_progetto mai definito e sommava le ore a una stringa: non poteva creare niente.
     *
     * @param       object      $c                      la connessione mysqli
     * @param       int         $id_anagrafica          l'anagrafica proprietaria delle todo
     * @param       int         $id_cliente             il cliente per cui si svolgono
     * @param       int         $id_luogo               il luogo dove si svolgono
     * @param       string      $data                   la data della prima todo ( inizio della ripetizione )
     * @param       string      $ora                    l'ora di inizio ( HH:MM )
     * @param       float       $ore                    la durata in ore
     * @param       int         $id_periodicita         il tipo di ripetizione ( id della tabella periodicita )
     * @param       string      $descrizione            il nome delle todo
     * @param       int         $cadenza                ogni quante unità di tempo ripetere
     * @param       string      $data_fine              la data fino alla quale ripetere, compresa
     * @param       int         $numero_ripetizioni     quanti periodi generare se manca $data_fine
     * @param       mixed       $giorni_settimana       i giorni della settimana per la settimanale ( 0 lunedì ... 6 domenica )
     * @param       int         $ripetizione_mese       1 per lo stesso giorno del mese, altro per la ripetizione posizionale
     * @param       int         $ripetizione_anno       come $ripetizione_mese, per l'annuale
     *
     * @return      boolean                             true se sono state create tutte le todo, false altrimenti
     *
     */
    function pianificazioneTodo( $c, $id_anagrafica, $id_cliente, $id_luogo, $data, $ora, $ore, $id_periodicita, $descrizione,$cadenza, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1 ){

        // date in cui creare le todo
        $date = creazionePianificazione( $data, $id_periodicita, $cadenza, $data_fine, $numero_ripetizioni, $giorni_settimana, $ripetizione_mese, $ripetizione_anno );

        // ora di fine
        $ora_fine = ( empty( $ora ) ) ? NULL : date( 'H:i', strtotime( $ora ) + round( floatval( str_replace( ',', '.', $ore ) ) * 3600 ) );

        // esito
        $attivita = ! empty( $date );

        // creo una todo per ogni data
        foreach( $date as $d ) {
            $attivita = mysqlInsertRow(
                $c,
                array(
                    'id_anagrafica'                 => $id_anagrafica,
                    'id_cliente'                    => $id_cliente,
                    'id_luogo'                      => $id_luogo,
                    'data_programmazione'           => $d,
                    'ora_inizio_programmazione'     => $ora,
                    'ora_fine_programmazione'       => $ora_fine,
                    'ore_programmazione'            => $ore,
                    'nome'                          => $descrizione
                ),
                'todo'
            ) && $attivita;
        }

        return $attivita;

    }

    /**
     * crea un array di date pianificate in base a criteri specifici
     *
     * Questa funzione restituisce le date ( nel formato Y-m-d ) in cui cade una ripetizione che parte da $data e arriva
     * fino a $data_fine COMPRESA, ordinate dalla più vecchia alla più recente e senza doppioni; è il calcolo su cui si
     * appoggiano le pianificazioni ( _mod/_PI000.pianificazioni ) e la generazione delle todo. Il tipo di ripetizione è
     * l'id della tabella periodicita:
     *
     * id  | periodicità    | date prodotte
     * ----|----------------|------------------------------------------------------------------------------------------
     * 0   | nessuna        | la sola $data
     * 1   | giornaliera    | ogni $cadenza giorni a partire da $data
     * 2   | settimanale    | nei giorni $giorni_settimana ( 0 lunedì ... 6 domenica ), ogni $cadenza settimane contate
     *     |                | dalla settimana di $data, senza le date precedenti a $data; senza giorni, il giorno della
     *     |                | settimana di $data
     * 3   | mensile        | ogni $cadenza mesi lo stesso giorno del mese di $data; nei mesi più corti l'ultimo giorno
     *     |                | del mese ( 31/01, 28/02, 31/03, 30/04 ); con $ripetizione_mese diverso da 1 lo stesso
     *     |                | giorno della settimana nella stessa posizione ( il secondo martedì ), o l'ultimo di quel
     *     |                | giorno se nel mese la posizione non c'è ( il quinto venerdì )
     * 4-7 | bimestrale ... | come la mensile, ogni 2, 3, 4 o 6 mesi moltiplicati per $cadenza
     *     | semestrale     |
     * 8   | annuale        | ogni $cadenza anni lo stesso giorno di $data ( il 29/02 diventa 28/02 negli anni non
     *     |                | bisestili ); con $ripetizione_anno diverso da 1 posizionale come la mensile
     *
     * Le date mensili e annuali si calcolano tutte a partire da $data e non ciascuna dalla precedente: così un giorno
     * accorciato da un mese breve non si trascina nei mesi successivi. Se $data_fine è vuota la ripetizione si ferma dopo
     * $numero_ripetizioni periodi ( giorni, settimane, mesi o anni moltiplicati per la cadenza ); se $data_fine è
     * precedente a $data, o la periodicità non è fra quelle elencate, restituisce un array vuoto.
     *
     * @param       string      $data                   la data di inizio della ripetizione
     * @param       int         $id_periodicita         il tipo di ripetizione ( id della tabella periodicita, vedi sopra )
     * @param       int         $cadenza                ogni quante unità di tempo ripetere ( default 1 )
     * @param       string      $data_fine              la data fino alla quale ripetere, compresa ( default nessuna )
     * @param       int         $numero_ripetizioni     quanti periodi generare se manca $data_fine ( default 1 )
     * @param       mixed       $giorni_settimana       i giorni della settimana per la settimanale, come array o come
     *                                                  stringa separata da virgole ( 0 lunedì ... 6 domenica )
     * @param       int         $ripetizione_mese       1 per lo stesso giorno del mese, altro per la ripetizione
     *                                                  posizionale ( default 1 )
     * @param       int         $ripetizione_anno       come $ripetizione_mese, per l'annuale ( default 1 )
     * @param       bool        $solo_future            se true restituisce solo le date successive a $data ( default false )
     *
     * @return      array                               le date pianificate, ordinate
     *
     */
    function creazionePianificazione( $data, $id_periodicita, $cadenza=NULL, $data_fine=NULL, $numero_ripetizioni=1, $giorni_settimana=NULL,$ripetizione_mese=1, $ripetizione_anno=1, $solo_future=false ){

        // log
        logWrite( 'richiesta generazione ' . $data . ' periodicità ' . $id_periodicita, 'todo' );

        // array delle date
        $attivita = array();

        // valori di default
        if( empty( $cadenza ) ) { $cadenza = 1; }
        if( empty( $numero_ripetizioni ) ) { $numero_ripetizioni = 1; }

        // normalizzo le date
        $data = date( 'Y-m-d', strtotime( $data ) );
        if( ! empty( $data_fine ) ) { $data_fine = date( 'Y-m-d', strtotime( $data_fine ) ); }

        // mesi fra una ripetizione e la successiva, per le periodicità da mensile ad annuale
        $mesi = array( 3 => 1, 4 => 2, 5 => 3, 6 => 4, 7 => 6, 8 => 12 );

        // in base al tipo di periodicità della pianificazione vengono generate le date
        switch( $id_periodicita ) {

            // l'attività non si ripete
            case 0:
                $attivita[] = $data;
            break;

            // attività con ripetizione giornaliera
            case 1:
                for( $i = 0; empty( $data_fine ) ? $i < $numero_ripetizioni : true; $i++ ) {
                    $d = date( 'Y-m-d', strtotime( $data . ' +' . ( $i * $cadenza ) . ' days' ) );
                    if( ! empty( $data_fine ) && $d > $data_fine ) { break; }
                    $attivita[] = $d;
                }
            break;

            // attività con ripetizione settimanale
            case 2:

                // giorni della settimana ( 0 lunedì ... 6 domenica )
                $giorni = array();
                foreach( ( is_array( $giorni_settimana ) ? $giorni_settimana : explode( ',', $giorni_settimana ?? '' ) ) as $g ) {
                    if( trim( $g ) !== '' && $g >= 0 && $g <= 6 ) { $giorni[] = (int) $g; }
                }

                // senza giorni vale il giorno della settimana della data di inizio
                if( empty( $giorni ) ) { $giorni[] = date( 'N', strtotime( $data ) ) - 1; }

                // NOTA fino al 2026-09-25 le date si generavano un giro per ogni giorno della settimana e uscivano
                // disordinate ( lun-mer-ven dal 01/10/2026 dava 05, 12, 07, 14, 02, 09, 16 ): chi le prendeva una
                // alla volta, come le fatture, numerava fuori ordine e saltava per sempre le date più vecchie;
                // adesso si lavora settimana per settimana, e in fondo si ordina comunque
                sort( $giorni );
                $giorni = array_unique( $giorni );

                // lunedì della settimana di inizio
                $lunedi = date( 'Y-m-d', strtotime( 'monday this week', strtotime( $data ) ) );

                // data di fine di default
                if( empty( $data_fine ) ) { $data_fine = date( 'Y-m-d', strtotime( $lunedi . ' +' . ( $cadenza * $numero_ripetizioni * 7 - 1 ) . ' days' ) ); }

                // una settimana ogni $cadenza
                for( $i = 0; ( $inizio = date( 'Y-m-d', strtotime( $lunedi . ' +' . ( $i * $cadenza * 7 ) . ' days' ) ) ) <= $data_fine; $i++ ) {
                    foreach( $giorni as $g ) {
                        $d = date( 'Y-m-d', strtotime( $inizio . ' +' . $g . ' days' ) );
                        if( $d >= $data && $d <= $data_fine ) { $attivita[] = $d; }
                    }
                }

            break;

            // attività con ripetizione mensile, bimestrale, trimestrale, quadrimestrale, semestrale e annuale
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:

                // mesi fra una ripetizione e la successiva
                $passo = $mesi[ $id_periodicita ] * $cadenza;

                // ripetizione posizionale ( il secondo martedì del mese )
                $posizionale = ( $id_periodicita == 8 ) ? ( $ripetizione_anno != 1 ) : ( $ripetizione_mese != 1 );

                // anno, mese, giorno, giorno della settimana e sua posizione nel mese della data di inizio
                $anno = date( 'Y', strtotime( $data ) );
                $mese = date( 'n', strtotime( $data ) );
                $giorno = date( 'j', strtotime( $data ) );
                $dow = date( 'N', strtotime( $data ) );
                $posizione = ceil( $giorno / 7 );

                // NOTA fino al 2026-09-25 ogni data si calcolava dalla precedente con strtotime( '+1 month' ), che dal
                // 31/01 porta al 03/03 e da lì la deriva si accumula; adesso l'i-esima data si calcola dalla data di
                // inizio, e nei mesi più corti si ferma all'ultimo giorno del mese
                for( $i = 0; empty( $data_fine ) ? $i < $numero_ripetizioni : true; $i++ ) {

                    // mese e anno della ripetizione
                    $m = $mese - 1 + $i * $passo;
                    $a = $anno + intdiv( $m, 12 );
                    $m = $m % 12 + 1;

                    // ultimo giorno del mese
                    $ultimo = date( 't', mktime( 0, 0, 0, $m, 1, $a ) );

                    // giorno della ripetizione
                    if( $posizionale ) {
                        $g = 1 + ( $dow - date( 'N', mktime( 0, 0, 0, $m, 1, $a ) ) + 7 ) % 7 + ( $posizione - 1 ) * 7;
                        if( $g > $ultimo ) { $g -= 7; }
                    } else {
                        $g = min( $giorno, $ultimo );
                    }

                    // data della ripetizione
                    $d = sprintf( '%04d-%02d-%02d', $a, $m, $g );
                    if( ! empty( $data_fine ) && $d > $data_fine ) { break; }
                    $attivita[] = $d;

                }

            break;

            // periodicità sconosciuta
            default:
                logWrite( 'periodicità sconosciuta ' . $id_periodicita, 'todo', LOG_ERR );
            break;

        }

        // ordino le date e tolgo i doppioni
        $attivita = array_values( array_unique( $attivita ) );
        sort( $attivita );

        // NOTA fino al 2026-09-25 qui si toglieva il primo elemento dell'array, che per una settimanale che non
        // parte in uno dei giorni scelti è già una data futura; adesso si tolgono le date non successive a $data
        if( $solo_future == true ) {
            $attivita = array_values( array_filter( $attivita, function( $d ) use ( $data ) { return $d > $data; } ) );
        }

        // debug
        // print_r( $attivita );

        return $attivita;

    }

        function createDateRangeArray($strDateFrom,$strDateTo)
        {
            // prende in input due date nel formato YYYY-MM-DD e crea un array con le date 
        
            $aryRange = [];
        
            $iDateFrom = mktime(1, 0, 0, substr($strDateFrom, 5, 2), substr($strDateFrom, 8, 2), substr($strDateFrom, 0, 4));
            $iDateTo = mktime(1, 0, 0, substr($strDateTo, 5, 2), substr($strDateTo, 8, 2), substr($strDateTo, 0, 4));

            if ($iDateTo >= $iDateFrom) {
                array_push($aryRange, date('Y-m-d', $iDateFrom)); // first entry
                // echo $iDateFrom.' '.$iDateTo.'<br>';
                while ($iDateFrom<$iDateTo) {
                    $iDateFrom += 86400; // add 24 hours
                    array_push($aryRange, date('Y-m-d', $iDateFrom));
                }
            }

            return $aryRange;
            
        }

        function daysBetweenDates( $a, $b ) {

            $origin = new DateTimeImmutable( $a );
            $target = new DateTimeImmutable( $b );
            $interval = $origin->diff( $target );
    
            $years = $interval->format('%r%y') * 12;
            $months = $interval->format('%r%m');
    
            return $interval->format( '%r%a' );
    
        }
    
        function monthsBetweenDates( $a, $b = NULL ) {

            if( empty( $a ) ) return 0;
            if( empty( $b ) ) $b = date( 'Y-m-d' );
    
            $origin = new DateTimeImmutable( $a );
            $target = new DateTimeImmutable( $b );
            $interval = $origin->diff( $target );
    
            $years = $interval->format('%r%y') * 12;
            $months = $interval->format('%r%m');
    
            return $years + $months;
    
        }

        function yearsBetweenDates( $a, $b = NULL ) {

            if( empty( $a ) ) return 0;
            if( empty( $b ) ) $b = date( 'Y-m-d' );
    
            $origin = new DateTimeImmutable( $a );
            $target = new DateTimeImmutable( $b );
            $interval = $origin->diff( $target );
    
            $years = $interval->format('%r%y');
    
            return $years;
    
        }
