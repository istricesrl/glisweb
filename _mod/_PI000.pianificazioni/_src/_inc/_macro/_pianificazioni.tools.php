<?php

    /**
     * macro degli strumenti delle pianificazioni
     *
     * Questa macro prepara la pagina pianificazioni.tools, con il comando per elaborare subito la prima pianificazione
     * scaduta ( lo stesso lavoro che fa il blocco delle pianificazioni di _src/_api/_cron.php a ogni passata ). Il
     * comando compare solo a chi ha il privilegio GESTIONE_PIANIFICAZIONI, che è quello richiesto dal task.
     *
     * -# gruppi di controlli
     * -# comandi
     * -# macro di default
     *
     * @file
     *
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    // elaborazione della prima pianificazione scaduta
    if( getPrivilege( 'GESTIONE_PIANIFICAZIONI' ) ) {
        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'ws' => '/task/PI000.pianificazioni/pianificazioni.populate',
            'callback' => 'function() { location.reload(); }',
            'icon' => NULL,
            'fa' => 'fa-calendar-plus',
            'title' => 'elabora la prossima pianificazione',
            'text' => 'crea gli oggetti della prima pianificazione scaduta, come fa il cron'
        );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
