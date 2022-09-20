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
    
    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static'
    );


	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static'
    );
	

    // tendina tipologia
	$ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view'
    );

    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static'
    );

    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view'
	);

    // tendina progetti
	$ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ '.
            'FROM progetti_view WHERE data_chiusura IS NULL ORDER BY __label__'
        );
	

    // tendina todo
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view WHERE id_progetto = ? AND ( data_chiusura IS NULL OR id = ? )', 
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ), 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ) 
            );
	} else {
	    $ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM todo_view'
        );
	}

    // tendina indirizzi
    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view'
    );

    // tendina mastri
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE se_conto = 1'
    );

    // tendina matricole
	$ct['etc']['select']['matricole'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM matricole_view'
    );

    // tendina matricole
	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM immobili_view'
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

    // tendina tipologia attivita
	$ct['etc']['id_tipologia_attivita_new'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );

	// tipologie di attività a seguire nelle procedure
	$attivitaSeguenti = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT * FROM metadati WHERE id_tipologia_attivita = ? AND nome LIKE ?',
		array(
			array( 's' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] : ( ( isset( $_REQUEST['__preset__']['attivita']['id_tipologia'] ) ) ? $_REQUEST['__preset__']['attivita']['id_tipologia'] : NULL ) ) ),
            array( 's' => '%procedure|attivita|seguenti|%' )
		)
	);

    // debug
    // print_r( $attivitaSeguenti );
    // print_r( metadata2associativeArray( $attivitaSeguenti ) );

    // attività seguenti
    $seguenti = metadata2associativeArray( $attivitaSeguenti );
    if( isset( $seguenti['procedure']['attivita']['seguenti'] ) ) {
        foreach( $seguenti['procedure']['attivita']['seguenti'] as $seg ) {
            $ct['etc']['procedure'][ $seg['id'] ] = array_merge(
                $seg,
                mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT * FROM tipologie_attivita_view WHERE id = ?',
                    array(
                        array( 's' => $seg['id'] )
                    )
                )
            );
        }
    }

    // debug
    // print_r( $ct['etc']['procedure'] );

/*
    // creo l'array delle attività seguenti
    foreach( $attivitaSeguenti as $att ) {
        $dettagli = explode( '|', $att );
        $ct['etc']['procedura']['attivita']['seguenti'][ $dettagli[3] ][ $dettagli[3] ]
#            'id' = 
#        );
    }
*/

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

 