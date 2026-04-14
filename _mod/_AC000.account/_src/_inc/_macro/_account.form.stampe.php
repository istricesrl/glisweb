<?php

    /**
     * macro account form stampe
     * 
     * Questa macro definisce le stampe disponibili per il singolo account; è presente in standard
     * in modo da poter essere personalizzata in custom.
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'account';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '31.pdf' => array(
            'label' => 'stampe PDF'
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
