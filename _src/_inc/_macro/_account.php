<?php

    /**
     * macro dashboard
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // common
    $cf['fields']['account'] = array(
        'nome'                      => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'cognome'                   => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'email'                     => array(   'type' => 'string',     'table' => 'mail',              'default' => NULL,      'field' => 'indirizzo' )
    );

    // se esiste il ramo __account__ gestisco i dati
    if( isset( $_REQUEST['__account__'] ) ) {

        // array dei valori
        $vls = array();

        // riallineo la $_SESSION
        foreach( $cf['fields']['account'] as $field => $model ) {
            if( isset( $_REQUEST['__account__'][ $field ] ) ) {
                $_SESSION['account'][ $field ] = $_REQUEST['__account__'][ $field ];
                $vls[ $model['table'] ][ ( ( isset( $model['field'] ) ) ? $model['field'] : $field ) ] = $_REQUEST['__account__'][ $field ];
            }
        }

        // se l'account proviene dal database, aggiorno il database
        if( $_SESSION['account']['source'] == 'mysql' ) {

            // aggiorno l'anagrafica
            $idAnagrafica = mysqlInsertRow(
                $cf['mysql']['connection'],
                array_merge(
                    array( 'id' => $_SESSION['account']['id_anagrafica'] ),
                    $vls['anagrafica']
                ),
                'anagrafica'
            );

            // nel caso l'anagrafica sia appena stata inserita
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => $_SESSION['account']['id'],
                    'id_anagrafica' => $idAnagrafica
                ),
                'account'
            );

        }

    }

    // reiallineo la $_REQUEST
    foreach( $cf['fields']['account'] as $field => $model ) {
        if( isset( $_SESSION['account'][ $field ] ) ) {
            $_REQUEST['__account__'][ $field ] = $_SESSION['account'][ $field ];
        }
    }

    // debug
    // print_r( $_REQUEST );
    // print_r( $_SESSION['account'] );
