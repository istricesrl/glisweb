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
    $ct['form']['table'] = 'menu';

    // tendina categorie notizie
    $ct['etc']['select']['categorie_notizie'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_notizie_view ORDER BY __label__ ASC'
    );

    // tendina comportamento dei menù
    $ct['etc']['select']['sottopagine'] = array(
        array( 'id' => 'SHOW_IF_ACTIVE', '__label__' => 'espandi sottovoci' ),
        array( 'id' => 'NEVER_SHOW', '__label__' => 'non mostrare sottovoci' ),
        array( 'id' => 'ALWAYS_SHOW', '__label__' => 'mostra sempre sottovoci' )
    );

    // tendina dei target
    $ct['etc']['select']['target'] = array( 
        array( 'id' => '_blank', '__label__' => 'apri in nuova scheda' )
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['tr']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
