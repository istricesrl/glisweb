<?php

    /**
     * macro commerciale stampe
     * 
     * Questa macro definisce le stampe disponibili per il modulo commerciale; è presente in standard
     * in modo da poter essere personalizzata in custom.
     * 
     * 
     * 
     * 
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '31.pdf' => array(
            'label' => 'stampe PDF'
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
