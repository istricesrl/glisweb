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
    $ct['form']['table'] = 'redirect';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
    arraySortBy( ['__label__'], $ct['etc']['select']['siti'] );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

