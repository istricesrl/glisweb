<?php

$ct['view']['table'] = '';

// campi della vista
$ct['view']['cols'] = array(
    'id' => '#'
);

if( isset( $_REQUEST['__unset__'] ) ){

    unset( $_SESSION['assistenza']['id_cliente'] );
    unset( $_SESSION['assistenza']['id_progetto'] );

}

// id della vista
$ct['view']['id'] = md5( $ct['view']['table'] );

if( isset( $_SESSION['assistenza']['id_cliente'] ) ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));
}

if( isset( $_SESSION['assistenza']['id_progetto'] ) ){
    $ct['etc']['progetto'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti_produzione_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_progetto']) ));
}

if( isset( $_REQUEST['__progetto__']['id'] )  ){

    $_SESSION['assistenza']['id_progetto'] = $_REQUEST['__progetto__']['id'];

}

if( isset( $_REQUEST['__cliente__']['id'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) ){

    $_SESSION['assistenza']['id_cliente'] = $_REQUEST['__cliente__']['id'];

    // tabella della vista
	$ct['view']['table'] = 'progetti_produzione';

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


   // macro di default
   require DIR_SRC_INC_MACRO . '_default.view.php';
   