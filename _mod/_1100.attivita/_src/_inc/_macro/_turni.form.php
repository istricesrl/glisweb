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

    // tendina turni (parto dal 2 perché registriamo solo i turni diversi dall'1)
	foreach( range( 2, 9 ) as $turno ) {
	    $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
	}


    // tendina contratti (vedere se inserirla)
      

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
