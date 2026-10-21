<?php

    /**
     * macro della scheda di un SMS inviato, scheda strumenti
     *
     * Macro della pagina `sms.sent.form.tools`: offre la reimmissione in coda dell'SMS aperto
     * ( `/task/SM000.sms/sms.queue.resend?id=<id>` ), che al termine porta alla vista degli SMS in uscita. Ricalca
     * `_mail.sent.form.tools.php` del modulo `MA000.mail`.
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'sms_sent';

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
    'ws' => '/task/SM000.sms/sms.queue.resend?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
    'callback' => 'function() { window.open("' . $cf['contents']['pages']['sms.out.view']['url'][ LINGUA_CORRENTE ] . '", "_self"); }',
    'icon' => NULL,
    'fa' => 'fa-recycle',
    'title' => 'reinvia l\'SMS',
    'text' => 'rimette questo SMS nella coda da inviare'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
