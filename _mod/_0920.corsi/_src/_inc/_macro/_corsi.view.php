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
	// $ct['view']['table'] = 'corsi';
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_corsi__';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'corsi.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        'nome' => 'nome',
        'fasce' => 'fasce',
        'discipline' => 'discipline',
        'livelli' => 'livelli',
        'giorni_orari_luoghi' => 'luoghi e orari',
//        'luoghi' => 'luoghi',
        'posti_disponibili' => 'posti',
        'stato' => 'stato',
        '__label__' => 'corso',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'cliente' => 'text-left d-none d-md-table-cell',
        'stato' => 'd-none',
        'tipologia' => 'text-left',
        'nome' => 'text-left',
        'categorie' => 'text-left',
        'discipline' => 'text-left',
        'livelli' => 'text-left',
        'giorni_orari_luoghi' => 'text-left nowrap',
        'stato' => 'text-left',
        '__label__' => 'd-none',
        NULL => 'nowrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // tendina categorie progetti
	$ct['etc']['select']['discipline'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1 ORDER BY __label__'
	);

	$ct['etc']['select']['classi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_classe = 1 ORDER BY __label__'
	);

	$ct['etc']['select']['fasce'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_fascia = 1 ORDER BY __label__'
	);

    $ct['etc']['select']['stati'] = array(
        array( 'id' => 'attivo', '__label__' => 'attivo'),
        array( 'id' => 'concluso', '__label__' => 'concluso'),
        array( 'id' => 'futuro', '__label__' => 'futuro'),
    );

    $ct['etc']['include']['filters'] = 'inc/corsi.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // bottoni
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            if( ! isset( $cf['session']['__work__']['corsi']['items'] ) || ! array_key_exists( $row['id'], $cf['session']['__work__']['corsi']['items'] ) ) {
                $var1 = "__work__[corsi][items][" . $row['id'] . "][id]=" . $row['id'];
                $onclick = "$(this).metroWs('/task/bookmark.add?" . $var1 . "&__work__[corsi][items][" . $row['id'] . "][label]=" . $row['__label__'] . "', aggiornaBookmarks );";
                $row[ NULL ] =  '<a href="#" onclick="'.$onclick.'"><span class="media-left"><i class="fa fa-bookmark-o"></i></span></a>';
            } else {
                $onclick = "$(this).metroWs('/task/bookmark.del?__key__=corsi&__item__=".$row['id']."', aggiornaBookmarks );";
                $row[ NULL ] =  '<a href="#" onclick="'.$onclick.'"><span class="media-left"><i class="fa fa-bookmark"></i></span></a>';
            }

            $row[ NULL ] .=  '<a href="'.$cf['contents']['pages']['corsi.form']['path'][LINGUA_CORRENTE].'?__preset__[contratti][id_progetto]='.$row['id'].'"><span class="media-left"><i class="fa fa-graduation-cap"></i></span></a>';

            // TODO solo se è attivo il modulo attesa
            if( isset( $cf['contents']['pages']['attesa.form']['path'][LINGUA_CORRENTE] ) ) {
                $row[ NULL ] .= '<a href="'.$cf['contents']['pages']['attesa.form']['path'][LINGUA_CORRENTE].'?__preset__[contratti][id_progetto]='.$row['id'].'"><span class="media-left"><i class="fa fa-hourglass-half"></i></span></a>';
            }

            $row['giorni_orari_luoghi'] = str_replace( '|', '<br>', $row['giorni_orari_luoghi'] );

        }
	}
