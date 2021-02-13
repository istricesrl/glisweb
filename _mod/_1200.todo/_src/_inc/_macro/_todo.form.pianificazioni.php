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

    // sotto tabella gestita
	$ct['form']['subtable'] = 'pianificazioni';

   
    //tendina periodi
    $ct['etc']['select']['periodi'] = array(
    //    array( 'id' => 0, '__label__' => 'non si ripete' ),
        array( 'id' => 1, '__label__' => 'giorni' ),
        array( 'id' => 2, '__label__' => 'settimane' ),
        array( 'id' => 3, '__label__' => 'mesi' ),
    //    array( 'id' => 4, '__label__' => 'anno' )
    );

  	// giorni della settimana
  	$ct['etc']['giorni_settimana'] = array(
		array( 'id' => 0, '__label__' => 'lunedì' ),
		array( 'id' => 1, '__label__' => 'martedì' ),
		array( 'id' => 2, '__label__' => 'mercoledì' ),
		array( 'id' => 3, '__label__' => 'giovedì' ),
		array( 'id' => 4, '__label__' => 'venerdì' ),
		array( 'id' => 5, '__label__' => 'sabato' ),
		array( 'id' => 6, '__label__' => 'domenica' )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ]['timestamp_pianificazione'] ) ){
    //    $ct['etc']['data'] = date('Y-m-d', $_REQUEST[ $ct['form']['table'] ]['timestamp_pianificazione'] );
    }
     
    