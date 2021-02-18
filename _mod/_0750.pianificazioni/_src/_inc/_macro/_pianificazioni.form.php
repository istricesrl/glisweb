<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'pianificazioni';

    // tendina delle entita che è possibile gestire
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'turni', '__label__' => 'turni' )
    );

    //tendina periodi
    $ct['etc']['select']['periodi'] = array(
        array( 'id' => 1, '__label__' => 'giorni' ),
        array( 'id' => 2, '__label__' => 'settimane' ),
        array( 'id' => 3, '__label__' => 'mesi' ),
    //    array( 'id' => 4, '__label__' => 'anno' )
    );

    //elenco periodicità
    $ct['etc']['periodicita'] = array(
        array( 'id' => 1, '__label__' => 'giornaliera' ),
        array( 'id' => 2, '__label__' => 'settimanale' ),
        array( 'id' => 3, '__label__' => 'mensile' )
    );

    //tendina ripetizioni mensili
    $ct['etc']['select']['ripetizioni_mese'] = array(
        array( 'id' => 1, '__label__' => '1' ),
        array( 'id' => 2, '__label__' => '2' )
    );

    // elenco giorni della settimana
    $ct['etc']['giorni_settimana'] = array(
        array( 'id' => 0, '__label__' => 'lunedì' ),
        array( 'id' => 1, '__label__' => 'martedì' ),
        array( 'id' => 2, '__label__' => 'mercoledì' ),
        array( 'id' => 3, '__label__' => 'giovedì' ),
        array( 'id' => 4, '__label__' => 'venerdì' ),
        array( 'id' => 5, '__label__' => 'sabato' ),
        array( 'id' => 6, '__label__' => 'domenica' )
    );

    // estraggo la data di partenza e l'id dell'oggetto genitore, a seconda della sua tipologia
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['entita'] ) ){

        // se la pianificazione è legata a una todo
        if( $_REQUEST[ $ct['form']['table'] ]['entita'] == 'todo' && !empty( $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ){
            $ct['etc']['data'] = mysqlSelectValue( 
                    $cf['mysql']['connection'], 
                    "SELECT from_unixtime(timestamp_pianificazione, '%Y-%m-%d') FROM todo WHERE id = ?",
                    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) )
                );  
            
            $ct['etc']['id_oggetto'] = $_REQUEST[ $ct['form']['table'] ]['id_todo'];
        }
        // se la pianificazione è legata a un turno
        elseif( $_REQUEST[ $ct['form']['table'] ]['entita'] == 'turni' && !empty( $_REQUEST[ $ct['form']['table'] ]['id_turno'] ) ){
            $ct['etc']['data'] = mysqlSelectValue( 
                    $cf['mysql']['connection'], 
                    "SELECT data_inizio FROM turni WHERE id = ?",
                    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_turno'] ) )
                ); 
            
                $ct['etc']['id_oggetto'] = $_REQUEST[ $ct['form']['table'] ]['id_turno']; 
        }



    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
