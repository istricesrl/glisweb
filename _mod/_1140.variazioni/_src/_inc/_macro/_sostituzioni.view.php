<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */


    // tabella della vista
    $ct['view']['table'] = 'sostituzioni_attivita';
    
    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );


    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id_anagrafica as id, anagrafica as __label__ FROM sostituzioni_attivita_view'
    );

    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && !empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) ) 
	{
        $ct['etc']['sostituzioni'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM sostituzioni_attivita_view WHERE id_anagrafica = ? AND data_accettazione IS NULL AND data_rifiuto IS NULL',
            array(
                array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
            )
        );

    }

    
    // macro di default
#	require DIR_SRC_INC_MACRO . '_default.view.php';

   