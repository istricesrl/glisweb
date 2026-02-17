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
    'ws' => '/task/MA000.mail/mail.queue.clean.sent',
    'confirm' => true,
    'icon' => NULL,
    'fa' => 'fa-regular fa-trash-can',
    'title' => 'svuotamento coda mail inviate',
    'text' => 'cancella la coda delle mail inviate'
    );

    timerCheck( $cf['speed'], '-> mail in uscita' );

    $ct['page']['contents']['metro']['15.code'][] = array(
    'ws' => '/task/MA000.mail/mail.queue.clean.out',
    'confirm' => true,
    'icon' => NULL,
    'fa' => 'fa-trash-can',
    'title' => 'svuotamento coda mail in uscita',
    'text' => 'cancella la coda delle mail in uscita senza inviare'
    );

    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
    'ws' => '/task/MA000.mail/mail.queue.send?hard=1',
    'icon' => NULL,
    'fa' => 'fa-regular fa-paper-plane',
    'title' => 'invia la prossima mail in uscita',
    'text' => 'forza elaborazione della prima mail della coda in uscita'
    );

    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
    'confirm' => true,
    'ws' => '/task/MA000.mail/mail.queue.send?full=1',
    'icon' => NULL,
    'fa' => 'fa-paper-plane',
    'title' => 'elabora coda mail in uscita',
    'text' => 'forza elaborazione di tutta la coda delle mail in uscita'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
