<?php

    /**
     * macro form progetti produzione tools
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
	$ct['form']['table'] = 'progetti';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		    'label' => 'azioni'
        ),
	    'report' => array(
		    'label' => 'report'
	    )
	);

    // RELAZIONI CON IL MODULO TODO
    if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {

        $ct['page']['contents']['metro']['report'][] = array(
            'url' => '/report/1200.todo/progetti.todo?idProgetto='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'target' => '_blank',
            'icon' => NULL,
            'fa' => 'fa-file-text-o',
            'title' => 'report TXT cose da fare per il progetto',
            'text' => 'report in formato TXT delle cose da fare aperte per il progetto'
        );

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
