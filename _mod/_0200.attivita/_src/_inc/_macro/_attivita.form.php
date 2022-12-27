<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'attivita';


    // tendina tipologie pubblicazioni
	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM immobili_view'
	);
    
    
    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );


	    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static' );


    // tendina tipologia
	$ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__' );


    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );


    // tendina progetti
	    $ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view ORDER BY __label__' );

    // tendina todo
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view WHERE id_progetto = ? ', 
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] )
            )
            );
	} else {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view' );
	}

    // tendina todo
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_documento'] ) ) {
	    $ct['etc']['select']['id_documento'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM documenti_view WHERE id_documento = ? ', 
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_documento'] )
            )
            );
	} else {
	    $ct['etc']['select']['id_documento'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM documenti_view' );
	}

    // tendina indirizzi
    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );

    // tendina mastri
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 3'
    );

    // tendina matricole
	$ct['etc']['select']['matricole'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM matricole_view'
    );

    // tendina documenti_articoli
	$ct['etc']['select']['id_documenti_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM documenti_articoli_view'
    );
    

	if( isset( $_REQUEST['__preset__']['attivita']['id_todo']  ) ){
	    $todo = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_view WHERE id = ?', 
        array( array( 's' => $_REQUEST['__preset__']['attivita']['id_todo'] ) ) );
        
        if( ! empty($todo['id_cliente']) ){
            $_REQUEST['__preset__']['attivita']['id_cliente'] = $todo['id_cliente'];
        }
        
        if( ! empty($todo['id_progetto']) ){
	        $_REQUEST['__preset__']['attivita']['id_progetto'] = $todo['id_progetto'];
        }

        if( ! empty($todo['id_indirizzo']) ){
	        $_REQUEST['__preset__']['attivita']['id_indirizzo'] = $todo['id_indirizzo'];
        }

        if( ! empty($todo['id_mastro_attivita_default']) ){
	        $_REQUEST['__preset__']['attivita']['id_mastro_provenienza'] = $todo['id_mastro_attivita_default'];
        }

        if( !empty($todo['data_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['data_programmazione'] = $todo['data_programmazione'];
        }

        if( !empty($todo['ora_inizio_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['ora_inizio_programmazione'] = $todo['ora_inizio_programmazione'];
        }
        
        if( !empty($todo['ora_fine_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['ora_fine_programmazione'] = $todo['ora_fine_programmazione'];
        }
	}

   /* if( isset($_REQUEST['attivita']['__matricola__']) ){
        $_REQUEST['attivita']['id_matricola'] =  mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM matricole_view WHERE __label__ = ?', array( array( 's' => $_REQUEST['attivita']['__matricola__'] ) )
        );
    }*/

    // modal per la conferma di sostituzione operatore
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'sostituisci-operatore', 'include' => 'inc/attivita.form.modal.sostituisci.operatore.html' )
    );
    
    // debug
    // die( $_REQUEST['__continue__'] );
    // die( $_SESSION['__latest__']['attivita']['id_todo'] );
    // die( $_SESSION['__latest__']['attivita']['id_progetto'] );

    if( isset( $_REQUEST['attivita']['id_todo'] ) && ! empty( $_REQUEST['attivita']['id_todo'] ) ){
        // echo 'ID todo: ' . $_REQUEST['attivita']['id_todo'];
        $ct['etc']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo WHERE id = ?', array( array( 's' => $_REQUEST['attivita']['id_todo']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => $_REQUEST['attivita']['id_todo']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita', array( array( 's' => $_REQUEST['attivita']['id_todo']) ));
    } elseif( isset( $_REQUEST['__continue__'] ) && ! empty( $_REQUEST['__continue__'] ) && isset( $_SESSION['__latest__']['attivita']['id_todo'] ) && ! empty( $_SESSION['__latest__']['attivita']['id_todo'] ) ){
        // echo 'ID todo (latest): ' . $_SESSION['__latest__']['attivita']['id_todo'];
        $ct['etc']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo WHERE id = ?', array( array( 's' => $_SESSION['__latest__']['attivita']['id_todo']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => $_SESSION['__latest__']['attivita']['id_todo']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita', array( array( 's' => $_SESSION['__latest__']['attivita']['id_todo']) ));
    } elseif( isset( $_REQUEST['__preset__']['attivita']['id_todo'] ) && ! empty( $_REQUEST['__preset__']['attivita']['id_todo'] ) ){
        // echo 'ID todo (preset): ' . $_REQUEST['__preset__']['attivita']['id_todo'];
        $ct['etc']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo WHERE id = ?', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_todo']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_todo']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_todo = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_todo']) ));
    } elseif( isset( $_REQUEST['attivita']['id_progetto'] ) && ! empty( $_REQUEST['attivita']['id_progetto'] )  ){
        // echo 'ID progetto: ' . $_REQUEST['attivita']['id_progetto'];
        $ct['etc']['progetto'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM progetti WHERE id = ?', array( array( 's' => $_REQUEST['attivita']['id_progetto']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NOT NULL ORDER BY data_attivita LIMIT 5', array( array( 's' => $_REQUEST['attivita']['id_progetto']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita LIMIT 5', array( array( 's' => $_REQUEST['attivita']['id_progetto']) ));
    } elseif( isset( $_REQUEST['__continue__'] ) && ! empty( $_REQUEST['__continue__'] ) && isset( $_SESSION['__latest__']['attivita']['id_progetto'] ) && ! empty( $_SESSION['__latest__']['attivita']['id_progetto'] ) ){
        // echo 'ID progetto (latest): ' . $_SESSION['__latest__']['attivita']['id_progetto'];
        $ct['etc']['progetto'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM progetti WHERE id = ?', array( array( 's' => $_SESSION['__latest__']['attivita']['id_progetto']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NOT NULL ORDER BY data_attivita LIMIT 5', array( array( 's' => $_SESSION['__latest__']['attivita']['id_progetto']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita LIMIT 5', array( array( 's' => $_SESSION['__latest__']['attivita']['id_progetto']) ));
    } elseif( isset( $_REQUEST['__preset__']['attivita']['id_progetto'] ) && ! empty( $_REQUEST['__preset__']['attivita']['id_progetto'] ) ){
        // echo 'ID progetto (preset): ' . $_REQUEST['__preset__']['attivita']['id_progetto'];
        $ct['etc']['progetto'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM progetti WHERE id = ?', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_progetto']) ));
        $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_progetto']) ));
        $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id_progetto = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita', array( array( 's' => $_REQUEST['__preset__']['attivita']['id_progetto']) ));
    }

    // debug
    // print_r( $ct['etc']['attivita_completate'] );
    // print_r( $ct['etc']['attivita_programmate'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

 