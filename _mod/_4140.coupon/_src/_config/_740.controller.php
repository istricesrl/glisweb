<?php

    // debug
    // die( print_r( $_REQUEST, true ) );

    // NOTA __carrello__[__articoli__][{{ dati.id_articolo ~ dati.destinatario_id_anagrafica }}][id_coupon]
    // NOTA Array ( [__articolo__] => Array ( [id_articolo] => 1704731201 [quantita] => 1 [id_iva] => 5 [destinatario_id_anagrafica] => 20602 ) )

    // se è presente un carrello
    if( ! empty( $_SESSION['carrello']['articoli'] ) ) {

        // debug
        // die( print_r( $_SESSION['carrello']['articoli'], true ) );

        // se sto aggiungendo un coupon al carrello tramite il comando __add_coupon__
        if( isset( $_REQUEST['__add_coupon__'] ) ) {

            // cerco una riga senza coupon
            foreach( $_SESSION['carrello']['articoli'] as $k => $v ) {
                if( empty( $v['id_coupon'] ) ) {
                    $_REQUEST['__carrello__']['__articoli__'][$k]['id_coupon'] = $_REQUEST['__add_coupon__'];
                    break;
                }
            }

        }

        // se sto rimuovendo un coupon dal carrello tramite il comando __del_coupon__
        if( isset( $_REQUEST['__del_coupon__'] ) ) {

            // cerco tutte le righe con il coupon da rimuovere
            foreach( $_SESSION['carrello']['articoli'] as $k => $v ) {
                if( $v['id_coupon'] == $_REQUEST['__del_coupon__'] ) {
                    $_REQUEST['__carrello__']['__articoli__'][$k]['id_coupon'] = '';
                }
            }

        }

    } else {

        // debug
        // die( 'il carrello è vuoto' );

    }

    // debug
    // die( print_r( $_REQUEST, true ) );
    // die( print_r( $_REQUEST, true ) . print_r( $_SESSION['carrello'], true ) );
    // die( print_r( $_REQUEST['__carrello__'], true ) );
    // print_r( $_REQUEST['__carrello__'] );
