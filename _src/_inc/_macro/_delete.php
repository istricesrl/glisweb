<?php

    /**
     * macro di cancellazione
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // rimpiazzo le parentesi tonde con le parentesi quadre
    $_REQUEST['__delete__']['target'] = str_replace( array( '(', ')' ), array( '[', ']' ), $_REQUEST['__delete__']['target'] );
    $_REQUEST['__delete__']['rollback'] = str_replace( array( '(', ')' ), array( '[', ']' ), $_REQUEST['__delete__']['rollback'] );

    // richiesta o conferma
    if( isset( $_REQUEST['__delete__']['conferma'] ) && $_REQUEST['__delete__']['conferma'] == 1 ) {

    // recupero eventuali errori di cancellazione
        // TODO se ci sono errori non lanciare l'header ma passare gli errori alla pagina

    // debug
        // session_write_close();
        // print_r( ob_get_status( true ) );

        // ritorno alla pagina richiedente
        header( 'Location: '.$_REQUEST['__delete__']['target'] );

    // status code che indica la redirezione
        $ct['page']['http']['status'] = 303;

    // debug
        // print_r( $_REQUEST );
        // if( headers_sent( $file, $line ) ) { echo $file . '->' . $line; } else { echo 'output non iniziato'; }

    } else {

        // la tabella arriva dalla querystring e finisce concatenata nelle query: solo un nome valido di una tabella esistente
        $tb = getTable( $cf['memcache']['connection'], $cf['mysql']['connection'], ( isset( $_REQUEST['__delete__']['table'] ) ) ? $_REQUEST['__delete__']['table'] : NULL );

        // recupero la __label__ dell'oggetto da cancellare
        if( ! empty( $tb ) && ! isset( $_REQUEST['__filesystem_mode__'] ) ) {
            $rm = getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $tb );
            $ct['__delete__']['__label__'] = mysqlSelectLabel( $cf['mysql']['connection'], $tb, $rm, ( isset( $_REQUEST['__delete__']['id'] ) ) ? $_REQUEST['__delete__']['id'] : NULL, ' LIMIT 1' );
        } elseif( empty( $tb ) ) {
            logger( 'cancellazione richiesta su una tabella non valida o inesistente', 'security', LOG_WARNING );
        }

        // timer
        timerCheck( $cf['speed'], 'fine recupero dati oggetto da cancellare' );

    }
