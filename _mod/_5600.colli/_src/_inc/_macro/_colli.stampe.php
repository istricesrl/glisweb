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
	    '01.stampe' => array(
		    'label' => 'stampe'
        ),
	    '03.elaborazioni' => array(
		    'label' => 'elaborazioni'
	    )
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
	    'modal' => array( 'id' => 'crea_colli_stampa_etichette', 'include' => 'inc/colli.tools.modal.crea.e.stampa.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-clipboard',
	    'title' => 'crea colli e stampa etichette',
	    'text' => 'crea un insieme di colli e stampa le relative etichette'
	);

    $ct['etc']['select']['tipologie'] = mysqlQuery( 
        $cf['mysql']['connection'],
        'SELECT * FROM tipologie_colli_view',
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
