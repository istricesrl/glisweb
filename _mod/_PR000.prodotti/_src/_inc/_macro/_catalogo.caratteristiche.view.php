<?php

    /**
     * macro della vista caratteristiche
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
        'table' => 'caratteristiche',
        'open' => array(
            'page' => 'catalogo.caratteristiche.form',
            'table' => 'caratteristiche'
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            '__label__' => 'caratteristica',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'codice' => 'no-wrap',
            '__label__' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
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

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/catalogo.caratteristiche.view.filters.twig';

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     */

    // tendina dei genitori: solo quelli che hanno figli, gli unici per cui il filtro ha senso
    $ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT DISTINCT g.id, g.__label__ FROM caratteristiche_view AS g INNER JOIN caratteristiche AS f ON f.id_genitore = g.id ORDER BY g.__label__'
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

    /**
     * elaborazione risultati della vista
     * ==================================
     * 
     * 
     * 
     */

    // elaborazione righe
    foreach ($ct['view']['data'] as &$row) {
        if (is_array($row)) {

            $buttons = [];

            $row[NULL] = implode($buttons);

        }
    }
