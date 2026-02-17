<?php

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */

     // notizie
    $cf['prodotti']['pages']['scheda']['template']          = '_src/_templates/_arianna/';
    $cf['prodotti']['pages']['scheda']['schema']            = 'scheda.prodotti.html';
    $cf['prodotti']['pages']['scheda']['css']               = 'main.css';
    // $cf['prodotti']['pages']['scheda']['macro']             = array('_mod/_3100.prodotti/_src/_inc/_macro/_prodotti.scheda.php');
   
    // categorie
    $cf['prodotti']['pages']['elenco']['template']          = '_src/_templates/_arianna/';
    $cf['prodotti']['pages']['elenco']['schema']            = 'elenco.prodotti.html';
    $cf['prodotti']['pages']['elenco']['css']               = 'main.css';
    // $cf['prodotti']['pages']['elenco']['macro']             = array('_mod/_3100.prodotti/_src/_inc/_macro/_prodotti.elenco.php');
    
    // costanti che descrivono lo stato di funzionamento del framework
    define( 'PREFX_CATEGORIE_PRODOTTI'					    , 'CATEGORIE.PRODOTTI.' );
    define( 'PREFX_PRODOTTI'					            , 'PRODOTTI.' );
