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
	logWrite( "controller finally per ticket ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:

            $todo = mysqlSelectRow( $c, 'SELECT progetti.id_cliente,todo_view.id,todo_view.data_ora_apertura, todo_view.nome, todo_view.testo, todo_view.id_responsabile, todo_view.responsabile FROM todo_view LEFT join progetti ON progetti.id = todo_view.id_progetto WHERE todo_view.id = ?', array( array('s' => $d['id'] ) ) );
            
            // log
	        logWrite( "inserito ticket #".$todo['id'].' per cliente '.$todo['id_cliente'], 'ticket', LOG_CRIT );
            // recupero la mail del responsabile
            $mail = mysqlSelectValue( $c, 'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array( array('s' => $d['id_responsabile'] ) ) );

            // accodao la mail per il responsabile
            if( !empty( $mail ) ){

                // log
	            logWrite( "accodo la mail per il responsabile".$d['id_responsabile'], 'ticket', LOG_CRIT );
               
                $template = mailGetTemplateByRuolo('DEFAULT_TICKET_RESPONSABILE');
                // invio la mail con i dati della todo
                queueMailFromTemplate(
                    $c,
                    $template,
                    array( 'dati' => array( 'todo' => $todo ) ),
                    strtotime( '-5 minutes' ),
                    array( $mail => $mail )
                );

            }

            // recupero la mail cliente
            $mail_cliente = mysqlSelectValue( $c, 'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array( array('s' => $todo['id_cliente'] ) ) );

            // accodo la mail per il cliente
           if( !empty( $mail_cliente ) ){

                // log
	            logWrite( "accodo la mail per il cliente".$todo['id_cliente'], 'ticket', LOG_CRIT );
               
                $template = mailGetTemplateByRuolo('DEFAULT_TICKET_CLIENTE');
                // invio la mail con i dati della todo
                queueMailFromTemplate(
                    $c,
                    $template,
                    array( 'dati' => array( 'todo' => $todo ) ),
                    strtotime( '-5 minutes' ),
                    array( $mail_cliente => $mail_cliente )
                );

            }

        break;

	}
