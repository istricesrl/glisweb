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
	    '00.scorciatoie' => array(
			'label' => 'azioni rapide'
		),
        '20.andamento' => array(
            'label' => 'riepilogo progetti'
        )
	);

    // ...
	if( in_array( "1200.todo", $cf['mods']['active']['array'] ) ) {

        // esportazione contatti anagrafica
        $ct['page']['contents']['metro']['00.scorciatoie'][] = array(
            'modal' => array( 'id' => 'scorciatoia_todo', 'include' => 'inc/produzione.modal.todo.html' ),
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'aggiungi todo',
            'text' => 'inserisce rapidamente una todo nel backlog o nello sprint'
        );

    }

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

        // tendina tipologie
        $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_todo_view'
        );

        // tendina collaboratori
        $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static'
        );

        // gestione default
	    require DIR_SRC_INC_MACRO . '_default.tools.php';

	    // gestione default
	    require DIR_SRC_INC_MACRO . '_default.view.php';

        // debug
        // print_r( $ct['view'] );

        // TODO qui abbiamo una grande sfida... inserire view multiple nella stessa pagina!!!
        // si potrebbe sfruttare il fatto che ogni vista ha un suo ID? per esempio creare un array
        // $ct['views'] con sottochiave l'ID della vista e copiare lì il $ct['view'] di turno
        // prima di resettarlo?

    }
