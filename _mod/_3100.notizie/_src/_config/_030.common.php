<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */
    $cf['notizie']['pages']['scheda']['template']        = '_src/_templates/_arianna/';
    $cf['notizie']['pages']['scheda']['schema']            = 'scheda.notizie.html';
    $cf['notizie']['pages']['scheda']['css']            = 'main.css';

    $cf['categorie.notizie']['pages']['scheda']['template']        = '_src/_templates/_arianna/';
    $cf['categorie.notizie']['pages']['scheda']['schema']            = 'scheda.categorie.notizie.html';
    $cf['categorie.notizie']['pages']['scheda']['css']            = 'main.css';
    //$cf['notizie']['pages']['scheda']['macro']            = array('_mod/_3100.notizie/_src/_inc/_macro/_prodotti.scheda.php');
    
    // configurazione extra
    if (isset($cx['notizie'])) {
        $cf['notizie'] = array_replace_recursive($cf['notizie'], $cx['notizie']);
    }
    
    if (isset($cx['categorie.notizie'])) {
        $cf['categorie.notizie'] = array_replace_recursive($cf['categorie.notizie'], $cx['categorie.notizie']);
    }
    
    // collegamento all'array $ct
    $ct['categorie.notizie']          = &$cf['categorie.notizie'];
    $ct['notizie']                    = &$cf['notizie'];

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'PREFX_CATEGORIE_NOTIZIE'					, 'CATEGORIE.NOTIZIE.' );
    define( 'PREFX_NOTIZIE'					            , 'NOTIZIE.' );
