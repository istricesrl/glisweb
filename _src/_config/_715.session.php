<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // ribalto sulla $_SESSION i dati di $_REQUEST
	if( array_key_exists( '__view__', $_REQUEST ) ) {
	    $_SESSION['__view__'] = array_merge( $_SESSION['__view__'], $_REQUEST['__view__'] );
	}

    // ribalto sulla $_REQUEST i dati di $_SESSION
	$_REQUEST['__view__'] = &$_SESSION['__view__'];

    // ...
/*    if( isset( $_SESSION['__work__'][ $_REQUEST['__key__'] ]['items'][ $_REQUEST['__item__'] ] ) ) {
        unset( $_SESSION['__work__'][ $_REQUEST['__key__'] ]['items'][ $_REQUEST['__item__'] ] );
    }
*/
    // ribalto sulla $_SESSION i dati di $_REQUEST
	if( array_key_exists( '__work__', $_REQUEST ) ) {
        foreach( $_REQUEST['__work__'] as $key => $items ) {
            foreach( $items['items'] as $id => $item ) {

                if( isset( $_SESSION['__work__'][ $key ]['items'][ $id ] ) ) {
                    unset( $_SESSION['__work__'][ $key ]['items'][ $id ] );
                } else {
                    $_SESSION['__work__'][ $key ]['items'][ $id ] = $item;
                }

            }

        }

        //	    $_SESSION['__work__'] = array_replace_recursive( $_SESSION['__work__'], $_REQUEST['__work__'] );
	}

    // ribalto sulla $_REQUEST i dati di $_SESSION
	$_REQUEST['__work__'] = &$_SESSION['__work__'];

    // timestamp dell'ultima azione sulla sessione
	$_SESSION['used']			= time();

    // debug
	// print_r( $_REQUEST );
	// print_r( $_SESSION );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
