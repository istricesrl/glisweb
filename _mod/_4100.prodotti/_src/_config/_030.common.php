<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

    $cf['prodotti']['pages']['elenco']['template']		= '_src/_templates/_default/';
    $cf['prodotti']['pages']['elenco']['schema']			= 'elenco.prodotti.html';
    $cf['prodotti']['pages']['elenco']['macro']			= array( '_mod/_4000.catalogo/_src/_inc/_macro/_prodotti.elenco.php' );

    $cf['prodotti']['pages']['scheda']['template']		= '_src/_templates/_default/';
    $cf['prodotti']['pages']['scheda']['schema']			= 'scheda.prodotti.html';
    $cf['prodotti']['pages']['scheda']['macro']			= array( '_mod/_4100.prodotti/_src/_inc/_macro/_prodotti.scheda.php' );

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'PREFX_PRODOTTI'					, 'PRODOTTI.' );
