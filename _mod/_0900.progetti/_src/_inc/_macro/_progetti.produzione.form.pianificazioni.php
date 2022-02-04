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
    $ct['form']['table'] = 'progetti';
   
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

        // cerco la pianificazione figlia di questa todo, se esiste
        $pianificazione = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT * FROM pianificazioni WHERE id_progetto = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );


        // array per il workspace della pianificazione
        $wks = array(
            'metadati' => array(
                'pause' => array()
            ),
            'sostituzioni' => array(
                'progetti' => array(
                    'id' => '§ref_id+data§',
                    'data_accettazione' => '§data§',
                    'id_pianificazione' => '§id_pianificazione§'
                ),
                'todo' => array(
                    'data_programmazione' => '%null%',
                    'ora_inizio_programmazione' => '%null%',
                    'ora_fine_programmazione' => '%null%'
                ),
                'progetti_categorie' => array()
                /*'todo_categorie' => array()
                ,
                'attivita' => array(
                    'data_programmazione' => '%null%',
                    'ora_inizio_programmazione' => '%null%',
                    'ora_fine_programmazione' => '%null%'
                ),
                'attivita_categorie' => array()*/
            )
        );

        $ct['etc']['wks'] = json_encode( $wks, JSON_UNESCAPED_UNICODE );

        // echo $ct['etc']['wks'];
        
    }

    $ct['page']['contents']['metros'] = array(
	    'pianificazione' => array(
		'label' => 'pianificazione'
	    )
	);

    // modal per scollegare la todo dalla pianificazione
	$ct['page']['contents']['metro']['pianificazione'][] = array(
	    'modal' => array('id' => 'scollega', 'include' => 'inc/progetti.produzione.form.pianificazioni.modal.scollega.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-unlock-alt',
	    'title' => 'scollega dalla pianificazione',
	    'text' => 'scollega il progetto corrente dalla pianificazione'
	);

    // modal per modificare la pianificazione originaria
    $ct['page']['contents']['metro']['pianificazione'][] = array(
	    'modal' => array('id' => 'modifica', 'include' => 'inc/progetti.produzione.form.pianificazioni.modal.modifica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-calendar',
	    'title' => 'modifica pianificazione',
	    'text' => 'modifica la pianificazione'
	);

/*
    // modal per fermare la pianificazione originaria
    $ct['page']['contents']['metro']['pianificazione'][] = array(
        'modal' => array('id' => 'ferma', 'include' => 'inc/progetti.produzione.form.pianificazioni.modal.ferma.html' ),
        'icon' => NULL,
        'fa' => 'fa-archive',
        'title' => 'ferma pianificazione',
        'text' => 'interrompe la pianificazione'
    );

    // modal per pulire gli oggetti futuri non più conformi
    $ct['page']['contents']['metro'][NULL][] = array(
	    'modal' => array('id' => 'pulisci', 'include' => 'inc/progetti.produzione.form.pianificazioni.modal.pulisci.html' )
	);
*/
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';

     