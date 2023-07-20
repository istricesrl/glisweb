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
        'id'                                    => array( 'tipe' => 'int',      'default' => NULL ),
    //    'id_iva'                              => array( 'tipe' => 'int',      'default' => NULL ),
        'id_listino'                            => array( 'tipe' => 'int',      'default' => 1 ),
        'session'                               => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_anagrafica'            => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_tipologia_anagrafica'  => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_account'               => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_anagrafica'            => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_tipologia_anagrafica'  => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_account'               => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_nome'                     => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_cognome'                  => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_denominazione'            => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_sdi'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_pec'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_codice_fiscale'           => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_partita_iva'              => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_indirizzo'                => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_cap'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_citta'                    => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_provincia'             => array( 'tipe' => 'int',      'default' => NULL ),
        'intestazione_telefono'                 => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_mail'                     => array( 'type' => 'string',   'default' => NULL ),
        'provider_pagamento'                    => array( 'type' => 'string',   'default' => NULL ),
        'fatturazione_id_tipologia_documento'   => array( 'type' => 'string',   'default' => NULL ),
        'fatturazione_sezionale'                => array( 'type' => 'string',   'default' => 'E' ),
        'fatturazione_strategia'                => array( 'type' => 'string',   'default' => NULL,  'values' => array( 'SINGOLA', 'MULTIPLA', NULL ) ),
        'codice_coupon'                         => array( 'type' => 'string',   'default' => NULL ),
        'timestamp_checkout'                    => array( 'tipe' => 'int',      'default' => NULL ),
    );

    // TODO occhio la timestamp_checkout dev'essere modificabile solo se l'utente ha i privilegi giusti (aggiuntere un campo all'array?)

    // provider di pagamento ammessi
    if( isset( $cf['ecommerce']['profile']['provider'] ) && is_array( $cf['ecommerce']['profile']['provider'] ) ) {
        $cf['ecommerce']['fields']['carrello']['provider_pagamento']['values'] = array_keys( $cf['ecommerce']['profile']['provider'] );
    }

    // TODO
    // aggiungere $cf['utm']['fields'] ai campi del carrello

    $cf['ecommerce']['fields']['articoli']      = array(
        'id'                            => array( 'tipe' => 'int',      'default' => NULL ),
        'id_articolo'                   => array( 'tipe' => 'string',   'default' => NULL ),
        'id_iva'                        => array( 'tipe' => 'int',      'default' => NULL ),
        'destinatario_id_anagrafica'    => array( 'type' => 'string',   'default' => NULL ),
        'id_rinnovo'                    => array( 'type' => 'int',      'default' => NULL ),
        'id_progetto'                   => array( 'type' => 'string',   'default' => NULL ),
        'quantita'                      => array( 'tipe' => 'int',      'default' => NULL ),
        'sconto_percentuale'            => array( 'tipe' => 'int',      'default' => NULL ),
        'sconto_valore'                 => array( 'tipe' => 'int',      'default' => NULL ),
    );

    // TODO occhio le colonne degli sconti devono essere modificabili solo se l'utente ha i privilegi giusti (aggiuntere un campo all'array?)
