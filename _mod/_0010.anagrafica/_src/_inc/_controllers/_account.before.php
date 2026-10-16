<?php

    /**
     * controller before (pre query) per la tabella account
     *
     * Questa controller viene invocata prima di ogni query relativa alla tabella account. In particolare, si occupa di
     * gestire il valore del campo password, in modo da fare l'hash quando si scrive la password e da eliminare la
     * password dai dati quando non va scritta.
     *
     * NOTA fino al 16/10/2026 il controller c'era solo in _AC000.account, e il form account di questo modulo mandava la
     * password che finiva in chiaro nella tabella account ( emerso su crm.trbitaly.com ); la controller() include i
     * controller con lo stesso nome di tutti i moduli attivi, quindi con entrambi i moduli attivi questo file e quello
     * di _AC000.account girano uno dopo l'altro: per questo non si rifa' l'hash di un valore che e' gia' un hash.
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

        // NOTA se sto scrivendo la password faccio l'hash, a meno che non lo sia gia'; altrimenti la tolgo dai dati

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
