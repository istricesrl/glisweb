<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO finire di documentare
     *
     * 
     *
     */

    // configurazione della vista template mail
    $ct['view'] = array(
        'table' => 'template',
        'open'  => array( 'page' => 'mail.template.form' ),
        'data'  => array(),
        'cols'  => array(
            'id' => '#',
            'nome' => 'nome',
            '__label__' => 'ruolo',
            NULL => 'azioni'
        ),
        'class' => array(
            'nome' => 'text-start',
            '__label__' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        )
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.view.php';
