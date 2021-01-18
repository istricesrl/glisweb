<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'turni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'turni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'contratto' => 'contratto',
        'turno' => 'turno',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'text-left',
        'contratto' => 'text-left',
        'turno' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
    );
    
    // tendina contratti
    $ct['etc']['select']['contratti'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM contratti_view'
    );

    // tendina turni
    foreach( range( 1, 9 ) as $turno ) {
        $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
    }

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/turni.view.filters.html';

    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
