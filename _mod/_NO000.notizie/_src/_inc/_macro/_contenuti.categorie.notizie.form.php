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
    $ct['form']['table'] = 'categorie_notizie';

    // tendina categorie notizie
    $ct['etc']['select']['categorie_notizie'] = tendinaCategorieNotizie();

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
