<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */
    
    $cf['risorse']['pages']['elenco']['template']          = '_src/_templates/_arianna/';
    $cf['risorse']['pages']['elenco']['schema']            = 'elenco.risorse.html';
    $cf['risorse']['pages']['elenco']['macro']             = array('_mod/_3500.risorse/_src/_inc/_macro/_categorie.risorse.elenco.php');
    
    $cf['risorse']['pages']['scheda']['template']          = '_src/_templates/_arianna/';
    $cf['risorse']['pages']['scheda']['schema']            = 'scheda.risorse.html';
    $cf['risorse']['pages']['scheda']['macro']             = array('_mod/_3500.risorse/_src/_inc/_macro/_categorie.risorse.scheda.php');
    $cf['risorse']['pages']['scheda']['css']               = 'main.css';

    // configurazione extra
    if( isset( $cx['risorse'] ) ) {
        $cf['risorse'] = array_replace_recursive( $cf['risorse'], $cx['risorse'] );
    }
    
    // collegamento all'array $ct
    $ct['risorse']                                         = &$cf['risorse'];
    
    // costanti che descrivono lo stato di funzionamento del framework
    define('PREFX_CATEGORIE_RISORSE', 'CATEGORIE.RISORSE.');

    define('PREFX_RISORSE', 'RISORSE.');
