<?php

    /**
     * questo file contiene funzioni per la misurazione del tempo
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function timerNow() {

	return microtime( true );

    }

    /**
     *
     * @todo documentare
     *
     */
    function timerDiff( $start = START_TIME, $now = NULL ) {

	if( $now === NULL ) { $now = microtime( true ); }

	return $now - $start;

    }

    /**
     *
     * @todo documentare
     *
     */
    function timerCheck( &$a, $c ) {

	$curTime = timerDiff();

	$lastTime = (
	    ( ! empty( $a ) )
		? round(
		    floatval( str_replace( ',', '.', substr( key( array_slice( $a, -1, 1, true ) ), 1 ) ) ), 5
		)
		: 0.0
	);

	$curDelta = ( round( $curTime, 5 ) - $lastTime );
	$curCheck = ( $curDelta < 0.1 ) ? 'OK' : 'NO';
	$curDelta = sprintf( '%0.3f', $curDelta );

	$curMemory = str_pad( writeByte( memory_get_usage( true ) ), 11, '-', STR_PAD_LEFT );

	$a[ 'T'.sprintf( '%024.21f', $curTime ) ] = 
	    sprintf( '%0.3f', $curTime ) . 
	    ' (+' . $curDelta . ' ' . $curCheck . ') ' . 
	    $curMemory . ' -> ' . $c;

    }

?>
