<?php

    /**
     * macro anagrafica view
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    /**
     * configurazione della view
     * =========================
     * 
     * 
     * TODO documentare
     * TODO fare una tabella con tutte le chiavi possibili spiegate
     * 
     * 
     */

    // informazioni della vista
	$ct['view'] = array(
        'table' => 'attivita',
        'open' => array(
            'page' => 'produzione.archivio.attivita.form',
            'table' => 'attivita'
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'tipologia' => 'tipologia',
            'data_riferimento' => 'data',
            'ora_inizio_riferimento' => 'inizio',
            'ora_fine_riferimento' => 'fine',
            'anagrafica_riferimento' => 'riferimento',
            'cliente' => 'cliente',
            'nome' => 'attività',
            'ore' => 'ore',
            '__label__' => 'attività',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'data_riferimento' => 'no-wrap',
            'anagrafica_riferimento' => 'no-wrap',
            'cliente' => 'no-wrap',
            'ora_inizio_riferimento' => 'no-wrap',
            'ora_fine_riferimento' => 'no-wrap',
            'nome' => 'no-wrap text-start',
            'tipologia' => 'no-wrap',
            'codice' => 'no-wrap',
            'ore' => 'no-wrap',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
// TODO implementare            'se_produzione' => array( 'NN' => true )
        ),
        '__sort__' => array(
            'data_riferimento' => 'DESC'
        ),
    );

    /**
     * configurazione della pagina
     * ===========================
     * 
     * 
     * 
     * 
     */

    // inclusione filtri speciali
// TODO reimplementare
//	$ct['etc']['include']['filters'] = 'inc/anagrafica.view.filters.html';

    // inclusione modal
    $ct['page']['contents']['modals']['metro'] = array(
// TODO reimplementare
//        array( 'schema' => 'inc/anagrafica.view.modal.attivita.html' ),
//        array( 'schema' => 'inc/anagrafica.view.modal.promemoria.html' )
    );

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     */

//    // tendina categoria
//	$ct['etc']['select']['categorie_anagrafica'] = tendinaCategorieAnagrafica();
//
//    // tendina tipologie
//    $ct['etc']['select']['tipologie_attivita'] = tendinaTipologieAttivita();
//
//    // tendina stati
//    $ct['etc']['select']['stati'] = tendinaStati();
//
//    // tendina collaboratori
//    $ct['etc']['select']['id_anagrafica_collaboratori'] = tendinaIdAnagraficaCollaboratori();
//
//    // tendina anni
//    $ct['etc']['select']['anni'] = tendinaAnni();
//
//    // tendina settimane
//    $ct['etc']['select']['settimane'] = tendinaSettimane();

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    /**
     * elaborazione risultati della vista
     * ==================================
     * 
     * 
     * 
     */

    // tendina provincie
    $ct['etc']['select']['provincie'] = tendinaProvincie( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_stato']['EQ'] ?? 1 );

    // elaborazione righe
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            $onclickBookmark = "$(this).metroWs('/api/bookmarks?".
                "__work__[anagrafica][items][".$row['id']."][id]=".$row['id'].
                "&__work__[anagrafica][items][".$row['id']."][label]=".$row['__label__']."', aggiornaBookmarks );";

            $buttons = '<a href="#" onclick="'.$onclickBookmark.'">'.
                '<span class="media-left"><i class="fa fa-bookmark'.( ( isset( $cf['session']['__work__']['anagrafica']['items'][ $row['id'] ] ) ) ? NULL : '-o' ).'"></i></span></a>';

            $row[ NULL ] = $buttons;

        }

    }
