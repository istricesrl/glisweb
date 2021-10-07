<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */


    $cf['catalogo']['pages']['elenco']['template']		= '_src/_templates/_athena/';
    $cf['catalogo']['pages']['elenco']['schema']			= 'default.html';
    $cf['catalogo']['pages']['elenco']['macro']			= array( '_mod/_4000.catalogo/_src/_inc/_macro/_categorie.prodotti.elenco.php' );

    $cf['catalogo']['pages']['scheda']['template']		= '_src/_templates/_default/';
    $cf['catalogo']['pages']['scheda']['schema']			= 'scheda.categorie.html';
    $cf['catalogo']['pages']['scheda']['macro']			= array( '_mod/_4000.catalogo/_src/_inc/_macro/_categorie.prodotti.scheda.php' );

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'PREFX_CATEGORIE_PRODOTTI'					, 'CATEGORIE.PRODOTTI.' );
