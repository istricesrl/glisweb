<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo applicare la strategia della configurazione extra per sito anche ai vari slack, google, criteo, ecc.
     * @todo rimuovere quel brutto codice che fa il controllo della configurazione per sito nei vari slack, google, criteo, ecc.
     * @file
     *
     */

    // inizializzazione
	$cf['privacy']['cookie'] = array();

    // configurazione extra
	if( isset( $cx['privacy'] ) ) {
	    $cf['privacy'] = array_replace_recursive( $cf['privacy'], $cx['privacy'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['privacy'] ) ) {
	    $cf['privacy'] = array_replace_recursive( $cf['privacy'], $cf['site']['privacy'] );
	}

    // collegamento con l'array $ct
	$ct['privacy'] = &$cf['privacy'];

?>
