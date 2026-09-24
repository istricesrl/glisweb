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

    /**
     * la scheda pubblica di un ARTICOLO
     *
     * Gemella di quella del prodotto. Serve al modello a tre tipologie ( macchina base, opzione,
     * macchina configurata ), dove a essere pubblicata non e' piu' la scheda del prodotto ma quella
     * di uno dei suoi articoli.
     *
     * Template e schema NON sono dichiarati qui a caso: un articolo non ha le colonne template,
     * schema_html e tema_css, che sono solo sui prodotti. La pagina di un articolo usa quindi
     * quelle del SUO PRODOTTO, e questi valori sono l'ultimo ripiego, gli stessi della scheda
     * prodotto perche' il modello Twig e' lo stesso: cambia la macro, che riempie gli stessi dati
     * pescando prima dall'articolo e poi, dove non trova niente, dal prodotto.
     */
    $cf['prodotti']['pages']['articolo']['template']        = '_src/_templates/_lydia/';
    $cf['prodotti']['pages']['articolo']['schema']          = 'scheda.prodotto.html';
    $cf['prodotti']['pages']['articolo']['css']             = 'main.css';
    $cf['prodotti']['pages']['articolo']['macro']           = array('_mod/_4100.prodotti/_src/_inc/_macro/_articoli.scheda.php');
    
    // configurazione extra
    if (isset($cx['prodotti'])) {
        $cf['prodotti'] = array_replace_recursive($cf['prodotti'], $cx['prodotti']);
    }
    
    // collegamento all'array $ct
    $ct['prodotti']                    = &$cf['prodotti'];
    
    // costanti che descrivono lo stato di funzionamento del framework
    define('PREFX_PRODOTTI', 'PRODOTTI.');
    define('PREFX_ARTICOLI', 'ARTICOLI.');
    