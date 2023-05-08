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
        'denominazione'             => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'codice_fiscale'            => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'partita_iva'               => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'id_comune_nascita'         => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'giorno_nascita'            => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'mese_nascita'              => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'anno_nascita'              => array(   'type' => 'string',     'table' => 'anagrafica',        'default' => NULL ),
        'email'                     => array(   'type' => 'string',     'table' => 'mail',              'default' => NULL,      'field' => 'indirizzo' ),
        'telefono'                  => array(   'type' => 'string',     'table' => 'telefoni',          'default' => NULL,      'field' => 'numero' ),
        'cellulare'                 => array(   'type' => 'string',     'table' => 'telefoni',          'default' => NULL,      'field' => 'numero' ),
        'indirizzo'                 => array(   'type' => 'string',     'table' => 'indirizzi',         'default' => NULL ),
        'civico'                    => array(   'type' => 'string',     'table' => 'indirizzi',         'default' => NULL ),
        'cap'                       => array(   'type' => 'string',     'table' => 'indirizzi',         'default' => NULL ),
        'id_comune'                 => array(   'type' => 'string',     'table' => 'indirizzi',         'default' => NULL ),
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

        // riallineamenti forzati
        $_SESSION['account']['anagrafica'] = implode( ' ',
            array(
                $_SESSION['account']['cognome'],
                $_SESSION['account']['nome'],
                $_SESSION['account']['denominazione']
            )
        );

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
            $idAccount = mysqlInsertRow(
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

    // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM comuni_view'
	);

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][] = array('id' => $mese, '__label__' => int2month( $mese ) );
	}

    // tendina giorni
	foreach( range( 1, 31 ) as $giorno ) {
	    $ct['etc']['select']['giorni'][] = array( 'id' => $giorno.'', '__label__' =>  $giorno  );
	}

    // debug
    // print_r( $_REQUEST );
    // print_r( $_SESSION['account'] );
