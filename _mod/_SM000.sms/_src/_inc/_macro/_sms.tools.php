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
        ),
        '15.code' => array(
            'label' => 'code'
        )
    );

    $ct['page']['contents']['metro']['15.code'][] = array(
    'ws' => '/task/SM000.sms/sms.queue.clean.sent',
    'confirm' => true,
    'icon' => NULL,
    'fa' => 'fa-regular fa-trash-can',
    'title' => 'svuotamento coda SMS inviati',
    'text' => 'cancella la coda degli SMS inviati'
    );

    timerCheck( $cf['speed'], '-> SMS in uscita' );

    $ct['page']['contents']['metro']['15.code'][] = array(
        'ws' => '/task/SM000.sms/sms.queue.clean.out',
        'confirm' => true,
        'icon' => NULL,
        'fa' => 'fa-trash-can',
        'title' => 'svuotamento coda SMS in uscita',
        'text' => 'cancella la coda degli SMS in uscita senza inviare'
    );

    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
    'ws' => '/task/SM000.sms/sms.queue.send?hard=1',
    'icon' => NULL,
    'fa' => 'fa-regular fa-paper-plane',
    'title' => 'invia il prossimo SMS in uscita',
    'text' => 'forza elaborazione del primo SMS della coda in uscita'
    );

    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
    'confirm' => true,
    'ws' => '/task/SM000.sms/sms.queue.send?full=1',
    'icon' => NULL,
    'fa' => 'fa-paper-plane',
    'title' => 'elabora coda SMS in uscita',
    'text' => 'forza elaborazione di tutta la coda degli SMS in uscita'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
