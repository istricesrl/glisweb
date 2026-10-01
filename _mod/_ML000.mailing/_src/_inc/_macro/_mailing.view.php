<?php

    /**
     * vista dei mailing
     *
     * Elenca i mailing, cioè gli invii della newsletter, dal più recente.
     *
     */

    // configurazione della vista
    $ct['view'] = array(
        'table' => 'mailing',
        'open' => array( 'page' => 'mailing.form' ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'nome',
            NULL => 'azioni'
        ),
        'class' => array(
            '__label__' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__sort__' => array(
            'id' => 'DESC'
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
