<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'colli';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.stampe' => array(
		    'label' => 'stampe'
        ),
	    '03.elaborazioni' => array(
		    'label' => 'elaborazioni'
	    )
	);

    $ct['page']['contents']['metro']['01.stampe'][] = array(
        'target' => '_blank' ,
        'url' => '/print/5600.colli/packing.collo.pdf?__collo__='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'stampa PDF packing list',
        'text' => 'stampa la packing list del collo in formato PDF'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
