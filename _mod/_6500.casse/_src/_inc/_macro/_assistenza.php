<?php



$ct['view']['table'] = '';
$ct['form']['table'] = '';

// campi della vista
$ct['view']['cols'] = array(
    'id' => '#'
);

if( !isset( $_SESSION['assistenza']['id_progetto'] ) && isset( $_REQUEST['progetti']['id'] ) && !empty($_REQUEST['progetti']['id']) ){
    $_SESSION['assistenza']['id_progetto'] = $_REQUEST['progetti']['id'];
}

if( isset( $_REQUEST['id_contatto'] ) ){
    $_SESSION['contatto']['id'] = $_REQUEST['id_contatto'];
    $_SESSION['contatto']['nome'] = $_REQUEST['nome_contatto'];

    if( !empty( $_REQUEST['id_anagrafica'] )  ){
        $_SESSION['assistenza']['id_cliente'] = $_REQUEST['id_anagrafica'];
    }
}

if(  isset( $_REQUEST['todo']) && isset( $_REQUEST['todo']['__se_consenso__'] ) && $_REQUEST['todo']['__se_consenso__'] == 1 && !isset( $_SESSION['assistenza']['id_attivita_feedback'] ) ){

    $_SESSION['assistenza']['id_attivita_feedback'] = mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO attivita (id_anagrafica, id_tipologia, nome, data_programmazione, id_account_inserimento, timestamp_inserimento, id_todo, id_progetto, id_cliente ) '.
    'VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? )',
    array(
        array( 's' => (isset($_REQUEST['todo']['__id_anagrafica__']) ? $_REQUEST['todo']['__id_anagrafica__'] : NULL) ),
        array( 's' => '5' ),
        array( 's' => 'customer care a seguito di assistenza' ),
        array( 's' => date("Y-m-d" ,strtotime("+3 week")) ),
        array( 's' => $_SESSION['account']['id'] ),
        array( 's' => time() ),
        array( 's' => $_REQUEST['todo']['id'] ),
        array( 's' => $_REQUEST['todo']['id_progetto'] ),
        array( 's' => $_REQUEST['todo']['id_cliente'] )
    ) );

    if( !empty( $_SESSION['assistenza']['id_attivita_feedback'] ) && array_key_exists( 'attivita', $_SESSION['account']['id_gruppi_attribuzione'] ) && isset( $_SESSION['account']['id_gruppi_attribuzione']['attivita'][0] ) ){

        $acl = mysqlQuery( 
            $cf['mysql']['connection'], 
            'INSERT INTO __acl_attivita__ ( id_entita, id_gruppo, permesso ) VALUES ( ?, ?, ? )', 
            array( array( 's' => $_SESSION['assistenza']['id_attivita_feedback'] ), array( 's' => $_SESSION['account']['id_gruppi_attribuzione']['attivita'][0] ), array( 's' => 'FULL' )  ) );

    } 

}

if ( isset( $_SESSION['assistenza']['id_attivita_feedback'] ) ){
    $ct['etc']['data_attivita_feedback'] =  date("d/m/Y" ,strtotime("+3 week")) ;
   // print_r( $ct['etc']['data_attivita_feedback']);
}

if( isset( $_SESSION['contatto']['id_anagrafica'] ) ){

    $_SESSION['assistenza']['id_cliente'] = $_SESSION['contatto']['id_anagrafica'];

}

if( isset( $_SESSION['assistenza']['riapri'] ) && isset( $_REQUEST['__todo__']['id'] ) && !isset( $_SESSION['assistenza']['id_assistenza']) ){
    $_SESSION['assistenza']['id_assistenza'] = $_REQUEST['__todo__']['id'] ;
}

if( (isset($_REQUEST['__assistenza__']) && explode( '.', $_REQUEST['__assistenza__'] )[0] == 'TODO') || isset( $_SESSION['assistenza']['id_assistenza']) ){
 
    if( isset( $_SESSION['assistenza']['id_assistenza']) ){
        $todo =   $_SESSION['assistenza']['id_assistenza'];
    } else {
        $todo = ltrim(explode( '.', $_REQUEST['__assistenza__'] )[1], "0"); 
        $_SESSION['assistenza']['id_assistenza'] = $todo;
    }

   

    $ct['etc']['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $todo) ));
    $ct['etc']['attivita_completate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita_view_static WHERE id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => $todo) ));
    $ct['etc']['attivita_programmate'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita_view_static WHERE id_todo = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL  ORDER BY data_attivita', array( array( 's' => $todo) ));
    
   // $ct['etc']['attivita_collaudo'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM attivita_view_static WHERE tipologia = "collaudo" AND id_todo = ? ORDER BY id DESC LIMIT 1', array( array( 's' => $todo) ));
  
     $ct['form']['table'] = 'todo';
    if( !isset( $_REQUEST['todo']  ) ){
        $_REQUEST['todo'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $todo) ));
        if( !empty( $_REQUEST['todo']['timestamp_completamento'] ) ){
            $_REQUEST['todo']['timestamp_completamento'] = date( 'Y-m-d\TH:i', $_REQUEST['todo']['timestamp_completamento']) ;
        }    
        
    
    }
/*
    if( !isset( $_REQUEST['attivita']) && !empty($ct['etc']['attivita_collaudo']) ){
        $_REQUEST['attivita'] = mysqlSelectRow($cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE id = ?', array( array( 's' => $ct['etc']['attivita_collaudo']) ));
      
    }
*/

}



if( isset( $_REQUEST['__unset__'] ) ){

    if(  $_REQUEST['__unset__'] == 'cliente' ){

        unset( $_SESSION['assistenza']['id_cliente'] );
        if( isset($_SESSION['assistenza']['id_progetto']) ){unset( $_SESSION['assistenza']['id_progetto'] );}
    
    } elseif(  $_REQUEST['__unset__'] == 'progetto' ){

        unset( $_SESSION['assistenza']['id_progetto'] );
    
    } elseif(  $_REQUEST['__unset__'] == 'todo' ){

        unset( $_SESSION['assistenza']['id_todo'] );
    
    } else{
        unset($_REQUEST['attivita']['id']);
        unset( $_SESSION['assistenza']['id_attivita']  );
        unset( $_SESSION['assistenza']['id_attivita_feedback'] );
        unset( $_SESSION['assistenza']['riapri'] );
        unset( $_SESSION['assistenza']['id_cliente'] );
        unset( $_SESSION['assistenza']['id_progetto'] );
        unset( $_SESSION['assistenza']['id_todo']  );
        unset( $_SESSION['assistenza']['id_assistenza']);
        unset( $_SESSION['__view__'][ 'clienti' ]['__search__'] );
        unset( $_REQUEST['todo']['id'] );
    }

}


// id della vista
$ct['view']['id'] = md5( $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']);

if( isset( $_SESSION['assistenza']['id_cliente'] ) && !isset($ct['etc']['progetto'])  ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));
    
}

