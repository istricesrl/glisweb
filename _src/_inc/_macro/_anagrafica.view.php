<?php

    /**
     *
     *
     *
     *
     *
     *
     * -# dichiarazione tabella della vista
     * -# dichiarazione della pagina di apertura
     * -# dichiarazione delle colonne della vista
     * -# dichiarazione delle classi delle colonne
     * -# aggiunta delle colonne variabili
     * -# inclusione dei filtri speciali
     * -# popolazione tendine
     * -# trasformazioni
     * -# macro di default
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

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = 'anagrafica_attivi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'anagrafica.form';
	$ct['view']['open']['table'] = 'anagrafica';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail',
	    'categorie' => 'categorie',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left no-wrap',
	    'telefoni' => 'text-left d-none d-md-table-cell',
	    'mail' => 'text-left d-none d-md-table-cell',
	    'categorie' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // colonne variabili
    /*
	if( isset( $_SESSION['account']['se_commerciale'] ) && ! empty( $_SESSION['account']['se_commerciale'] ) ) {
	    arrayInsertAssoc( '__label__', $ct['view']['cols'], array( 'provincia' => 'provincia' ) );
	    arrayInsertAssoc( '__label__', $ct['view']['class'], array( 'provincia' => 'text-left' ) );
	    $ct['view']['cols']['agente'] = 'agente';
	    $ct['view']['class']['agente'] = 'text-left';
	}
    */

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/anagrafica.view.filters.html';

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/anagrafica.view.modal.attivita.html'
    );

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/anagrafica.view.modal.promemoria.html'
    );

    // tendina categoria
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // tendina tipologie
    $ct['etc']['select']['tipologie_attivita'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL'
    );

    // tendina collaboratori
    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static'
    );

    // tendina anni
    foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
        $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
    }

    // tendina settimane
    foreach( range( 1, 52 ) as $w ) {
        $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // bottoni
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {
/*
            if( ! isset( $cf['session']['__work__']['anagrafica']['items'] ) || ! array_key_exists( $row['id'], $cf['session']['__work__']['anagrafica']['items'] ) ) {
                $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/bookmark.add?__work__[anagrafica][items]['.$row['id'].'][id]='.$row['id'].'&__work__[anagrafica][items]['.$row['id'].'][label]='.$row['__label__'].'\', aggiornaBookmarks );"><span class="media-left"><i class="fa fa-bookmark-o"></i></span></a>';
            } else {
                $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/bookmark.del?__key__=anagrafica&__item__='.$row['id'].'\', aggiornaBookmarks );"><span class="media-left"><i class="fa fa-bookmark"></i></span></a>';
            }
*/

            $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/api/bookmarks?__work__[anagrafica][items]['.$row['id'].'][id]='.$row['id'].'&__work__[anagrafica][items]['.$row['id'].'][label]='.$row['__label__'].'\', aggiornaBookmarks );"><span class="media-left"><i class="fa fa-bookmark'.( ( isset( $cf['session']['__work__']['anagrafica']['items'][ $row['id'] ] ) ) ? NULL : '-o' ).'"></i></span></a>'.
                '<a href="#" data-toggle="modal" data-target="#scorciatoia_attivita" onclick="$(\'#attivita_id_cliente\').val(\''.$row['id'].'\');$(\'#scorciatoia_attivita\').modal(\'show\');"><i class="fa fa-pencil-square-o"></i></a>'.
                '<a href="#" data-toggle="modal" data-target="#scorciatoia_promemoria" onclick="$(\'#attivita_id_cliente_promemoria\').val(\''.$row['id'].'\');$(\'#scorciatoia_promemoria\').modal(\'show\');"><i class="fa fa-calendar-plus-o"></i></a>';


        }
	}
