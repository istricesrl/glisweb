<?php


    $ct['form']['table'] = 'coupon';

    if( isset( $_REQUEST[$ct['form']['table']]['id'] ) ){
        $_SESSION['coupon'] = $_REQUEST[$ct['form']['table']]['id'];
    }
    
    if( empty( $_REQUEST[$ct['form']['table']] ) ){
        $_REQUEST[$ct['form']['table']] = $_SESSION['coupon'];
        $_REQUEST[$ct['form']['table']] =  mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM coupon_view  WHERE id = ?', array( array( 's' =>  $_SESSION['coupon'] ) ) );


    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


   