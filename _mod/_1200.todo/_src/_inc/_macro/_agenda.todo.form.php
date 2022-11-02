<?php

    /**
     * macro form todo
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
	$ct['form']['table'] = 'todo';
/*
    // tendina priorita
	$ct['etc']['select']['id_priorita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM priorita_view' );
*/
    // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_todo_view' );
    
    // tendina collaboratori
	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );
	
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
        'SELECT id, __label__ FROM progetti_view' );

    // tendina immobili
	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM immobili_view' );


    // tendina mastri attivita
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE se_conto = 1'
    );

     // tendina anni
	foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
	    $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
	}

    // tendina settimane
	foreach( range( 1, 52 ) as $w ) {
	    $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
	}

    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );

    // settaggio di cliente, indirizzo, mastro attivita letti dal progetto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ){
        $ct['etc']['id_cliente'] = mysqlSelectValue(
                 $cf['mysql']['connection'],
                'SELECT id_cliente FROM progetti WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
            );

        $ct['etc']['id_indirizzo'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_indirizzo FROM progetti WHERE id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
        );
       
    }

    // preset di id_mastro_attivita_default
    if( isset( $_REQUEST['__preset__']['todo']['id_progetto']  ) ){

        $ct['etc']['id_mastro_attivita_default'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_mastro_attivita_default FROM progetti WHERE id = ?',
            array( array( 's' => $_REQUEST['__preset__']['todo']['id_progetto'] ) )
        );
    }

    // ricerca tipologie attività collegate alla tipologia todo per la creazione delle shortcut
    $ct['etc']['id_tipologia_attivita'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT tipologie_attivita_view.id, tipologie_attivita_view.nome FROM metadati LEFT JOIN tipologie_attivita_view ON tipologie_attivita_view.id = metadati.testo '.
        'WHERE metadati.id_tipologia_todo = ? AND metadati.nome LIKE "procedure|todo|attivita|avviabili|%"',
        array( array( 's' => (
            ( 
                isset( $_REQUEST['__preset__']['todo']['id_tipologia'] ) )
                ? $_REQUEST['__preset__']['todo']['id_tipologia']
                : ( ( isset( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) )
                    ? $_REQUEST[ $ct['form']['table'] ]['id_tipologia']
                    : NULL 
                ) ) )
            )
    );

    // debug
    // print_r( $ct['etc']['id_tipologia_attivita'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
