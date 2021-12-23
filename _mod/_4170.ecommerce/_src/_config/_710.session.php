<?php

    /**
     * 
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
