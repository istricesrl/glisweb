<?php

    /**
     * macro form anagrafica
     *
     *
     * TODO documentare
     *
     */

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form'] = array(
        'table' => 'tipologie_anagrafica',
    );

    // gestione link anagrafica ranking
    if( isset( $_REQUEST['__link_anagrafica__']['id_anagrafica'] ) ) {

        // link anagrafica
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica SET id_tipologia = ? WHERE id = ?',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__link_anagrafica__']['id_anagrafica'] )
            )
        );

        updateAnagraficaViewStatic( $_REQUEST['__link_anagrafica__']['id_anagrafica'] );

    } elseif( isset( $_REQUEST['__scollega_anagrafica__'] ) ) {

        // scollega anagrafica
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica SET id_tipologia = NULL WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__scollega_anagrafica__'] )
            )
        );

        updateAnagraficaViewStatic( $_REQUEST['__scollega_anagrafica__'] );

    }

    /**
     * dati della view
     * ===============
     * 
     * 
     * 
     * 
     * 
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'anagrafica',
        'open' => array(
            'page' => 'anagrafica.form',
            'table' => 'anagrafica',
            'field' => 'id'
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'anagrafica',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            '__label__' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_tipologia' => array( 'EQ' => $_REQUEST['tipologie_anagrafica']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/anagrafica.archivio.tipologie.anagrafica.form.anagrafiche.link.twig',
        'fa' => 'fa-link'
    );


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

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // elaborazione dati
    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ) {

            $buttons = '';

            $buttons .=  '<a href="?tipologie_anagrafica[id]='.$_REQUEST[ $ct['form']['table'] ]['id'].'&__scollega_anagrafica__='.$row['id'].'"><span class="media-left"><i class="fa fa-chain-broken"></i></span></a>';

            $row[ NULL ] = $buttons;

        }
	}

    /**
     * debug del form
     * ==============
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
