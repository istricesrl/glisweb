<?php

    /**
     * strumenti della newsletter
     *
     * Importazione degli iscritti da CSV ( nel formato del modello `_usr/_examples/_csv/iscritti.import.csv` o in
     * quello esportato da MailChimp ) ed esportazione degli iscritti di una lista. Erano gli strumenti della vista
     * liste di `_7000.mailing`.
     *
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.esportazioni' => array(
            'label' => 'esportazioni'
        ),
        '02.importazioni' => array(
            'label' => 'importazioni'
        )
    );

    // importazione iscritti
    $ct['page']['contents']['metro']['02.importazioni'][] = array(
        'modal' => array( 'id' => 'importa_iscritti', 'include' => 'inc/mailing.tools.modal.import.twig' ),
        'icon' => NULL,
        'fa' => 'fa-upload',
        'title' => 'importazione iscritti',
        'text' => 'importa iscritti in formato CSV'
    );

    // importazione iscritti da MailChimp
    $ct['page']['contents']['metro']['02.importazioni'][] = array(
        'modal' => array( 'id' => 'importa_iscritti_mailchimp', 'include' => 'inc/mailing.tools.modal.import.mailchimp.twig' ),
        'icon' => NULL,
        'fa' => 'fa-upload',
        'title' => 'importazione iscritti da MailChimp',
        'text' => 'importa iscritti in formato CSV da MailChimp'
    );

    // esportazione iscritti
    $ct['page']['contents']['metro']['01.esportazioni'][] = array(
        'modal' => array( 'id' => 'esporta_per_lista', 'include' => 'inc/mailing.tools.modal.export.twig' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione iscritti alla lista',
        'text' => 'esporta gli iscritti alla lista in formato CSV'
    );

    // tendina liste
    $ct['etc']['select']['liste'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM liste_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
