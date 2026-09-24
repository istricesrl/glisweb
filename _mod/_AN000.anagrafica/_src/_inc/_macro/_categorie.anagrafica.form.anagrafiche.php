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
        'table' => 'categorie_anagrafica',
    );

    /**
     * gestione dati form associazione rapida
     * ======================================
     * 
     * 
     * 
     */

    // gestione link anagrafica categorie_anagrafica
    if (isset($_REQUEST['__link_anagrafica__']['id_anagrafica'])) {

        // link anagrafica

        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO anagrafica_categorie (id_anagrafica, id_categoria, timestamp_inserimento )  VALUES (?, ?, ?)',
            array(
                array('s' => $_REQUEST['__link_anagrafica__']['id_anagrafica']),
                array('s' => $_REQUEST[$ct['form']['table']]['id']),
                array('s' => time())
            )
        );


        updateAnagraficaViewStatic($_REQUEST['__link_anagrafica__']['id_anagrafica']);
    } elseif (isset($_REQUEST['__scollega_anagrafica__'])) {

        // scollega anagrafica
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM anagrafica_categorie WHERE id = ?',
            array(
                array('s' => $_REQUEST['__scollega_anagrafica__'])
            )
        );

        updateAnagraficaViewStatic($_REQUEST['__scollega_anagrafica__']);
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
        'table' => 'anagrafica_categorie',
        'open' => array(
            'page' => 'anagrafica.form',
            'table' => 'anagrafica',
            'field' => 'id_anagrafica'
        ),
        'cols' => array(
            'id' => '#',
            'id_anagrafica' => 'ID anagrafica',
            'id_categoria' => 'ID categoria',
            'anagrafica' => 'anagrafica',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'id_anagrafica' => 'd-none',
            'id_categoria' => 'd-none',
            'anagrafica' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_categoria' => array('EQ' => $_REQUEST['categorie_anagrafica']['id'] ?? NULL)
        ),
        '__sort__' => array(
            'anagrafica' => 'ASC'
        ),
    );

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/categorie.anagrafica.form.anagrafiche.link.twig',
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
    if (!empty($ct['view']['data'])) {
        foreach ($ct['view']['data'] as &$row) {

            $buttons = '';

            $buttons .=  '<a href="?categorie_anagrafica[id]=' . $_REQUEST[$ct['form']['table']]['id'] . '&__scollega_anagrafica__=' . $row['id'] . '"><span class="media-left"><i class="fa fa-chain-broken"></i></span></a>';

            $row[NULL] = $buttons;
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
