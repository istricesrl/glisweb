<?php

    /**
     * macro form progetti
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
	$ct['form']['table'] = 'progetti';
    
    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1' );

    // tendina anagrafica per referenti e operatori (TODO vedere se filtrare sui referenti del cliente)
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 OR se_referente = 1' );

    if( isset( $_REQUEST[$ct['form']['table']]['id_cliente'] ) ){

        if( !empty( $_REQUEST[$ct['form']['table']]['id_indirizzo'] ) ){
            // tendina indirizzi
            $ct['etc']['select']['indirizzi'] = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT id, __label__ FROM indirizzi_view WHERE id = ?',
                array( array( 's' => $_REQUEST[$ct['form']['table']]['id_indirizzo'] ) )
            );
        }
        else{
            // tendina indirizzi
            $ct['etc']['select']['indirizzi'] = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT id_indirizzo AS id, indirizzo AS __label__ FROM anagrafica_indirizzi_view WHERE id_anagrafica = ?',
                array( array( 's' => $_REQUEST[$ct['form']['table']]['id_cliente'] ) )
            );
        }
        
    }

    // tendina tipologie progetti
	$ct['etc']['select']['tipologie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_progetti_view'
    );
    
    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_progetti_view'
    );
    
     // tendina funzioni
	$ct['etc']['select']['funzioni'] = array(
	    array( 'id' => NULL, '__label__' => 'titolare' ),
	    array( 'id' => 1, '__label__' => 'sostituto' )
	);

    // tendina mastri attivita
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view'
    );

    // tendina categorie progetti
	$ct['etc']['select']['categorie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view'
	);

    if ( isset( $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] ) )
    { 

        // riordino l'array dei ruoli mettendo prima i titolari
        foreach( $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] as $key => $value ) {
            $sort_data[ $key ] = $value['id_ruolo'] . ' ' . $value['se_sostituto'];
        }

        if( isset( $sort_data ) ){
            array_multisort( $sort_data, $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] );
        }

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
