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

      // importazione prodotti
	$ct['page']['contents']['metro']['general'][0] = array(
	'url' => $cf['contents']['pages']['importazione_prodotti']['url'][ $cf['localization']['language']['ietf'] ],
	'icon' => NULL,
	'fa' => 'fa-archive',
	'title' => 'importazione prodotti',
	'text' => 'importa prodotti da file XLS'
	);