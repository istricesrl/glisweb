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

    // tendina delle entita che è possibile generare
    // 'todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti')
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'rinnovi', '__label__' => 'rinnovi' ),
        array( 'id' => 'documenti', '__label__' => 'documenti' ),
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'attivita', '__label__' => 'attività' )
    );

    //tendina periodi
    $ct['etc']['select']['periodi'] = array(
        array( 'id' => 1, '__label__' => 'giorni' ),
        array( 'id' => 2, '__label__' => 'settimane' ),
        array( 'id' => 3, '__label__' => 'mesi' ),
    //    array( 'id' => 4, '__label__' => 'anno' )
    );

    //elenco periodicità
    $ct['etc']['select']['periodicita'] = array(
        array( 'id' => 1, '__label__' => 'giornaliera' ),
        array( 'id' => 2, '__label__' => 'settimanale' ),
        array( 'id' => 3, '__label__' => 'mensile' ),
        array( 'id' => 4, '__label__' => 'annuale' )
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
                    "SELECT data_programmazione FROM todo WHERE id = ?",
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
        // se la pianificazione è legata a un progetto
        elseif( $_REQUEST[ $ct['form']['table'] ]['entita'] == 'progetti' && !empty( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ){
            $ct['etc']['data'] = mysqlSelectValue( 
                    $cf['mysql']['connection'], 
                    "SELECT data_accettazione FROM progetti WHERE id = ?",
                    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
                );  
            
            $ct['etc']['id_oggetto'] = $_REQUEST[ $ct['form']['table'] ]['id_progetto'];
        }
    }

    $ct['page']['contents']['metros'] = array(
	    'scorciatoie' => array(
		'label' => 'scorciatoie'
	    )
	);

     // modal per fermare la pianificazione originaria
     $ct['page']['contents']['metro']['scorciatoie'][] = array(
        'modal' => array('id' => 'ripianifica', 'include' => 'inc/pianificazioni.form.modal.ripianifica.html' ),
        'icon' => NULL,
        'fa' => 'fa-update',
        'title' => 'ripianifica oggetti',
        'text' => 'rimuove e ricrea gli oggetti da una certa data in poi'
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
