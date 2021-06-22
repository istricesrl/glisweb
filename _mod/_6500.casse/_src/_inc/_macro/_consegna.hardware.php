<?php

    //unset(  $_REQUEST['documenti']['id'] );
    $ct['form']['table'] = 'documenti';

    $ct['etc']['mastro'] = 5;

    // pulizia documento attuale
    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['assistenza']['id_documento_consegna'] );
    }

    if( isset( $_REQUEST['__barcode__'] ) && !empty( $_REQUEST['__barcode__'] ) ){

        $barcode = explode( '.', $_REQUEST['__barcode__'] );

        if( $barcode[0] == 'TODO' ){

            $todo = ltrim( $barcode[1], "0"); 

        } elseif( $barcode[0] == 'DOC' ){

            $todo =  mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_todo FROM documenti WHERE id = ?',
                        array( array( 's' => ltrim( $barcode[1], "0") ) ) );

        }



        // tutte le righe legate alla todo

        $righe = mysqlQuery(    $cf['mysql']['connection'], 
                                'SELECT * FROM __report_mastri_todo__ WHERE id_todo = ? ',
                                array(  array( 's' => $todo ) ) );
                              

        if( count($righe) > 0 ){

            $ct['etc']['id_tipologia'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "consegna"');

            if( $ct['etc']['id_tipologia'] ){
                $ct['etc']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT MAX(numero) FROM documenti WHERE id_tipologia = ? ', 
                                        array( array( 's' => $ct['etc']['id_tipologia'] ) ) ) + 1;
            }
    
            if( $ct['etc']['id_tipologia'] && $ct['etc']['numero'] ){

                $documento = mysqlQuery(  $cf['mysql']['connection'],    
                'INSERT INTO documenti ( numero, data, id_tipologia, id_todo, id_emittente, id_destinatario, timestamp_inserimento, id_account_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )',
                array(
                    array( 's' => $ct['etc']['numero'] ),
                    array( 's' => date("Y-m-d") ),
                    array( 's' => $ct['etc']['id_tipologia'] ),
                    array( 's' => $righe[0]['id_todo'] ),
                 //   array( 's' => $righe[0]['id_emittente'] ),
                 //   array( 's' => $righe[0]['id_destinatario'] ),
                 array( 's' => 2 ),
                 array( 's' => 4 ),
                    array( 's' => date("U") ),
                    array( 's' => ( isset( $_SESSION['account']['id'] ) ? $_SESSION['account']['id'] : NULL ) )
                    )
                );  

                if( $documento ){

                    foreach( $righe as $r ){

                        $riga = mysqlQuery(  $cf['mysql']['connection'],    
                        'INSERT INTO documenti_articoli ( data_lavorazione, nome, matricola, id_documento, id_tipologia, id_todo, id_mastro_provenienza, quantita, id_udm, id_listino, id_valuta, importo_netto_totale, id_emittente, id_destinatario, timestamp_inserimento, id_account_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )',
                        array(
                            array( 's' => date("Y-m-d") ),
                            array( 's' => $r['nome'] ),
                            array( 's' => $r['matricola'] ),
                            array( 's' => $documento ),
                            array( 's' => $ct['etc']['id_tipologia'] ),
                            array( 's' => $r['id_todo'] ),
                            array( 's' => $r['id_mastro_destinazione'] ),
                            array( 's' => $r['quantita'] ),
                            array( 's' => $r['id_udm'] ),
                            array( 's' => $r['id_listino'] ),
                            array( 's' => $r['id_valuta'] ),
                            array( 's' => $r['importo_netto_totale'] ),
                            array( 's' => $r['id_emittente'] ),
                            array( 's' => $r['id_destinatario'] ),         
                            array( 's' => date("U") ),
                            array( 's' => ( isset( $_SESSION['account']['id'] ) ? $_SESSION['account']['id'] : NULL ) )
                            )
                        );  
    
                    }

                    $_SESSION['assistenza']['id_documento_consegna'] = $documento;
                    print_r($_SESSION['assistenza']['id_documento_consegna']);
                    $_REQUEST['documenti'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_consegna'] ) ));
                    $_REQUEST['documenti']['documenti_articoli'] = mysqlQuery(    $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ? ',   array(  array( 's' => $_SESSION['assistenza']['id_documento_consegna'] )) );
                    $_REQUEST['documenti']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $_REQUEST['documenti']['id_todo']) ));

                }



            }

        } else {

            $ct['etc']['msg'] = 'nessun documento di ritiro individuato per la todo';

        }
                        
    }

    if( !isset( $_REQUEST['documenti'] ) && isset( $_SESSION['assistenza']['id_documento_consegna'] ) ){

        $_REQUEST['documenti'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_consegna'] ) ));
        $_REQUEST['documenti']['documenti_articoli'] = mysqlQuery(    $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ? ',   array(  array( 's' => $_SESSION['assistenza']['id_documento_consegna'] )) );
        $_REQUEST['documenti']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $_REQUEST['documenti']['id_todo']) ));
    }


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
