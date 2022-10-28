<?php

    if( isset( $_REQUEST['controlli']['id'] ) ){

        // setto il timestamp di completamento, se richiesto
        if( isset( $_REQUEST['controlli']['chiusura'] ) ){
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE controlli SET timestamp_completamento = ? WHERE id = ?',
                array(
                    array( 's' => time() ),
                    array( 's' => $_REQUEST['controlli']['id'] )
                )
            );
        }

        $ct['etc']['controllo'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM controlli WHERE id = ?',
            array( array( 's' => $_REQUEST['controlli']['id'] ) )
        );

        $ct['etc']['id_audit'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_audit FROM controlli WHERE id = ?',
            array( array( 's' => $_REQUEST['controlli']['id'] ) )
        );

        $ct['etc']['questionario'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT q.nome FROM questionari as q INNER JOIN controlli as c ON q.id = c.id_questionario WHERE c.id = ?',
            array( array( 's' => $_REQUEST['controlli']['id'] ) )
        );

        // inizializzo l'array delle risposte
        $ct['etc']['risposte'] = array();

        // elenco delle domande
        $domande = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT d.* FROM questionari_domande as d INNER JOIN controlli as c ON d.id_questionario = c.id_questionario WHERE c.id = ?',
            array( array( 's' => $_REQUEST['controlli']['id'] ) )
        );

        if( !empty( $domande ) ){
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
        }

        // print_r( $ct['etc']['domande'] );

        // [__risposte__][controllo23_domanda47] = si
        // [__risposte__][domanda47] = si


        // verifico se ho in request le risposte, se sì le salvo nel db
        if( isset( $_REQUEST['__risposte__'] ) && !empty( $_REQUEST['__risposte__'] ) ){

            foreach( $_REQUEST['__risposte__'] as $k => $v ){
                $id_domanda = str_replace( "domanda", "", $k );

                // inserisco o aggiorno la risposta
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO risposte ( id_controllo, id_domanda, risposta, step, timestamp_risposta, id_account ) '.
                    'VALUES ( ?, ?, ?, ?, ?, ?) '.
                    'ON DUPLICATE KEY UPDATE risposta = VALUES(risposta), timestamp_risposta = VALUES(timestamp_risposta)',
                    array(
                        array( 's' => $_REQUEST['controlli']['id'] ),
                        array( 's' => $id_domanda ),
                        array( 's' => $v ),
                        array( 's' => 1 ),
                        array( 's' => time() ),
                        array( 's' => $_SESSION['account']['id'] )
                    )
                );

                $ct['etc']['risposte'][$id_domanda] = $v;
            }
        }
        else{
            // leggo le eventuali risposte dal database
            $risposte = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT r.*, d.id_tipologia FROM risposte as r LEFT JOIN questionari_domande as d ON r.id_domanda = d.id WHERE r.id_controllo = ? AND step = 1',
                array( array( 's' => $_REQUEST['controlli']['id'] ) )
            );

            if( !empty( $risposte ) ){
                foreach( $risposte as $r ){
                    $ct['etc']['risposte'][$r['id_domanda']] = $r['risposta'];
                }
            }

            // print_r( $ct['etc']['risposte'] );
        }

    }

