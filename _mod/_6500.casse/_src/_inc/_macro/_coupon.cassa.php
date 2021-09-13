<?php


    $ct['form']['table'] = 'coupon';

    if( isset( $_REQUEST[ 'documenti' ] )  && !isset( $_SESSION['id_reso'] ) ){
        $_SESSION['id_reso'] = $_REQUEST[ 'documenti']['id'];
    }
    
    $ct['etc']['mastro'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM mastri WHERE nome = "magazzino resi"' ) ;

    if(!isset( $_REQUEST['documenti'] )){
        $ct['etc']['id_tipologia'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM tipologie_documenti WHERE nome = "documento di ritiro"');

        $ct['etc']['id_emittente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM anagrafica_view WHERE se_azienda_gestita = 1 LIMIT 1');
    
        if( $ct['etc']['id_tipologia'] && $ct['etc']['id_emittente'] ){
            $ct['etc']['numero'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT MAX(numero) FROM documenti WHERE id_tipologia = ? ', 
                                    array( array( 's' => $ct['etc']['id_tipologia'] ) ) )+1;
        }
    
    }


    if( isset( $_REQUEST['__unset__'] ) ){
        unset( $_SESSION['coupon'] );
        unset($_REQUEST[$ct['form']['table']]['id'] );
    }

    if( isset( $_REQUEST[$ct['form']['table']]['id'] ) && !isset( $_SESSION['coupon'] ) ){
        $_SESSION['coupon'] = $_REQUEST[$ct['form']['table']]['id'];
    }


    
    if( empty( $_REQUEST[$ct['form']['table']]['id'] ) && isset($_SESSION['coupon']) ){
        $_REQUEST[$ct['form']['table']]['id'] = $_SESSION['coupon'];
        $_REQUEST[$ct['form']['table']] =  mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM coupon_view  WHERE id = ?', array( array( 's' =>  $_SESSION['coupon'] ) ) );

    }

    if( isset( $_SESSION['id_reso'] ) && !isset( $_REQUEST['documenti'] ) ){
        $_REQUEST['documenti'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM documenti_view  WHERE id = ?', array( array( 's' =>  $_SESSION['id_reso'] ) ) );
    }

if( isset( $_REQUEST['documenti']['id'] ) ){
    $_REQUEST['documenti'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM documenti_view  WHERE id = ?', array( array( 's' =>  $_REQUEST['documenti']['id'] ) ) );
   
}
print_r($_REQUEST['documenti']);
print_r('ciao '.$_SESSION['id_reso']);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


   