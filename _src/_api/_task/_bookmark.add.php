<?php

    // inclusione del framework
    require '../../_config.php';

    // debug
    buildJson( ( isset( $_SESSION['__work__'] ) ? $_SESSION['__work__'] : array( 'status' => 'nessun bookmark trovato' ) ) );
