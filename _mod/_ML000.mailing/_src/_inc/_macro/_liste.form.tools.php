<?php

    /**
     * strumenti della lista
     *
     * La popolazione della lista a partire da una categoria di anagrafica, con `_lista.popola.categoria.php`.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'liste';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    // popolazione lista
    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
        'modal' => array( 'id' => 'popola_lista', 'include' => 'inc/liste.form.tools.modal.popolazione.lista.twig' ),
        'icon' => NULL,
        'fa' => 'fa-cog',
        'title' => 'popola lista da categoria anagrafica',
        'text' => 'inserisce in lista le e-mail dei contatti di una data categoria'
    );

    // tendina categorie anagrafica
    $ct['etc']['select']['categorie_anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_anagrafica_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
