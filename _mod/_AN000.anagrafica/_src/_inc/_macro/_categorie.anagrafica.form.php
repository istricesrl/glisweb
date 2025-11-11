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
        'table' => 'categorie_anagrafica',
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

    // tendina categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = tendinaCategorieAnagrafica();

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
