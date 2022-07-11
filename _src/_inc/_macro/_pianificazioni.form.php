<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'pianificazioni';

    // tendina tipologie indirizzi
	$ct['etc']['select']['entita'] =

    $ct['etc']['select']['periodi'] = array(
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'attivita', '__label__' => 'attivita' ),
        array( 'id' => 'rinnovi', '__label__' => 'rinnovi' ),
        array( 'id' => 'documenti', '__label__' => 'documenti' ),
        array( 'id' => 'documenti_articoli', '__label__' => 'righe di documenti' ),
        array( 'id' => 'pagamenti', '__label__' => 'pagamenti' )
    );

	
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
