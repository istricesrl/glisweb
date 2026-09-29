<?php

    /**
     * macro della vista pianificazioni
     *
     * Questa macro prepara la pagina pianificazioni.view, la vista unica di tutte le pianificazioni, sorella delle
     * viste dei task e dei job ( _mod/_0030.strumenti/_src/_inc/_macro/_task.view.php e _job.view.php ): una riga per
     * pianificazione, qualunque sia l'entità che genera. Le pianificazioni figlie ( righe e pagamenti del modello di
     * un documento ) non compaiono, perché si gestiscono dal modello della pianificazione genitore.
     *
     * -# configurazione della vista
     * -# macro di default
     *
     * @file
     *
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'pianificazioni',
        'open' => array(
            'page' => 'pianificazioni.form',
            'table' => 'pianificazioni'
        ),
        'cols' => array(
            'id' => '#',
            'entita' => 'entità',
            'nome' => 'pianificazione',
            'periodicita' => 'periodicità',
            'cadenza' => 'ogni',
            'data_avvio' => 'attiva dal',
            'data_ultimo_oggetto' => 'ultimo oggetto',
            'data_fine' => 'fino al',
            'data_ora_elaborazione' => 'ultima elaborazione'
        ),
        'class' => array(
            'id' => 'd-none d-md-table-cell',
            'entita' => 'no-wrap',
            'nome' => 'text-start',
            'periodicita' => 'no-wrap',
            'data_avvio' => 'no-wrap',
            'data_ultimo_oggetto' => 'no-wrap',
            'data_fine' => 'no-wrap',
            'data_ora_elaborazione' => 'text-end no-wrap'
        ),
        '__restrict__' => array(
            'id_genitore' => array( 'NL' => true )
        ),
        '__sort__' => array(
            'id' => 'DESC'
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
