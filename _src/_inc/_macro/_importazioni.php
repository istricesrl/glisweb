<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

	$base = '/task/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'anagrafica' => array(
		'label' => 'importazione anagrafica'
	    ),
	    'catalogo' => array(
		'label' => 'importazione catalogo'
	    )
	);


	if( in_array('4000.catalogo', $cf['mods']['active']['array']) ){


    // importazione articoli
	$ct['page']['contents']['metro']['catalogo'][0] = array(
		'url' => $cf['contents']['pages']['importazione_articoli']['url'][ $cf['localization']['language']['ietf'] ],
		'icon' => NULL,
		'fa' => 'fa-tags',
		'title' => 'importazione articoli',
		'text' => 'importa articoli da file XLS'
	    );

    // importazione prodotti
	    $ct['page']['contents']['metro']['catalogo'][1] = array(
		'url' => $cf['contents']['pages']['importazione_prodotti']['url'][ $cf['localization']['language']['ietf'] ],
		'icon' => NULL,
		'fa' => 'fa-archive',
		'title' => 'importazione prodotti',
		'text' => 'importa prodotti da file XLS'
	    );

    // importazione caratteristiche prodotti
	    $ct['page']['contents']['metro']['catalogo'][2] = array(
		'url' => $cf['contents']['pages']['importazione_prodotti_caratteristiche']['url'][ $cf['localization']['language']['ietf'] ],
		'icon' => NULL,
		'fa' => 'fa-file-text-o',
		'title' => 'importazione caratteristiche prodotti',
		'text' => 'importa le caratteristiche dei prodotti da file XLS'
	    );

	}


	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';