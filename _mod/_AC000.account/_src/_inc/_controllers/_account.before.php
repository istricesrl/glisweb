<?php

    /**
     * controller before (pre query) per la tabella account
     *
     * Questa controller viene invocata prima di ogni query relativa alla tabella account. In particolare, si occupa di
     * gestire il valore del campo password, in modo da fare l'hash quando si scrive la password e da eliminare la 
     * password dai dati letti.
     *
     *
     *
     */

    // log
    logWrite( "controller before per $t/$a", 'controller' );

    // controllo azione corrente
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

        // NOTA se sto scrivendo la password, faccio l'hash; se sto leggendo i dati, elimino la password dai dati letti
        // NOTA lo stesso controller c'e' in _0010.anagrafica, e con entrambi i moduli attivi girano tutti e due: per questo
        // non si rifa' l'hash di un valore che e' gia' un hash

        if( ! empty( $vs['password']['s'] ) && empty( $vs['id_url']['s'] ) ) {
            if( empty( password_get_info( $vs['password']['s'] )['algo'] ) ) {
                $vs['password']['s'] = passwordHash( $vs['password']['s'] );
            }
        } else {
            unset( $vs['password'] );
            removeFromArray( $ks, 'password' );
        }

        break;

    }
