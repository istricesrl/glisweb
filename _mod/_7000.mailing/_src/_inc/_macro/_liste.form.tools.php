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
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'liste';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		),
	    '05.static' => array(
			'label' => 'viste statiche'
		)
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
	    'modal' => array( 'id' => 'popola_lista', 'include' => 'inc/liste.form.tools.modal.popolazione.lista.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-cog',
	    'title' => 'popola lista da categoria anagrafica',
	    'text' => 'inserisce in lista le e-mail dei contatti di una data categoria'
	);

    // categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
