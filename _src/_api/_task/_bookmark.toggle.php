<?php

    // inclusione del framework
    require '../../_config.php';
/*
    // se il bookmark esiste già
    if( isset( $_SESSION['__work__'][ $_REQUEST['__key__'] ]['items'][ $_REQUEST['__item__'] ] ) ) {
        unset( $_SESSION['__work__'][ $_REQUEST['__key__'] ]['items'][ $_REQUEST['__item__'] ] );
    } else {

    }
*/
    // debug
    buildJson( ( isset( $_SESSION['__work__'] ) ? $_SESSION['__work__'] : array( 'status' => 'nessun bookmark trovato' ) ) );
