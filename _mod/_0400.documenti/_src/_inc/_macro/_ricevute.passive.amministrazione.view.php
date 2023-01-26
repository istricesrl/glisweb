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
	$ct['view']['table'] = 'ricevute_passive';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'ricevute.passive.amministrazione.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
        'emittente' => 'fornitore',
#        'destinatario' => 'destinatario',
        '__label__' => 'nome',
        'timestamp_chiusura' => 'stato'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
        'numero' => 'text-left',
        'data' => 'no-wrap', 
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_fornitore = 1 ORDER BY __label__'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/ricevute.passive.amministrazione.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( isset($ct['view']['data']) ){
        foreach( $ct['view']['data'] as &$row ) {
            if($row['timestamp_chiusura']>0 ){
                $row['timestamp_chiusura'] = '<i class="fa fa-check" aria-hidden="true"></i>';
            }
        }
    }
