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
    $ct['form']['table'] = 'contatti';

    // tendina tipologie notizie
    $ct['etc']['select']['tipologie_contatti'] = tendinaTipologieContatti();

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
