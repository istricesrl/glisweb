<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'turni';

     // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 OR se_dipendente = 1 OR se_interinale = 1'
    );

    // tendina turni - leggo i turni del contratto attivo per l'anagrafica specficata
/*    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) {
        $tm = mysqlSelectValue( 
            $cf['mysql']['connection'],        
            'SELECT max(turno) from orari_contratti INNER JOIN contratti_view ON orari_contratti.id_contratto = contratti_view.id ' . 
            'WHERE contratti.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) )
        );

    #    echo $tm;

        foreach( range( 1, $tm ) as $turno ) {
            $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
        }
    }
*/
    // tendina contratti (vedere se inserirla)
    foreach( range( 1, 9 ) as $turno ) {
        $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
