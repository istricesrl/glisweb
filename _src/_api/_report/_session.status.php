<?php

    // runlevel da saltare
    	$cf['runlevels']['run'] = array(
            '050', '055'
	    );

    // debug
        // session_start();
        // echo 'SESSION' . PHP_EOL;
        // print_r( $_SESSION );

    // dati di contesto
        require '../../_config.php';

    // rinnovo sessione
        if( isset( $_REQUEST['renew'] ) ) {
            $_SESSION['used']			= time();
        }

    // debug
        // print_r( get_included_files() );

    // stampo i dati di validità della sessione corrente
        echo json_encode(
            array(
                'used' => $_SESSION['used'],
                'lifetime' => SESSION_LIMIT,
                'expires' => ( $_SESSION['used'] + SESSION_LIMIT ),
                'time' => time(),
                'notes' =>
                    'used ' . date( 'Y-m-d H:i:s', $_SESSION['used'] ) . ' ' .
                    'expire ' . date( 'Y-m-d H:i:s', $_SESSION['used'] + SESSION_LIMIT )
            )
        );

?>
