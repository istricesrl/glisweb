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
    $ct['view']['table'] = 'documenti';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'tipologia' => 'tipologia',
        'numero' => 'numero',
        '__label__' => 'nome',
        'cliente' => 'cliente',
        'emittente' => 'emittente',
        'totale' => 'totale',
         'coupon' => 'coupon',
         'pagamento' => 'pagamento'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'numero' => 'text-left',
        'data' => 'text-left',
        '__label__' => 'text-left',
        'cliente' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right',
        'coupon' => 'd-none' 
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/documenti.view.filters.html';

    // tendina categoria
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

     // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_azienda_gestita = 1'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
	    if( ! empty( $row['coupon'] ) ) { 
            $row['documenti_articoli'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli WHERE id_documento = ? ', array( array( 's' => $row['id'] ) ) );

            $row['totale'] -= calcolaCoupon( $cf['mysql']['connection'], array(),   $row );
            $row['totale'] = number_format($row['totale'], 2 ); 
        };

        if( ! empty( $row['pagamento'] ) ){
            $row['pagamento'] =  str_replace("1", '<i class="fa fa-money"></i>',  $row['pagamento']);
            $row['pagamento'] =  str_replace("5", '<i class="fa fa-credit-card"></i>',  $row['pagamento']);
        }
	}
