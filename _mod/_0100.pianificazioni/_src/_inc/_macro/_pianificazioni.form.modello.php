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

    // documenti
    if( $_REQUEST[ $ct['form']['table'] ]['entita'] == 'documenti' ) {
        require DIR_BASE . '_mod/_0100.pianificazioni/_src/_inc/_macro/_pianificazioni.form.modello.documenti.php';
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
