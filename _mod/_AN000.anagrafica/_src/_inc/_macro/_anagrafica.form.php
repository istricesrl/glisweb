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
        'table' => 'anagrafica',
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

    // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_anagrafica'] = tendinaTipologieAnagrafica();

    // tendina sesso
	$ct['etc']['select']['sesso'] = tendinaSesso();

    // tendina notifiche
	$ct['etc']['select']['se_notifiche'] = tendinaSiNo();

    // tendina PEC
	$ct['etc']['select']['se_pec'] = tendinaSePec();

    // tendina categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = tendinaCategorieAnagrafica();

    // tendina tipologie telefoni
	$ct['etc']['select']['tipologie_telefoni'] = tendinaTipologieTelefoni();

    // tendina tipologie URL
	$ct['etc']['select']['tipologie_url'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_url_view'
	);

	// tendina ruoli indirizzi
	$ct['etc']['select']['ruoli_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_indirizzi_view'
	);

	// tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_indirizzi_view'
	);

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // macro di default per l'entità anagrafica
	require DIR_MOD . '_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

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
