<?php

    /**
     * 
     */

    // recupero carrelli abbandonati
    if( isset( $_REQUEST['rc'] ) && isset( $_REQUEST['ti'] ) ) {
            
        $timestamp = intval( $_REQUEST['ti'] );

        $_SESSION['carrello'] = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM carrelli WHERE id = ? AND timestamp_inserimento = ? AND timestamp_checkout IS NULL',
            array(
                array( 's' => $_REQUEST['rc'] ) ,
                array( 's' => $timestamp )
            )
        );
        
        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM carrelli_articoli WHERE id_carrello = ?',
            array(
                array( 's' => $_SESSION['carrello']['id'] )
            )
        );

        foreach( $articoli as $articolo ) {
            $_SESSION['carrello']['articoli'][ $articolo['id_articolo'] ] = $articolo;
        }

    }
/*
    // PayPal
	if( isset( $_REQUEST['item_number'] ) ) {

		// normalizzazione ID carrello
		$_SESSION['carrello']['id'] = $_REQUEST['item_number'];

    }

    // Nexi
	if( isset( $_REQUEST['codTrans'] ) ) {

		// normalizzazione ID carrello
		$_SESSION['carrello']['id'] = $_REQUEST['codTrans'];

    }
*/
    // verifico se il carrello della sessione corrente va chiuso
    if( isset( $_SESSION['carrello']['id'] ) ) {

        // se non è impostata la timestamp di checkout, la recupero dal database
        if( empty( $_SESSION['carrello']['timestamp_checkout'] ) ) {
            $_SESSION['carrello']['timestamp_checkout'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT timestamp_checkout FROM carrelli WHERE id = ?',
                array( array( 's' => $_SESSION['carrello']['id'] ) )
            );
        }

        // se il carrello corrente è chiuso, lo elimino dalla sessione
        if( ! empty( $_SESSION['carrello']['timestamp_checkout'] ) ) {
            $_SESSION['carrello'] = array();
        }

    }
