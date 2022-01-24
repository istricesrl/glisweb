<?php

    //unset(  $_REQUEST['documenti']['id'] );
    $ct['form']['table'] = 'documenti';

    /*if( isset( $_SESSION['assistenza']['id_documento'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && ( $_SESSION['assistenza']['id_documento'] == $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        unset( $_REQUEST[ $ct['form']['table'] ] );
    }*/
    $ct['etc']['mastro'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM mastri WHERE nome = "magazzino di lavoro"' ) ;

    if( isset( $_REQUEST['todo'] ) && !isset( $_SESSION['assistenza']['id_todo_ritiro'] ) ){
        unset($_REQUEST['todo']);
    }

    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['assistenza'] );
        unset( $_SESSION['assistenza']['id_documento_ritiro'] );
        unset( $_SESSION['assistenza']['id_todo_ritiro'] );
        unset( $_SESSION['assistenza'] );
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['__method__'] ) && $_REQUEST[ $ct['form']['table'] ]['__method__'] == 'post'  ){
        $_SESSION['assistenza']['id_documento_ritiro'] = $_REQUEST[ $ct['form']['table'] ]['id'];
        
    }
    

    if( isset( $_SESSION['assistenza']['id_documento_ritiro'] ) ){
        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_ritiro'] ) ));

        $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = mysqlQuery($cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_ritiro'] ) ));

    }


    if( isset( $_REQUEST['__todo__'] ) && explode( '.', $_REQUEST['__todo__'] )[0] == 'TODO'){

        $todo =  ltrim(explode( '.', $_REQUEST['__todo__'] )[1], "0"); 
        $_SESSION['assistenza']['id_todo_ritiro'] = $todo;
        $_REQUEST['todo'] =  mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $todo) ));

    }

    if( !isset( $_REQUEST['todo'] ) && isset( $_SESSION['assistenza']['id_todo_ritiro'] ) ){
        $_REQUEST['todo'] =  mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_todo_ritiro'] ) ));
    }

    if( isset( $_REQUEST['todo'] ) ){

        $ct['etc']['id_tipologia'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "documento di ritiro"');

        $ct['etc']['id_emittente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM anagrafica_view WHERE se_gestita = 1 LIMIT 1');

        if( $ct['etc']['id_tipologia'] && $ct['etc']['id_emittente'] ){
            $ct['etc']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT MAX(numero) FROM documenti WHERE id_tipologia = ? ', 
                                    array( array( 's' => $ct['etc']['id_tipologia'] ) ) )+1;
        }


    }


    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && empty( $_REQUEST[ $ct['form']['table'] ] ) && isset( $_SESSION['assistenza']['id_documento_ritiro'] ) ){

        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM documenti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_ritiro'] ) ));

        $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = mysqlQuery($cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_ritiro'] ) ));

    }

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && !isset( $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] ) && isset($_SESSION['assistenza']['id_documento_ritiro']) ){
    //    $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = mysqlQuery($cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ?', array( array( 's' => $_SESSION['assistenza']['id_documento_ritiro'] ) ));

    }

    if( isset( $_SESSION['assistenza']['id_documento_ritiro'] ) && !isset( $_REQUEST[ $ct['form']['table'] ]['id']) ){
        $_REQUEST[ $ct['form']['table'] ]['id'] = $_SESSION['assistenza']['id_documento_ritiro'];
    }/* else {
        $_REQUEST[ $ct['form']['table'] ]['id'] = NULL;
    }*/

    //print_r( $_SESSION['assistenza'] );
   // print_r( $_REQUEST );
    $ct['page']['contents']['metro'][NULL][] = array(
		'modal' => array( 'id' => 'genera_matricola', 'include' => 'inc/ritiro.hardware.modal.html' )
	    );

    $ct['etc']['select']['matricole'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id,  concat( "MAT.", LPAD(id,10,"0") )AS __label__ FROM matricole_view' );

    $ct['etc']['select']['marchi'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM marchi_view' );

    $ct['etc']['select']['matricole'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_produttore = 1' );


       
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';
