<?php



    $ct['form']['table'] = 'documenti';

        // articoli recenti
	$ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT articoli_view.id, articoli_view.__label__ FROM articoli_view '
       
	);

    if( isset( $_REQUEST[ 'documenti' ] )  && !isset( $_SESSION['id_reso'] ) ){
        $_SESSION['id_reso'] = $_REQUEST[ 'documenti']['id'];
    }

    $ct['etc']['mastro'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM mastri WHERE nome = "magazzino resi"' ) ;

   
        $ct['etc']['id_tipologia'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "documento di reso"');
    
    if(!isset( $_REQUEST['documenti'] )){
        $ct['etc']['id_emittente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM anagrafica_view WHERE se_gestita = 1 LIMIT 1');
    
        if( $ct['etc']['id_tipologia'] && $ct['etc']['id_emittente'] ){
            $ct['etc']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT MAX(numero) FROM documenti WHERE id_tipologia = ? ', 
                                    array( array( 's' => $ct['etc']['id_tipologia'] ) ) )+1;
        }
    
    }


    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['coupon'] );
        unset($_REQUEST[ 'coupon' ]['id'] );
    }

    if( isset( $_REQUEST['__unset_reso__'] ) ){
        unset( $_SESSION['id_reso'] );
        unset($_REQUEST[ 'documenti' ]['id'] );
    }

    if( isset( $_REQUEST['coupon']['id'] ) && !isset( $_SESSION['coupon'] ) ){
        $_SESSION['coupon'] = $_REQUEST['coupon']['id'];
    }


    
    if( empty( $_REQUEST['coupon']['id'] ) && isset($_SESSION['coupon']) ){
        $_REQUEST['coupon']['id'] = $_SESSION['coupon'];
        $_REQUEST['coupon'] =  mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM coupon_view  WHERE id = ?', array( array( 's' =>  $_SESSION['coupon'] ) ) );

    }
  /*  if( isset( $_REQUEST['documenti']['id'] )  ){
        $_REQUEST['documenti'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM documenti_view  WHERE id = ?', array( array( 's' =>  $_REQUEST['documenti']['id'] ) ) );
        $ct['etc']['numero'] = $_REQUEST['documenti']['numero'];
        print_r('miaoooo');
    }*/

    if( isset( $_SESSION['id_reso'] ) && !isset( $_REQUEST['documenti']['id'] ) ){
        $_REQUEST['documenti'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM documenti_view  WHERE id = ?', array( array( 's' =>  $_SESSION['id_reso'] ) ) );
        $_REQUEST['documenti']['documenti_articoli'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli  WHERE id_documento = ?', array( array( 's' =>  $_SESSION['id_reso'] ) ) );

    }

    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';




   