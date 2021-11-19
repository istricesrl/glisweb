<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller after
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller finally per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:

            $todo = mysqlSelectRow( $c, 'SELECT * FROM todo_view WHERE id = ?', array( array('s' => $d['id'] ) ) );
                // log
	        logWrite( "è stato inserito il ticket ".$todo['id'].' etichetta  '.$todo['__label__'], 'controller', LOG_CRIT );

        break;

	}
