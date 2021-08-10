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

    /*
    // tendina tipologie pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);
    */
    
    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) {
	    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 OR id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) );
	} else {
	    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
	}

    // tendina tipologia
	$ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_produzione = 1' );

    // tendina tipologia inps
	$ct['etc']['select']['id_tipologia_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view' );

    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina esiti
	$ct['etc']['select']['id_esito'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM esiti_attivita_view' );

    // tendina interesse
	$ct['etc']['select']['id_interesse'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_interesse_view' );

    // tendina soddisfazione
	$ct['etc']['select']['id_soddisfazione'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_soddisfazione_view' );

    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view'
	);

    // tendina progetti
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE ( timestamp_chiusura IS NULL OR id = ? ) ORDER BY __label__', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) );
	} else {
	    $ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE timestamp_chiusura IS NULL ORDER BY __label__' );
	}

    // tendina todo
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view_static WHERE id_progetto = ? AND ( timestamp_completamento IS NULL OR id = ? )', 
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ), 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ) 
            );
	} else {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view_static' );
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

	if( isset( $_REQUEST['__preset__']['attivita']['id_todo']  ) ){
	    $todo = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_view_static WHERE id = ?', 
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

    // tendina tipologia attivita
	$ct['etc']['id_tipologia_attivita_new'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_dashboard_agenda = 1 ORDER BY nome' );


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

 