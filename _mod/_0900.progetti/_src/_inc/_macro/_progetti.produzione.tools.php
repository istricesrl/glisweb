<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

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
            'url' => '/report/1200.todo/progetti.todo',
            'target' => '_blank',
            'icon' => NULL,
            'fa' => 'fa-file-text-o',
            'title' => 'report TXT attività progeto',
            'text' => 'report in formato TXT delle attività in corso per il progetto'
        );

    }

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
