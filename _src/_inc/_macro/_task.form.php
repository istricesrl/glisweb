<?php


    // tabella gestita
	$ct['form']['table'] = 'task';

    // recupero macro
    $tsk = array_unique(
        array_merge(
            glob( glob2custom( DIR_SRC_API_TASK . '*.php' ), GLOB_BRACE ),
            glob( glob2custom( DIR_MOD_ATTIVI_SRC_API_TASK . '*.php' ), GLOB_BRACE )
        )
    );

    // tendina macro
	foreach( $tsk as $t ) {
        $t = str_replace( DIR_BASE, NULL, $t );
	    $ct['etc']['select']['task'][] = array( 'id' => $t, '__label__' => $t );
	}

    // elenco giorni della settimana
    $ct['etc']['select']['giorni_della_settimana'] = array(
        array( 'id' => 0, '__label__' => 'domenica' ),
        array( 'id' => 1, '__label__' => 'lunedì' ),
        array( 'id' => 2, '__label__' => 'martedì' ),
        array( 'id' => 3, '__label__' => 'mercoledì' ),
        array( 'id' => 4, '__label__' => 'giovedì' ),
        array( 'id' => 5, '__label__' => 'venerdì' ),
        array( 'id' => 6, '__label__' => 'sabato' )
    );

    // elenco giorni della settimana
    $ct['etc']['select']['mesi'] = array(
        array( 'id' => 1, '__label__' => 'gennaio' ),
        array( 'id' => 2, '__label__' => 'febbraio' ),
        array( 'id' => 3, '__label__' => 'marzo' ),
        array( 'id' => 4, '__label__' => 'aprile' ),
        array( 'id' => 5, '__label__' => 'maggio' ),
        array( 'id' => 6, '__label__' => 'giugno' ),
        array( 'id' => 7, '__label__' => 'luglio' ),
        array( 'id' => 8, '__label__' => 'agosto' ),
        array( 'id' => 9, '__label__' => 'settembre' ),
        array( 'id' => 10, '__label__' => 'ottobre' ),
        array( 'id' => 11, '__label__' => 'novembre' ),
        array( 'id' => 12, '__label__' => 'dicembre' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
