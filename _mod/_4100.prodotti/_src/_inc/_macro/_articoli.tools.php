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
	    )
	);

    $ct['page']['contents']['metro']['general'][0] = array(
		'url' => $cf['contents']['pages']['importazione_articoli']['url'][ $cf['localization']['language']['ietf'] ],
		'icon' => NULL,
		'fa' => 'fa-tags',
		'title' => 'importazione articoli',
		'text' => 'importa articoli da file XLS'
	    );