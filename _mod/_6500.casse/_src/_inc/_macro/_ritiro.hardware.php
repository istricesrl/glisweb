<?php

    //unset(  $_REQUEST['documenti']['id'] );
    $ct['form']['table'] = 'documenti';

    if( isset( $_REQUEST['__todo__'] ) && explode( '.', $_REQUEST['__todo__'] )[0] == 'TODO'){

        $todo =  ltrim(explode( '.', $_REQUEST['__todo__'] )[1], "0"); 
        $_REQUEST['todo'] =  mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $todo) ));

    }

    if( !isset( $_REQUEST['todo'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ){

        $_REQUEST['todo'] =  mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ));

    }

    if( isset( $_REQUEST['todo'] ) ){

        $ct['etc']['id_tipologia'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "documento di ritiro"');

        $ct['etc']['id_emittente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM anagrafica_view WHERE se_azienda_gestita = 1 LIMIT 1');

        if( $ct['etc']['id_tipologia'] && $ct['etc']['id_emittente'] ){
            $ct['etc']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT numero FROM documenti WHERE id_tipologia = ? AND id_emittente = ?', 
                                    array( array( 's' => $ct['etc']['id_tipologia'] ), array( 's' => $ct['etc']['id_emittente'] ) ) )+1;
        }


    }










    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
