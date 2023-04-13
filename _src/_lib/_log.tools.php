<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // namespace
	use Google\Cloud\Logging\LoggingClient;

    /**
     *
     * https://cloud.google.com/logging/docs/setup/php
     *
     * @todo documentare
     *
     */
    function log2google( $l, $f, $p, $m, $r ) {

	// logger di test
	    $logging = new LoggingClient([
		'projectId' => $p
	    ]);

	// logger PSR
	    $logger = $logging->psrLogger( $f );

	// messaggi di test
	    switch( $l ) {
		case 0:
		    $logger->emergency( $m, $r );
		break;
		case 1:
		    $logger->alert( $m, $r );
		break;
		case 2:
		    $logger->critical( $m, $r );
		break;
		case 3:
		    $logger->error( $m, $r );
		break;
		case 4:
		    $logger->warning( $m, $r );
		break;
		case 5:
		    $logger->notice( $m, $r );
		break;
		case 6:
		    $logger->info( $m, $r );
		break;
		case 7:
		    $logger->debug( $m, $r );
		break;
	    }

    }
