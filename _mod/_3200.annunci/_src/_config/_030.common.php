<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

     // annunci
    $cf['annunci']['pages']['scheda']['template']       = '_src/_templates/_arianna/';
    $cf['annunci']['pages']['scheda']['schema']         = 'scheda.annunci.html';
    $cf['annunci']['pages']['scheda']['css']            = 'main.css';
    $cf['annunci']['pages']['scheda']['macro']          = array('_mod/_3200.annunci/_src/_inc/_macro/_annunci.scheda.php');
   
    // categorie
    $cf['annunci']['pages']['elenco']['template']        = '_src/_templates/_arianna/';
    $cf['annunci']['pages']['elenco']['schema']          = 'elenco.annunci.html';
    $cf['annunci']['pages']['elenco']['css']             = 'main.css';
    $cf['annunci']['pages']['elenco']['macro']           = array('_mod/_3200.annunci/_src/_inc/_macro/_annunci.elenco.php');
    
    // configurazione extra
    if ( isset( $cx['annunci'] ) ) {
        $cf['annunci'] = array_replace_recursive($cf['annunci'], $cx['annunci']);
    }
    
    // collegamento all'array $ct

    $ct['annunci']                    = &$cf['annunci'];

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'PREFX_CATEGORIE_ANNUNCI'					, 'CATEGORIE.ANNUNCI.' );
    define( 'PREFX_ANNUNCI'					            , 'ANNUNCI.' );
