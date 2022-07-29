<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

    $cf['prodotti']['pages']['scheda']['template']        = '_src/_templates/_lydia/';
    $cf['prodotti']['pages']['scheda']['schema']            = 'scheda.prodotto.html';
    $cf['prodotti']['pages']['scheda']['css']            = 'main.css';
    $cf['prodotti']['pages']['scheda']['macro']            = array('_mod/_4100.prodotti/_src/_inc/_macro/_prodotti.scheda.php');
    
    // configurazione extra
    if (isset($cx['prodotti'])) {
        $cf['prodotti'] = array_replace_recursive($cf['prodotti'], $cx['prodotti']);
    }
    
    // collegamento all'array $ct
    $ct['prodotti']                    = &$cf['prodotti'];
    
    // costanti che descrivono lo stato di funzionamento del framework
    define('PREFX_PRODOTTI', 'PRODOTTI.');
    