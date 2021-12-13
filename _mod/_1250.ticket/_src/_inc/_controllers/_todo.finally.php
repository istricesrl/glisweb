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
/*
    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:

            $todo = mysqlSelectRow( 
                $c, 
                "SELECT t.*, 
                p.id_cliente,
                coalesce(
                a.soprannome,
                a.denominazione,
                concat_ws(' ', coalesce(a.cognome, ''),
                coalesce(a.nome, '') ),
                ''
                ) AS cliente FROM ticket_view AS t
                LEFT JOIN progetti AS p ON t.id_progetto = p.id
                LEFT JOIN anagrafica AS a ON p.id_cliente = a.id 
                WHERE t.id = ?", array( array('s' => $d['id'] ) ) );
            
            // log
	        logWrite( "inserito ticket #".$todo['id'].' per cliente '.$todo['id_cliente'], 'ticket' );
            // recupero la mail del responsabile
            $mail = mysqlSelectValue( $c, 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY id LIMIT 1', array( array('s' => $d['id_responsabile'] ) ) );

            // accodo la mail per il responsabile
            if( !empty( $mail ) ){

                // log
	            logWrite( "accodo la mail per il responsabile ".$d['id_responsabile'], 'ticket' );
               
                // recupero template
                $template = mailGetTemplateByRuolo('DEFAULT_TICKET_RESPONSABILE');

                // invio la mail con i dati della todo
                queueMailFromTemplate(
                    $c,
                    $template,
                    array( 'dati' => $todo ),
                    strtotime( '+1 minutes' ),
                    array( $mail => $mail )
                );

            }

            // recupero la mail cliente
            $mail_cliente = mysqlSelectValue( $c, 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? AND se_notifiche = 1 ORDER BY id LIMIT 1', array( array('s' => $todo['id_cliente'] ) ) );

            // accodo la mail per il cliente
           if( !empty( $mail_cliente ) ){

                // log
	            logWrite( "accodo la mail per il cliente ".$todo['id_cliente'], 'ticket' );
               
                // recupero il template
                $template = mailGetTemplateByRuolo('DEFAULT_TICKET_CLIENTE');
                
                // invio la mail con i dati della todo
                queueMailFromTemplate(
                    $c,
                    $template,
                    array( 'dati' => $todo ),
                    strtotime( '+1 minutes' ),
                    array( $mail_cliente => $mail_cliente )
                );

            }

        break;

	}
*/
