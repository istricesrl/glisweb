<?php

    /**
     * file di esempio per la funzione cacheRead()
     *
     * l'albero delle pagine scritto da _330.pages.php si rilegge dalla cache, con il motore della richiesta
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // l'albero in cache e' quello della richiesta
    $pagine = cacheRead( CONTENTS_PAGES_KEY );
    var_dump( is_array( $pagine ) && count( $pagine ) == count( $cf['contents']['pages'] ) );
