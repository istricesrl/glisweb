<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

    $cf['progetti']['pages']['elenco']['template']          = '_src/_templates/_arianna/';
    $cf['progetti']['pages']['elenco']['schema']            = 'elenco.categorie.html';
    $cf['progetti']['pages']['elenco']['macro']             = array('_mod/_0900.progetti/_src/_inc/_macro/_categorie.progetti.elenco.php');
    
    $cf['progetti']['pages']['scheda']['template']          = '_src/_templates/_arianna/';
    $cf['progetti']['pages']['scheda']['schema']            = 'scheda.categorie.html';
    $cf['progetti']['pages']['scheda']['macro']             = array('_mod/_0900.progetti/_src/_inc/_macro/_categorie.progetti.scheda.php');
    
    // configurazione extra
    if( isset( $cx['catalogo'] ) ) {
        $cf['catalogo'] = array_replace_recursive( $cf['catalogo'], $cx['catalogo'] );
    }
    
    // collegamento all'array $ct
    $ct['catalogo']                                         = &$cf['catalogo'];
    
    // costanti che descrivono lo stato di funzionamento del framework
    define('PREFX_CATEGORIE_PROGETTI', 'CATEGORIE.PROGETTI.');
    