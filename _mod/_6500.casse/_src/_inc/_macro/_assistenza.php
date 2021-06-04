<?php

$ct['view']['table'] = '';
$ct['form']['table'] = '';

// campi della vista
$ct['view']['cols'] = array(
    'id' => '#'
);
if( isset( $_REQUEST['__unset__'] ) ){

    if(  $_REQUEST['__unset__'] == 'cliente' ){

        unset( $_SESSION['assistenza']['id_cliente'] );
        if( isset($_SESSION['assistenza']['id_progetto']) ){unset( $_SESSION['assistenza']['id_progetto'] );}
    
    } elseif(  $_REQUEST['__unset__'] == 'progetto' ){

        unset( $_SESSION['assistenza']['id_progetto'] );
    
    } else{
    
        unset( $_SESSION['assistenza']['id_cliente'] );
        unset( $_SESSION['assistenza']['id_progetto'] );
        unset( $_SESSION['assistenza']['id_todo']  );
        unset( $_SESSION['assistenza']['id_attivita']  );
        unset( $_SESSION['__view__'][ 'clienti' ]['__search__'] );
    
    }

}


// id della vista
$ct['view']['id'] = md5( $ct['view']['table'] );

if( isset( $_SESSION['assistenza']['id_cliente'] ) && !isset($ct['etc']['progetto'])  ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));
    
}

if( isset( $_SESSION['assistenza']['id_progetto'] ) && !isset($ct['etc']['progetto']) ){
    $ct['etc']['progetto'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti_produzione_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_progetto']) ));
}

if( isset( $_REQUEST['__progetto__']['id'] )  ){

    $_SESSION['assistenza']['id_progetto'] = $_REQUEST['__progetto__']['id'];
    $ct['etc']['progetto'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti_produzione_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_progetto']) ));

}

if( isset( $_REQUEST['__cliente__']['id'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) ){

    $_SESSION['assistenza']['id_cliente'] = $_REQUEST['__cliente__']['id'];
}

if( isset( $_SESSION['assistenza']['id_cliente'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));

    // tabella della vista
	$ct['view']['table'] = 'progetti';

    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente',
        '__label__' => 'nome'
	);

    $ct['view']['__restrict__']['id_cliente']['EQ'] = $_SESSION['assistenza']['id_cliente'];
}



if( !( isset( $_SESSION['assistenza']['id_cliente'] ) ) ){
    // tabella della vista
   $ct['view']['table'] = 'anagrafica';

    // id della vista
    $ct['view']['id'] = 'clienti';

        // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail',
	    'categorie' => 'categorie'
	);

}

if( isset( $_SESSION['assistenza']['id_cliente'] ) && isset( $_SESSION['assistenza']['id_progetto'] ) && !isset( $_SESSION['assistenza']['id_todo'] ) ){

    $ct['form']['table'] = 'todo';
}

    if( isset( $_REQUEST['todo']['id'] ) && !empty($_REQUEST['todo']['id']) ){

        $_SESSION['assistenza']['id_todo'] = $_REQUEST['todo']['id'];
 //       $ct['form']['table'] = 'attivita';
   //     $_REQUEST['todo'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_todo']) ));
    }

    if( isset( $_SESSION['assistenza']['id_todo'] ) ){

     //   $_SESSION['assistenza']['id_todo'] = $_REQUEST['todo']['id'];
        $ct['form']['table'] = 'attivita';
        $_REQUEST['todo'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_todo']) ));
    
    }

    if( isset( $_REQUEST['attivita']['id'] ) && !empty( $_REQUEST['attivita']['id'] ) ){
        $_SESSION['assistenza']['id_attivita'] = $_REQUEST['attivita']['id'];

    }

    if( isset( $_SESSION['assistenza']['id_attivita'] ) ){

           $_REQUEST['attivita'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_attivita']) ));   
    }


    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 '  );

        $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM indirizzi_view' );

   // macro di default
   require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
   