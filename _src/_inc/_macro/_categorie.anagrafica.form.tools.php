<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'categorie_anagrafica';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'esportazioni' => array(
        'label' => 'esportazioni'
        )
    );

    // esportazione contatti anagrafica
    $ct['page']['contents']['metro']['esportazioni'][] = array(
        'url' => '/print/anagrafica.csv?__categoria__='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione CSV per MailChimp',
        'text' => 'esporta i contatti di questa categoria per l\'importazione in MailChimp'
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
