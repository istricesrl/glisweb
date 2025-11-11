<?php

    /**
     * macro form anagrafica
     *
     *
     * TODO documentare
     *
     */

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form'] = array(
        'table' => 'telefoni',
    );

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     * 
     */

    // tendina tipologie telefoni
	$ct['etc']['select']['tipologie_telefoni'] = tendinaTipologieTelefoni();

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

	// macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    /**
     * debug del form
     * ==============
     * 
     * 
     * 
     */

    // debug
	// print_r( $_REQUEST );
