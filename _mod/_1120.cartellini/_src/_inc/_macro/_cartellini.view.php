<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */


    // tabella della vista
    $ct['view']['table'] = 'cartellini';
    
    // id della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
    );

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'mese' => 'mese',
        'anno' => 'anno',
        'id_anagrafica' => 'id_anagrafica',
        'anagrafica' => 'anagrafica',
        'approvato' => 'approvazione'        
    );

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'anagrafica' => 'text-left',
    );
    
    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/cartellini.view.filters.html';

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_collaboratore = 1');

    // preset filtri custom
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] = date('Y');
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
			if( $row['approvato'] == 1 ){ $row['approvato']='approvato';  }
			else {
			if( $row['approvato'] == 0 ){ $row['approvato']='da approvare';  }
			else { $row['approvato']='';  }
			}
		}
	}
    
