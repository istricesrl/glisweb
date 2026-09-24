<?php

    /**
     * macro dashboard tools
     *
     *
     *
     * TODO documentare
     *
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '00.esportazioni' => array(
            'label' => 'esportazioni'
        ),
        '01.importazioni' => array(
            'label' => 'importazioni'
        )
    );

    // gestione di default dei tools
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
