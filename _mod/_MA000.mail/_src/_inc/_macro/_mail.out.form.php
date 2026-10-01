<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'mail_out';

    // gli allegati messi da parte ( gruppo mailattach dei bookmarks ) si tolgono dalla memoria di lavoro appena la
    // mail e' stata salvata con i suoi file, altrimenti si riaggiungerebbero a ogni mail nuova della sessione; come
    // _mail.out.form.php del modulo 0030.strumenti per la linea .html
    if( isset( $_SESSION['__work__']['mailattach']['items'] ) && isset( $_POST[ $ct['form']['table'] ]['file'] ) ) {
        unset( $_SESSION['__work__']['mailattach'] );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
