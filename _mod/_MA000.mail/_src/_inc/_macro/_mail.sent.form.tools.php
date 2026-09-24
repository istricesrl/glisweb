<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'mail_sent';

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
    'ws' => '/task/MA000.mail/mail.queue.resend?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
    'callback' => 'function() { window.open("' . $cf['contents']['pages']['mail.out.view']['url'][ LINGUA_CORRENTE ] . '", "_self"); }',
    'icon' => NULL,
    'fa' => 'fa-recycle',
    'title' => 'reinvia la mail',
    'text' => 'rimette questa mail nella coda da inviare'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
