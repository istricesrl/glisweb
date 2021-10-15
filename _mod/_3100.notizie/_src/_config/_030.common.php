<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

     // notizie
    $cf['notizie']['pages']['scheda']['template']       = '_src/_templates/_arianna/';
    $cf['notizie']['pages']['scheda']['schema']         = 'scheda.notizie.html';
    $cf['notizie']['pages']['scheda']['css']            = 'main.css';
    $cf['notizie']['pages']['scheda']['macro']          = array('_mod/_3100.notizie/_src/_inc/_macro/_notizie.scheda.php');
   
    // categorie
    $cf['notizie']['pages']['elenco']['template']        = '_src/_templates/_arianna/';
    $cf['notizie']['pages']['elenco']['schema']          = 'elenco.notizie.html';
    $cf['notizie']['pages']['elenco']['css']             = 'main.css';
    $cf['notizie']['pages']['elenco']['macro']           = array('_mod/_3100.notizie/_src/_inc/_macro/_notizie.elenco.php');
    
    // configurazione extra
    if ( isset( $cx['notizie'] ) ) {
        $cf['notizie'] = array_replace_recursive($cf['notizie'], $cx['notizie']);
    }
    
    // collegamento all'array $ct

    $ct['notizie']                    = &$cf['notizie'];

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'PREFX_CATEGORIE_NOTIZIE'					, 'CATEGORIE.NOTIZIE.' );
    define( 'PREFX_NOTIZIE'					            , 'NOTIZIE.' );
