<?php

    //unset(  $_REQUEST['documenti']['id'] );
    $ct['form']['table'] = 'documenti';

    $ct['etc']['mastro'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM mastri WHERE nome = "magazzino di lavoro"' ) ;

    $ct['etc']['id_emittente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM anagrafica_view WHERE se_gestita = 1 LIMIT 1');
    $ct['etc']['id_tipologia'] =  mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "consegna"');
         
    // pulizia documento attuale
    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['assistenza']['id_documento_consegna'] );
        unset( $_SESSION['assistenza']['id_todo_consegna'] );  
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
                                'SELECT * FROM __report_giacenza_mastri__ WHERE id_todo = ? AND quantita_totale > 0',
                                array(  array( 's' => $todo ) ) );
                              

        if( count($righe) > 0 ){

            $_SESSION['assistenza']['id_todo_consegna'] = $todo;

            $_REQUEST['documenti']['id_tipologia'] = $ct['etc']['id_tipologia'];
            $_REQUEST['documenti']['id_emittente'] =  $ct['etc']['id_emittente'];
            $_REQUEST['documenti']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT MAX(numero) FROM documenti WHERE id_tipologia = ? ', 
                                                array( array( 's' =>  $_REQUEST['documenti']['id_tipologia'] ) ) )+1;
            $_REQUEST['documenti']['data'] = date("Y-m-d");
            $_REQUEST['documenti']['id_destinatario'] = $righe[0]['id_destinatario'];
            $_REQUEST['documenti']['id_progetto'] = $righe[0]['id_progetto'];
            $_REQUEST['documenti']['id_todo'] = $todo;
            
            $_REQUEST['documenti']['documenti_articoli'] = array();

            for( $i = 0; $i < count($righe); $i++  ){
                $_REQUEST['documenti']['documenti_articoli'][ $i ]['quantita'] = $righe[ $i ]['quantita_totale'];
                $_REQUEST['documenti']['documenti_articoli'][ $i ]['matricola'] = $righe[ $i ]['id_matricola'];
                $_REQUEST['documenti']['documenti_articoli'][ $i ]['nome'] = $righe[ $i ]['descrizione'];
            }
            

        } else {

            $ct['etc']['msg'] = 'nessun hardware da riconsegnare legato alla todo';

        }
                        
    }

    if( isset( $_REQUEST['documenti']['id'] ) && !isset( $_SESSION['assistenza']['id_documento_consegna'] ) ){
        $_SESSION['assistenza']['id_documento_consegna'] = $_REQUEST['documenti']['id'];
    }

    if( isset( $_SESSION['assistenza']['id_todo_consegna'] )  ){

        $_REQUEST['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' =>  $_SESSION['assistenza']['id_todo_consegna'] ) ));
  
    }

    if( !isset( $_REQUEST['documenti'] ) && isset( $_SESSION['assistenza']['id_documento_consegna'] ) ){

        $_REQUEST['documenti'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_consegna'] ) ));
        $_REQUEST['documenti']['documenti_articoli'] = mysqlQuery(    $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ? ',   array(  array( 's' => $_SESSION['assistenza']['id_documento_consegna'] )) );
        $_REQUEST['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $_REQUEST['documenti']['id_todo']) ));
    }


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
