<?php

    // inclusione del framework
    require '../_config.php';

    // output
    buildJson( ( isset( $_SESSION['__work__'] ) ? $_SESSION['__work__'] : array( 'status' => 'nessun bookmark trovato' ) ) );
