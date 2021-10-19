<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


	// tabella gestita
    $ct['form']['table'] = 'contratti';
    
    // macro di default per l'entità contratti
    require '_contratti.form.default.php';

    // tendina per le tipologie inps
    if( isset( $_REQUEST['contratti']['id'] ) ) {
        $ct['etc']['select']['tipologie_inps'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM tipologie_attivita_inps_view' );
    }
    
    // tendina giorni
    $ct['etc']['select']['giorno'] = array( 
        array( 'id' => '1', '__label__' => 'lunedi' ),
        array( 'id' => '2', '__label__' => 'martedi' ),
        array( 'id' => '3', '__label__' => 'mercoledi' ),
        array( 'id' => '4', '__label__' => 'giovedi' ),
        array( 'id' => '5', '__label__' => 'venerdi' ),
        array( 'id' => '6', '__label__' => 'sabato' ),
        array( 'id' => '7', '__label__' => 'domenica' )
    );

    // tendina turni
	foreach( range( 1, 9 ) as $turno ) {
	    $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
	}

    if ( isset( $_REQUEST[ $ct['form']['table'] ]['fasce_orarie_contratti'] ) )
    { 
        // rimuovo le fasce orarie che non appartengono al turno corrente o che sono relativi alla disponibilità
        foreach( $_REQUEST[ $ct['form']['table'] ]['fasce_orarie_contratti'] as $k => $v ){
            if( $v['turno'] != $ct['page']['turno'] ){
                unset( $_REQUEST[ $ct['form']['table'] ]['fasce_orarie_contratti'][$k] );
            }
        }

        // riordino l'array degli orari in base a id_giorno e ora_inizio
        foreach( $_REQUEST[ $ct['form']['table'] ]['fasce_orarie_contratti'] as $key => $value ) {
            $sort_data[ $key ] = $value['id_giorno'] . ' ' . $value['ora_inizio'];
        }

        if( isset( $sort_data ) ){
            array_multisort( $sort_data, $_REQUEST[ $ct['form']['table'] ]['fasce_orarie_contratti'] );
        }

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
