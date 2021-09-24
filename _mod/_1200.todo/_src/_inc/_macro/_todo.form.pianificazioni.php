<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'todo';
   
    //tendina periodi
    $ct['etc']['select']['periodi'] = array(
    //    array( 'id' => 0, '__label__' => 'non si ripete' ),
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


    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

    /*    $ct['etc']['data'] = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            "SELECT from_unixtime(timestamp_pianificazione, '%Y-%m-%d') FROM todo WHERE id = ?",
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );
    */

    // cerco la todo genitore
        if( !empty($_REQUEST[ $ct['form']['table'] ]['id_pianificazione'] ) ){
            $ct['etc']['id_genitore'] = mysqlSelectValue( 
                $cf['mysql']['connection'], 
                'SELECT id_todo FROM pianificazioni WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'] ) )
            );
        }
        
        // array per il workspace della pianificazione
        $wks = array(
            'metadati' => array(
                'pause' => array(
                    'tabella' => 'pause_progetti',
                    'campo' => 'id_progetto',
                    'strategia' => array(
                        'duplica' => false
                    )
                )
            ),
            'sostituzioni' => array(
                'todo' => array(
                    'data_programmazione' => '§data§',
                    'id_pianificazione' => '§id_pianificazione§'
                ),
                'attivita' => array(
                    'data_programmazione' => '§data§',
                    'data_attivita' => '§data§'
                )
          )
        );

        $ct['etc']['wks'] = json_encode( $wks, JSON_UNESCAPED_UNICODE );
        
    }

    $ct['page']['contents']['metros'] = array(
	    'pianificazione' => array(
		'label' => 'pianificazione'
	    )
	);

    // modal per scollegare la todo dalla pianificazione
	$ct['page']['contents']['metro']['pianificazione'][] = array(
	    'modal' => array('id' => 'scollega', 'include' => 'inc/todo.form.pianificazioni.modal.scollega.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-unlock-alt',
	    'title' => 'scollega dalla pianificazione',
	    'text' => 'scollega la todo corrente dalla pianificazione'
	);

    // modal per modificare la pianificazione originaria
    $ct['page']['contents']['metro']['pianificazione'][] = array(
	    'modal' => array('id' => 'modifica', 'include' => 'inc/todo.form.pianificazioni.modal.modifica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-calendar',
	    'title' => 'modifica pianificazione',
	    'text' => 'modifica la pianificazione'
	);

    // modal per accedere all'oggetto genitore
    $ct['page']['contents']['metro']['pianificazione'][] = array(
	    'modal' => array('id' => 'genitore', 'include' => 'inc/todo.form.pianificazioni.modal.genitore.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-pencil',
	    'title' => 'modifica genitore',
	    'text' => 'accede all\'oggetto genitore'
	);

    // modal per fermare la pianificazione originaria
    $ct['page']['contents']['metro']['pianificazione'][] = array(
        'modal' => array('id' => 'ferma', 'include' => 'inc/todo.form.pianificazioni.modal.ferma.html' ),
        'icon' => NULL,
        'fa' => 'fa-archive',
        'title' => 'ferma pianificazione',
        'text' => 'interrompe la pianificazione'
    );

    // modal per pulire gli oggetti futuri non più conformi
    $ct['page']['contents']['metro'][NULL][] = array(
	    'modal' => array('id' => 'pulisci', 'include' => 'inc/todo.form.pianificazioni.modal.pulisci.html' )
	);

    // modal per ricreare gli oggetti futuri e crearli di nuovo
    $ct['page']['contents']['metro'][NULL][] = array(
	    'modal' => array('id' => 'ripianifica', 'include' => 'inc/todo.form.pianificazioni.modal.ripianifica.html' )
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';

     