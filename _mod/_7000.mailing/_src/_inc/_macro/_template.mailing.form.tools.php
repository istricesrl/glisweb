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
	$ct['form']['table'] = 'template';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'azioni' => array(
        'label' => NULL
        )
    );
/*
    // duplica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'duplica', 'include' => 'inc/template.mail.form.tools.modal.duplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'duplica pagina',
	    'text' => 'duplica la pagina corrente'
	);
*/
    // pubblica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'pubblica', 'include' => 'inc/template.mail.form.tools.modal.pubblica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-cloud-upload',
	    'title' => 'pubblica template',
	    'text' => 'pubblica il template corrente'
	);

    // stages
    $ct['etc']['stages'] = array();

    foreach( array_keys( $cf['mysql']['profiles'] ) as $stage ) {
        if( $stage != SITE_STATUS ) {
            $ct['etc']['stages'][] = array( 'id' => $stage, '__label__' => $stage );
        }
    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
