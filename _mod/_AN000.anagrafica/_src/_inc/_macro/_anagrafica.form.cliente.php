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

     // tendina crm
	$ct['etc']['select']['ranking'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ranking_view'
	);

	// tendina regimi fiscali
	$ct['etc']['select']['regimi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM regimi_view'
	);

	// tendina PEC
	$ct['etc']['select']['pec'] = mysqlQuery(
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1 ',
        array( array( 's' => $_REQUEST['anagrafica']['id'] ) )
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
