<?php

    /**
     * macro dashboard
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    $ct['view']['table'] = 'ordini';

    $ct['view']['id'] = md5(
        $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
        );

    $ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'id_emittente' => 'id_emittente',
        'timestamp_invio' => 'timestamp_invio',
        'timestamp_chiusura' => 'timestamp_chiusura',
        'emittente' => 'emittente',
        '__label__' => '__label__'     
    );

    require DIR_SRC_INC_MACRO . '_default.view.php';

