<?php
    /**
     * macro dashboard amministrazione
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // ID della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . 'produzione' . $_SESSION['__view__']['__site__']
	);

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '00.notifiche' => array(
			'label' => 'notifiche'
		),
        '10.scorciatoie' => array(
            'label' => 'azioni rapide'
        ),
        '20.andamento' => array(
            'label' => 'riepilogo progetti'
        )
	);

	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

        // andamento progetti
        $ct['page']['contents']['metro']['20.andamento'][] = array(
            'include' => 'inc/produzione.dashboard.html'
        );

    }
