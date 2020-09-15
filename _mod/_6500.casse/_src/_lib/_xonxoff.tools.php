<?php

    function XonXoff_creaSocket( $address, $port = 0, $timeout = 2 ) {

	logWrite( 'tento di creare un socket su ' . $address, 'socket', LOG_CRIT );

	$tries = 0;

	$socket = false;
	$tsQuit = time() + $timeout;

	$socket = socket_create( AF_INET , SOCK_STREAM , SOL_TCP );
	socket_set_option( $socket , SOL_SOCKET , SO_RCVTIMEO , array( 'sec' => 1 , 'usec' => 0 ) );
	socket_set_option( $socket , SOL_SOCKET , SO_SNDTIMEO , array( 'sec' => 1 , 'usec' => 0 ) );

	if( $socket === false ) {

	    logWrite( 'socket_create() failed: ' . socket_strerror( socket_last_error() ), 'socket', LOG_CRIT );
	    return false;

	} else {

	    while( ! socket_connect( $socket , $address , $port ) ) {

		$tries++;

		if( time() > $tsQuit ) {

		    logWrite( 'socket_connect() failed after ' . $tries . ' tries: ' . socket_strerror( socket_last_error( $socket ) ), 'socket', LOG_CRIT );
		    return false;

		}

		time_nanosleep( 0, 500000000 );

	    }

	}

	return $socket;

    }

    function XonXoff_chiudiSocket( $socket ) {

	socket_close( $socket );

    }

?>
