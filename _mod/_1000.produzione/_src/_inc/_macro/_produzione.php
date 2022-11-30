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
/*
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
*/

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/produzione.modal.todo.html'
    );

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/produzione.modal.attivita.html'
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
                'eta' => 'previsione',
                NULL => 'azioni'
            ),
            'class' => array(
                'nome' => 'text-left',
                'completed' => 'text-right',
                'eta' => 'nowrap',
                NULL => 'no-wrap'
            ),
            'onclick' => array(
                NULL => 'event.stopPropagation();'
            ),
            'etc' => array(
                '__force_backurl__' => 1
            )
        );

        // tendina tipologie
        $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_todo_view'
        );

        // tendina tipologie
        $ct['etc']['select']['tipologie_attivita'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL'
        );

        // tendina collaboratori
        $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static'
        );

        // tendina anni
        foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
            $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
        }

        // tendina settimane
        foreach( range( 1, 52 ) as $w ) {
            $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
        }

        // gestione default
	    require DIR_SRC_INC_MACRO . '_default.tools.php';

	    // gestione default
	    require DIR_SRC_INC_MACRO . '_default.view.php';

        // icone
        foreach( $ct['view']['data'] as &$row ) {
            $row[ NULL ] = '<a href="#" data-toggle="modal" data-target="#scorciatoia_todo" onclick="$(\'#todo_id_progetto\').val(\''.$row['id'].'\');$(\'#scorciatoia_todo\').modal(\'show\');"><i class="fa fa-tasks"></i></a>'.
                '<a href="#" data-toggle="modal" data-target="#scorciatoia_attivita" onclick="$(\'#attivita_id_progetto\').val(\''.$row['id'].'\');$(\'#scorciatoia_attivita\').modal(\'show\');"><i class="fa fa-pencil-square-o"></i></a>';
        }

        // debug
        // print_r( $ct['view'] );

        // TODO qui abbiamo una grande sfida... inserire view multiple nella stessa pagina!!!
        // si potrebbe sfruttare il fatto che ogni vista ha un suo ID? per esempio creare un array
        // $ct['views'] con sottochiave l'ID della vista e copiare lì il $ct['view'] di turno
        // prima di resettarlo?

    }