if( isset( $_SESSION['assistenza']['id_progetto'] ) && !isset($ct['etc']['progetto']) ){
    $ct['etc']['progetto'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_progetto']) ));
}

if( isset( $_REQUEST['__progetto__']['id'] )  ){

    $_SESSION['assistenza']['id_progetto'] = $_REQUEST['__progetto__']['id'];
    $ct['etc']['progetto'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_progetto']) ));

}

if( isset( $_REQUEST['__cliente__']['id'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) ){

    $_SESSION['assistenza']['id_cliente'] = $_REQUEST['__cliente__']['id'];
}

if( isset( $_REQUEST['__cliente_old__']['id'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) ){

    $_SESSION['assistenza']['id_cliente'] = $_REQUEST['__cliente_old__']['id'];
    $_SESSION['assistenza']['riapri'] = 1;
}

if( isset( $_SESSION['assistenza']['id_cliente'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) && !isset($_SESSION['assistenza']['riapri']) ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));

    // tabella della vista
	$ct['view']['table'] = 'progetti';

    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente',
        '__label__' => 'nome'
	);

    $ct['view']['__restrict__']['id_cliente']['EQ'] = $_SESSION['assistenza']['id_cliente'];
   
}

if( isset( $_SESSION['assistenza']['id_cliente'] ) && !isset( $_SESSION['assistenza']['id_progetto'] ) && isset($_SESSION['assistenza']['riapri']) ){
    $ct['etc']['cliente'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM anagrafica_view_static WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_cliente']) ));

    // tabella della vista
	$ct['view']['table'] = 'todo';

    // id della vista
   $ct['view']['id'] = md5( $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']);

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente',
        '__label__' => 'nome'
	);

    $ct['view']['__restrict__']['id_cliente']['EQ'] = $_SESSION['assistenza']['id_cliente'];
    $ct['view']['__restrict__']['timestamp_completamento']['NL'] = true;
}


if( !( isset( $_SESSION['assistenza']['id_cliente'] ) ) && isset( $_SESSION['__view__']['clienti_esistenti']['__search__'] ) && !empty($_SESSION['__view__']['clienti_esistenti']['__search__']) ){
    // tabella della vista
   $ct['view']['table'] = 'anagrafica';



   // id della vista
   $ct['view']['id'] = 'clienti_esistenti'; 
   
    // id della vista
   //$ct['view']['id'] = 'clienti';

        // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail',
	    'categorie' => 'categorie'
	);

}
if( !( isset( $_SESSION['assistenza']['id_cliente'] ) ) && isset( $_SESSION['__view__']['clienti']['__search__'] ) && !empty($_SESSION['__view__']['clienti']['__search__']) ){
    // tabella della vista
   $ct['view']['table'] = 'anagrafica';



   // id della vista
   $ct['view']['id'] = 'clienti'; 
   
    // id della vista
   //$ct['view']['id'] = 'clienti';

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
   //     $_REQUEST['todo'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_todo']) ));
    }

    if( isset( $_SESSION['assistenza']['id_todo'] ) && !isset($_SESSION['assistenza']['id_assistenza']) ){

     //   $_SESSION['assistenza']['id_todo'] = $_REQUEST['todo']['id'];
        $ct['form']['table'] = 'attivita';
        $_REQUEST['todo'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_todo']) ));
       // if( !$_REQUEST['todo'] ){ unset( $_SESSION['assistenza']['id_todo'] ); }

    }

    if( isset( $_REQUEST['attivita']['id'] ) && !empty( $_REQUEST['attivita']['id'] ) ){
        $_SESSION['assistenza']['id_attivita'] = $_REQUEST['attivita']['id'];

    }

    if( isset( $_SESSION['assistenza']['id_attivita'] ) ){

           $_REQUEST['attivita'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM attivita WHERE id = ?', array( array( 's' => $_SESSION['assistenza']['id_attivita']) ));   
           if( !$_REQUEST['attivita'] ){ unset( $_SESSION['assistenza']['id_attivita'] ); }
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

    $ct['etc']['tipologia_attivita'] = mysqlSelectValue(  $cf['mysql']['connection'],
        'SELECT id FROM tipologie_attivita WHERE nome = "diagnosi"');

   // macro di default
   require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
