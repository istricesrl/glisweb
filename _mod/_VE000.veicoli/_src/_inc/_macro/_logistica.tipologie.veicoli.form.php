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
    $ct['form']['table'] = 'tipologie_veicoli';

    // tendina tipologie veicoli
    $ct['etc']['select']['tipologie_veicoli'] = tendinaTipologieVeicoli();

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
