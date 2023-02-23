<?php

    /**
     * 
     */

    // debug
    // echo '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';

    // recupero carrelli abbandonati
    if( isset( $_REQUEST['rc'] ) && isset( $_REQUEST['ti'] ) ) {

        // die('recupero carrello');

        $timestamp = intval( $_REQUEST['ti'] );
        $checkout = intval( ( isset( $_REQUEST['tc'] ) ) ? $_REQUEST['tc'] : NULL );

        $_SESSION['carrello'] = mysqlSelectRow(
            $cf['mysql']['connection'],
// OK            'SELECT * FROM carrelli WHERE id = ? AND timestamp_inserimento = ? AND ( timestamp_checkout IS NULL OR timestamp_checkout = ? ) AND timestamp_pagamento IS NULL',
            'SELECT * FROM carrelli WHERE id = ? AND timestamp_inserimento = ? AND ( timestamp_checkout IS NULL OR timestamp_checkout = ? )',
            array(
                array( 's' => $_REQUEST['rc'] ) ,
                array( 's' => $timestamp ),
                array( 's' => $checkout )
            )
        );

        $_SESSION['carrello']['timestamp_checkout'] = NULL;

        mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => $_SESSION['carrello']['id'],
                'timestamp_checkout' => NULL
            ),
            'carrelli'
        );

        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM carrelli_articoli WHERE id_carrello = ?',
            array(
                array( 's' => $_SESSION['carrello']['id'] )
            )
        );

        foreach( $articoli as $articolo ) {
            $_SESSION['carrello']['articoli'][ $articolo['id_articolo'].$articolo['destinatario_id_anagrafica'] ] = $articolo;
        }

        print_r( $_SESSION['carrello'] );

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
    // TODO cosa si rompe se spostiamo questo codice dopo la 750 controller?
    // così si eviterebbe che il carrello rimanga aperto per un'apertura di pagina dopo essere stato chiuso
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

    // debug
    // echo '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
