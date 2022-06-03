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
        'emittente' => 'emittente',
        '__label__' => '__label__'     
    );

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente']['EQ'] ) && isset($_SESSION['account']['id_anagrafica'] ) ){
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente']['EQ'] = $_SESSION['account']['id_anagrafica'] ;
	} 

    require DIR_SRC_INC_MACRO . '_default.view.php';

