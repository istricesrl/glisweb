<?php

    if( isset( $_REQUEST['audit']['id'] ) && isset( $_REQUEST['audit']['id_questionario'] ) ){

        // setto il timestamp di completamento, se richiesto
        if( isset( $_REQUEST['audit']['chiusura'] ) ){
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE controlli SET timestamp_completamento = ? WHERE id_audit = ? AND id_questionario = ?',
                array(
                    array( 's' => time() ),
                    array( 's' => $_REQUEST['audit']['id'] ),
                    array( 's' => $_REQUEST['audit']['id_questionario'] )
                )
            );
        }

        $ct['etc']['questionario'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT nome FROM questionari WHERE id = ?',
            array( array( 's' => $_REQUEST['audit']['id_questionario'] ) )
        );

        // inizializzo l'array delle risposte
        $ct['etc']['risposte'] = array();

        // timestamp_completamento
        $ct['etc']['chiusura'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT min( IFNULL( timestamp_completamento, 0 ) ) FROM controlli WHERE id_audit = ? AND id_questionario = ?',
            array( 
                array( 's' => $_REQUEST['audit']['id'] ),
                array( 's' => $_REQUEST['audit']['id_questionario'] ) 
            )
        );

        // elenco delle domande
        $domande = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT d.* FROM questionari_domande as d INNER JOIN questionari as q ON d.id_questionario = q.id WHERE q.id = ?',
            array( array( 's' => $_REQUEST['audit']['id_questionario'] ) )
        );

        // elenco dei controlli
        $controlli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM controlli_view WHERE id_audit = ? AND id_questionario = ?',
            array( 
                array( 's' => $_REQUEST['audit']['id'] ),
                array( 's' => $_REQUEST['audit']['id_questionario'] ) 
            )
        );

        if( !empty( $domande ) &&  !empty( $controlli )){

            foreach( $domande as $d ){
                $ct['etc']['domande'][$d['id']] = $d;

                // cerco le eventuali opzioni
                $opzioni = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT * FROM opzioni WHERE id_domanda = ?',
                    array( array( 's' => $d['id'] ) )
                );

                if( !empty( $opzioni ) ){
                    foreach( $opzioni as $o ){
                        $ct['etc']['domande'][$d['id']]['opzioni'][$o['id']] = $o;
                    }
                }
            }

            foreach( $controlli as $c ){
                $ct['etc']['controlli'][$c['id']] = $c;
                $ct['etc']['controlli'][$c['id']]['domande'] = $ct['etc']['domande'];
            }

            
        }

         //print_r( $ct['etc']['controlli'] );

        // [__risposte__][controllo23_domanda47] = si
        // [__risposte__][domanda47] = si


        // verifico se ho in request le risposte, se sì le salvo nel db
        if( isset( $_REQUEST['__risposte__'] ) && !empty( $_REQUEST['__risposte__'] ) ){

            // print_r( $_REQUEST['__risposte__'] );

            foreach( $_REQUEST['__risposte__'] as $k => $v ){
                $r = explode( '_', $k );
                $id_controllo = str_replace( "controllo", "", $r[0] );
                $id_domanda = str_replace( "domanda", "", $r[1] );

                // inserisco o aggiorno la risposta
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO risposte ( id_controllo, id_domanda, risposta, step, timestamp_risposta, id_account ) '.
                    'VALUES ( ?, ?, ?, ?, ?, ?) '.
                    'ON DUPLICATE KEY UPDATE risposta = VALUES(risposta), timestamp_risposta = VALUES(timestamp_risposta)',
                    array(
                        array( 's' => $id_controllo ),
                        array( 's' => $id_domanda ),
                        array( 's' => $v ),
                        array( 's' => 1 ),
                        array( 's' => time() ),
                        array( 's' => $_SESSION['account']['id'] )
                    )
                );

                $ct['etc']['risposte']['controlli'][$id_controllo]['domande'][$id_domanda] = $v;
            }
        }
        else{
            // leggo le eventuali risposte dal database
            $risposte = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT r.*, d.id_tipologia FROM risposte as r LEFT JOIN controlli as c ON r.id_controllo = c.id '.
                'LEFT JOIN questionari_domande as d ON c.id_questionario = d.id '.
                'WHERE c.id_audit = ? AND c.id_questionario = ? AND step = 1',
                array( 
                    array( 's' => $_REQUEST['audit']['id'] ),
                    array( 's' => $_REQUEST['audit']['id_questionario'] ) 
                )
            );

            // print_r( $risposte );

            if( !empty( $risposte ) ){
                foreach( $risposte as $r ){
                    $ct['etc']['risposte']['controlli'][$r['id_controllo']]['domande'][$r['id_domanda']] = $r['risposta'];
                }
            }

             //print_r( $ct['etc']['risposte'] );
        }
        
    }

