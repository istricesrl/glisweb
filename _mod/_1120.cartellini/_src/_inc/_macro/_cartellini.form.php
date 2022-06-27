<?php

    /**
     * macro form cartellini
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
	$ct['form']['table'] = 'cartellini';
    
    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ){
        // tendina contratti
        $ct['etc']['select']['id_contratto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM contratti_completa_view WHERE id_anagrafica = ?',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) );
    }
    

    // tendina tipologia inps
	$ct['etc']['select']['id_tipologia_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view' );


    if ( isset( $_REQUEST[ $ct['form']['table'] ]['righe_cartellini'] ) )
    { 
        // riordino l'array delle righe in base al giorno
        foreach( $_REQUEST[ $ct['form']['table'] ]['righe_cartellini'] as $key => $value ) {
            $sort_data[ $key ] = $value['data_attivita'];
        }

        if( isset( $sort_data ) ){
            array_multisort( $sort_data, $_REQUEST[ $ct['form']['table'] ]['righe_cartellini'] );
        }

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
