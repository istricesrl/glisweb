<?php

    // runlevel da saltare
    	$cf['runlevels']['run'] = array(
            '000', '005',
            '010', '015',
            '020', '025',
            '040', '045',
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
#        echo json_encode(
        buildJson(
            array(
                'used' => $_SESSION['used'],
                'lifetime' => SESSION_LIMIT,
                'expires' => ( $_SESSION['used'] + SESSION_LIMIT ),
                'time' => time(),
                'notes' => array(
                    'used ' => date( 'Y-m-d H:i:s', $_SESSION['used'] ),
                    'expire ' => date( 'Y-m-d H:i:s', $_SESSION['used'] + SESSION_LIMIT ),
                    'files' => get_included_files(),
                    'redis' => (
                        ( isset( $cf['redis']['connection'] ) && ! empty( $cf['redis']['connection'] ) ) 
                        ? 1
                        : 0
                    )
                )
            )
        );
