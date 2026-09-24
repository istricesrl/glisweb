<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_prodotti';

 /**
     * gestione dati form associazione rapida
     * ======================================
     * 
     * 
     * 
     */

    // gestione link prodotto 
    if (isset($_REQUEST['__link_prodotto__']['id_prodotto'])) {

        // link anagrafica

        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO prodotti_categorie (id_prodotto, id_categoria, timestamp_inserimento )  VALUES (?, ?, ?)',
            array(
                array('s' => $_REQUEST['__link_prodotto__']['id_prodotto']),
                array('s' => $_REQUEST[$ct['form']['table']]['id']),
                array('s' => time())
            )
        );


    } elseif (isset($_REQUEST['__scollega_prodotto__'])) {

        // scollega anagrafica
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM prodotti_categorie WHERE id = ?',
            array(
                array('s' => $_REQUEST['__scollega_prodotto__'])
            )
        );

    }



    // informazioni della vista
    $ct['view'] = array(
        'table' => 'prodotti_categorie',
        'open' => array(
            'page' => 'catalogo.prodotti.form',
            'table' => 'prodotti',
            'field' => 'id_prodotto'
        ),
        'cols' => array(
            'id' => '#',
            'id_categoria' => 'ID categoria',
            'id_prodotto' => 'ID prodotto',
            'prodotto' => 'prodotto',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'id_categoria' => 'd-none',
            'id_prodotto' => 'd-none',
            'prodotto' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_categoria' => array('EQ' => $_REQUEST['categorie_prodotti']['id'] ?? NULL)
        ),
        '__sort__' => array(
            'prodotto' => 'ASC'
        ),
    );

    // tendina prodotti
    $ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM prodotti_view ORDER BY __label__'
    );

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/catalogo.categorie.prodotti.form.prodotti.link.twig',
        'fa' => 'fa-link'
    );


    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

       // elaborazione dati
    if (!empty($ct['view']['data'])) {
        foreach ($ct['view']['data'] as &$row) {

            $buttons = '';

            $buttons .=  '<a href="?categorie_prodotti[id]=' . $_REQUEST[$ct['form']['table']]['id'] . '&__scollega_prodotto__=' . $row['id'] . '"><span class="media-left"><i class="fa fa-chain-broken"></i></span></a>';

            $row[NULL] = $buttons;
        }
    }

