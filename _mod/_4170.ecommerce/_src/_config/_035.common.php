<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // link al profilo corrente
	$cf['ecommerce']['profile']			        = &$cf['ecommerce']['profiles'][ $cf['site']['status'] ];

    // campi di base del carrello
    $cf['ecommerce']['fields']['carrello']      = array(
        'id'                            => array( 'tipe' => 'int',      'default' => NULL ),
    //    'id_iva'                        => array( 'tipe' => 'int',      'default' => NULL ),
        'id_listino'                    => array( 'tipe' => 'int',      'default' => 1 ),
        'session'                       => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_anagrafica'    => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_anagrafica'    => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_nome'             => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_cognome'          => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_mail'             => array( 'type' => 'string',   'default' => NULL ),
        'provider_pagamento'            => array( 'type' => 'string',   'default' => NULL,  'values' => array_keys( $cf['ecommerce']['profile']['provider'] ) ),
    );
