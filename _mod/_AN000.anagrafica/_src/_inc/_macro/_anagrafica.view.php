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
        'table' => 'anagrafica',
        'open' => array(
            'page' => 'anagrafica.form',
            'table' => 'anagrafica'
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            '__label__' => 'contatto',
            'nome' => 'nome',
            'cognome' => 'cognome',
            'denominazione' => 'denominazione',
            'telefoni' => 'telefoni',
            'mail' => 'mail',
            'categorie' => 'categorie',
            'id_stato' => 'ID stato',
            'id_provincia' => 'ID provincia',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'nome' => 'd-none',
            'cognome' => 'd-none',
            '__label__' => 'text-left no-wrap',
            'denominazione' => 'd-none',
            'telefoni' => 'text-left d-none d-md-table-cell',
            'mail' => 'text-left d-none d-md-table-cell',
            'id_stato' => 'd-none',
            'id_provincia' => 'd-none',
            'categorie' => 'text-left',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'data_archiviazione' => array( 'NL' => true )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
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

    // tendina categoria
	$ct['etc']['select']['categorie_anagrafica'] = tendinaCategorieAnagrafica();

    // tendina tipologie
    $ct['etc']['select']['tipologie_attivita'] = tendinaTipologieAttivita();

    // tendina stati
    $ct['etc']['select']['stati'] = tendinaStati();

    // tendina collaboratori
    $ct['etc']['select']['id_anagrafica_collaboratori'] = tendinaIdAnagraficaCollaboratori();

    // tendina anni
    $ct['etc']['select']['anni'] = tendinaAnni();

    // tendina settimane
    $ct['etc']['select']['settimane'] = tendinaSettimane();

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

/* TODO reimplementare
            if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
                $buttons .= '<a href="#" 
                    data-toggle="modal"
                    data-target="#scorciatoia_attivita"
                    onclick="$(\'#attivita_id_cliente\').val(\''.$row['id'].'\');$(\'#scorciatoia_attivita\').modal(\'show\');"><i class="fa fa-pencil-square-o"></i></a>';
            }

            if( in_array( "0200.attivita", $cf['mods']['active']['array'] ) ) {
                $buttons .= '<a href="#"
                    data-toggle="modal"
                    data-target="#scorciatoia_promemoria"
                    onclick="$(\'#attivita_id_cliente_promemoria\').val(\''.$row['id'].'\');$(\'#scorciatoia_promemoria\').modal(\'show\');"><i class="fa fa-calendar-plus-o"></i></a>';
            }

            if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {
                $buttons .= '<a href="#"
                    data-toggle="modal"
                    data-target="#scorciatoia_promemoria"
                    onclick="window.open(\''.$cf['contents']['pages']['corsi.view']['path'][ LINGUA_CORRENTE ].'?__work__[anagrafica][items][1][id]='.$row['id'].'&amp;__work__[anagrafica][items][1][label]='.$row['__label__'].'\',\'_self\');"><i class="fa fa-graduation-cap"></i></a>';
            }
*/
            $row[ NULL ] = $buttons;

        }

    }
