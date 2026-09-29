<?php

    /**
     * macro della scheda di un SMS in uscita, scheda strumenti
     *
     * Macro della pagina `sms.out.form.tools`: offre l'invio immediato dell'SMS aperto ( `/task/SM000.sms/sms.queue.send?id=<id>` ),
     * che al termine porta alla vista degli inviati. Ricalca `_mail.out.form.tools.php` del modulo `MA000.mail`.
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'sms_out';

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
        ),
        '08.account' => array(
            'label' => 'account'
        ),
        '12.archivium' => array(
            'label' => 'Archivium'
        )
    );

    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
    'ws' => '/task/SM000.sms/sms.queue.send?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
    'callback' => 'function() { window.open("' . $cf['contents']['pages']['sms.sent.view']['url'][ LINGUA_CORRENTE ] . '", "_self"); }',
    'icon' => NULL,
    'fa' => 'fa-regular fa-paper-plane',
    'title' => 'invia immediatamente l\'SMS',
    'text' => 'forza un tentativo di invio per questo SMS'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
