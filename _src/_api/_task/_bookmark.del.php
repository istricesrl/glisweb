<?php

    // inclusione del framework
    require '../../_config.php';

    // ...
    unset( $_SESSION['__work__'][ $_REQUEST['__key__'] ]['items'][ $_REQUEST['__item__'] ] );

    // debug
    buildJson( ( isset( $_SESSION['__work__'] ) ? $_SESSION['__work__'] : array( 'status' => 'nessun bookmark trovato' ) ) );
