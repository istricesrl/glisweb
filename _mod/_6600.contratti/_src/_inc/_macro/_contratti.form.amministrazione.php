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
    $ct['form']['table'] = 'contratti';

     // tendina articoli
	$ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
    );

    // tendina mastri
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view'
    );
    
    // tendina per le tipologie di attività inps
    $ct['etc']['select']['tipologie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_attivita_view'
    );


    if( isset( $_REQUEST['contratti']['id'] ) ){
        $ct['etc']['monte_ore'] = mysqlSelectRow($cf['mysql']['connection'],
        'SELECT id, testo FROM metadati WHERE id_contratto = ? AND nome = "monte_ore"',
        array( array( 's' => $_REQUEST['contratti']['id'] ) ));
    
        $ct['etc']['meta_maggiorazione'] = mysqlSelectRow($cf['mysql']['connection'],
        'SELECT id, testo FROM metadati WHERE id_contratto = ? AND nome = "maggiorazione_ore_extra"',
        array( array( 's' => $_REQUEST['contratti']['id'] ) ));


        $ct['etc']['meta_sconto'] = mysqlSelectRow($cf['mysql']['connection'],
        'SELECT id, testo FROM metadati WHERE id_contratto = ? AND nome = "sconto_ore_mancanti"',
        array( array( 's' => $_REQUEST['contratti']['id'] ) ));
            
        // tendina cron
        $ct['etc']['select']['cron'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, nome AS __label__ FROM cron_view WHERE id_contratto = ?',
            array( array( 's' => $_REQUEST['contratti']['id'] ) )
        );
    }



    // macro di default per l'entità contratti
	require '_contratti.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
