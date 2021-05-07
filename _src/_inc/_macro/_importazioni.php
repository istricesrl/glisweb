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




    // importazione prodotti
	    $ct['page']['contents']['metro']['catalogo'][] = array(
			'url' => $cf['contents']['pages']['importazione.prodotti']['url'][ $cf['localization']['language']['ietf'] ],
			'icon' => NULL,
			'fa' => 'fa-archive',
			'title' => 'importazione prodotti',
			'text' => 'importa prodotti da file XLS'
	    );

	// importazione articoli
		$ct['page']['contents']['metro']['catalogo'][] = array(
			'url' => $cf['contents']['pages']['importazione.articoli']['url'][ $cf['localization']['language']['ietf'] ],
			'icon' => NULL,
			'fa' => 'fa-tags',
			'title' => 'importazione articoli',
			'text' => 'importa articoli da file XLS'
			);

	// importazione prezzi articoli
	    $ct['page']['contents']['metro']['catalogo'][] = array(
			'url' => $cf['contents']['pages']['importazione.prezzi.articoli']['url'][ $cf['localization']['language']['ietf'] ],
			'icon' => NULL,
			'fa' => 'fa-usd',
			'title' => 'importazione prezzi articoli',
			'text' => 'importa i prezzi degli articoli da file XLS'
	    );	

    // importazione caratteristiche prodotti
	    $ct['page']['contents']['metro']['catalogo'][] = array(
			'url' => $cf['contents']['pages']['importazione.prodotti.caratteristiche']['url'][ $cf['localization']['language']['ietf'] ],
			'icon' => NULL,
			'fa' => 'fa-file-text-o',
			'title' => 'importazione caratteristiche prodotti',
			'text' => 'importa le caratteristiche dei prodotti da file XLS'
	    );

	}


	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';