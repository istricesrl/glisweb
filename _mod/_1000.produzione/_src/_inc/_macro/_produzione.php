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

    // ...
	if( in_array( "1000.produzione", $cf['mods']['active']['array'] ) ) {

        // andamento progetti
        $ct['page']['contents']['metro']['20.andamento'][] = array(
            'include' => 'inc/produzione.dashboard.html'
        );

        // definisco la vista andamento progetti
        $ct['view'] = array(
            'table' => '__report_avanzamento_progetti__',
            'open' => array(
                'table' => 'progetti',
                'page' => 'progetti.produzione.form'
            ),
            'data' => array(
                '__report_mode__' => 1
            ),
            'cols' => array(
                'id' => '#',
                'nome' => 'titolo',
                'backlog' => 'da fare',
                'sprint' => 'in corso',
                'fatto' => 'fatte',
                'completed' => '%',
                'eta' => 'previsione'
            ),
            'class' => array(
                'nome' => 'text-left',
                'completed' => 'text-right'
            )
        );

	    // gestione default
	    require DIR_SRC_INC_MACRO . '_default.view.php';

        // debug
        // print_r( $ct['view'] );

        // TODO qui abbiamo una grande sfida... inserire view multiple nella stessa pagina!!!
        // si potrebbe sfruttare il fatto che ogni vista ha un suo ID? per esempio creare un array
        // $ct['views'] con sottochiave l'ID della vista e copiare lì il $ct['view'] di turno
        // prima di resettarlo?

    }
