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
	        logWrite( "inserito ticket #".$todo['id'], 'ticket', LOG_CRIT );
            // recupero la mail del responsabile
            $mail = mysqlSelectValue( $c, 'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array( array('s' => $d['id_responsabile'] ) ) );

            // accodao la mail per il responsabile
            if( !empty( $mail ) ){

                // log
	            logWrite( "accodo la mail per il responsabile".$d['id_responsabile'], 'ticket', LOG_CRIT );
               
                // invio la mail con i dati della todo
                queueMailFromTemplate(
                    $c,
                    $cf['mail']['tpl'][ 'DEFAULT_TICKET_RESPONSABILE'],
                    array( 'dati' => array( 'todo' => $todo ) ),
                    strtotime( '-5 minutes' ),
                    array( $mail => $mail ),
                    NULL,
                    array(),
                    array(),
                    array(),
                    NULL,
                    10
                );
                print_r($cf);
            }
            // recupero la mail cliente

            // accodo la mail per il cliente


        break;

	}
