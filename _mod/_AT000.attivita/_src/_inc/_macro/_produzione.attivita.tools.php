<?php

    /**
     *
     *
     *
     * TODO implementare
     * TODO documentare
     *
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.esportazioni' => array(
            'label' => 'esportazioni'
        ),
        '02.importazioni' => array(
            'label' => 'importazioni'
        ),
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        ),
        '05.static' => array(
            'label' => 'viste statiche'
        )
    );

    if( in_array( "AT000.attivita", $cf['mods']['active']['array'] ) ) {

        $ct['page']['contents']['metro']['05.static'][] = array(
            'lws' => '/task/AT000.attivita/attivita.view.static.popolazione',
            'icon' => NULL,
            'fa' => 'fa-refresh',
            'title' => 'ripopola attivita view static',
            'text' => 'ripopola la view static delle attivita'
        );

        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'modal' => array( 'id' => 'archivia_attivita', 'include' => 'inc/produzione.attivita.tools.modal.archivia.attivita.twig' ),
            'icon' => NULL,
            'fa' => 'fa-box-archive',
            'title' => 'archivia attivita',
            'text' => 'archivia una o più attivita per range di date'
        );

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
